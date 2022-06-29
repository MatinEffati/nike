import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/repo/auth_repository.dart';
import 'package:nike_store/data/repo/cart_repository.dart';
import 'package:nike_store/ui/auth/auth.dart';
import 'package:nike_store/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_store/ui/cart/cart_item.dart';
import 'package:nike_store/ui/cart/price_info.dart';
import 'package:nike_store/ui/shipping/shipping.dart';
import 'package:nike_store/ui/widgets/empty_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartBloc? cartBloc;
  final RefreshController _refreshController = RefreshController();
  StreamSubscription? stateStreamSubscription;
  bool stateIsSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('سبد خرید'),
      ),
      floatingActionButton: Visibility(
        visible: stateIsSuccess,
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 48,right: 48),
          child: FloatingActionButton.extended(onPressed: () {
            final state = cartBloc?.state;
            if(state is CartSuccess){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShippingScreen(
                payablePrice: state.cartResponse.payablePrice,
                totalPrice: state.cartResponse.totalPrice,
                shippingCost: state.cartResponse.shippingCost,
              ),));
            }
          }, label: const Text('پرداخت')),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocProvider<CartBloc>(
        create: (context) {
          final bloc = CartBloc(
            cartRepository,
          )..add(CartStarted(AuthRepository.authChangeNotifier.value));
          stateStreamSubscription = bloc.stream.listen((state) {
              setState((){
                stateIsSuccess = state is CartSuccess;
              });

            if (_refreshController.isRefresh) {
              if (state is CartSuccess) {
                _refreshController.refreshCompleted();
              } else if (state is CartError) {
                _refreshController.refreshFailed();
              }
            }
          });
          cartBloc = bloc;
          return bloc;
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CartError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is CartSuccess) {
              return SmartRefresher(
                header: const ClassicHeader(
                  completeText: 'با موفقیت انجام شد',
                  refreshingText: 'در حال بارگذاری',
                  idleText: 'برای بارگذاری مجدد پایین بکشید',
                  releaseText: 'رها کنید',
                  failedText: 'بارگذاری ناموفق',
                  spacing: 2,
                ),
                onRefresh: () {
                  cartBloc?.add(CartStarted(
                      AuthRepository.authChangeNotifier.value,
                      isRefreshing: true));
                },
                controller: _refreshController,
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 80),
                  physics: defaultScrollPhysics,
                  itemCount: state.cartResponse.cartItems.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.cartResponse.cartItems.length) {
                      final data = state.cartResponse.cartItems[index];
                      return CartItem(
                        data: data,
                        onDeleteButtonClicked: () {
                          cartBloc?.add(CartDeleteButtonClicked(data.id));
                        },
                        onIncreaseButtonClicked: () {
                          cartBloc?.add(CartIncreaseCountButtonClicked(data.id));
                        },
                        onDecreaseButtonClicked: () {
                          if(data.count>1){
                            cartBloc?.add(CartDecreaseCountButtonClicked(data.id));
                          }
                        },
                      );
                    } else {
                      return PriceInfo(
                        payablePrice: state.cartResponse.payablePrice,
                        shippingCost: state.cartResponse.shippingCost,
                        totalPrice: state.cartResponse.totalPrice,
                      );
                    }
                  },
                ),
              );
            } else if (state is CartAuthRequired) {
              return EmptyView(
                  message: Padding(
                    padding: const EdgeInsets.fromLTRB(48, 24, 48, 16),
                    child: Text(
                      'برای مشاهده سبد خرید ابتدا وارد حساب کاربری خود شوید.',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  callToAction: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(),
                        ),
                      );
                    },
                    child: const Text('ورود به حساب کاربری'),
                  ),
                  image: SvgPicture.asset(
                    'assets/img/auth_required.svg',
                    width: 120,
                  ));
            } else if (state is CartEmpty) {
              return EmptyView(
                message: Padding(
                  padding: const EdgeInsets.fromLTRB(48, 24, 48, 16),
                  child: Text(
                    'تاکنون هیچ محصولی به سبد خرید خود اضافه نکردید.',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                callToAction: null,
                image: SvgPicture.asset(
                  'assets/img/empty_cart.svg',
                  width: 120,
                ),
              );
            } else {
              throw Exception('current cart state is not valid');
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
  }

  void authChangeNotifierListener() {
    cartBloc?.add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }

  @override
  void dispose() {
    cartBloc?.close();
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    _refreshController.dispose();
    stateStreamSubscription?.cancel();
    super.dispose();
  }
}
