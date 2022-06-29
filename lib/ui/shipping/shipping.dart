import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/data/order.dart';
import 'package:nike_store/data/repo/order_repository.dart';
import 'package:nike_store/ui/cart/price_info.dart';
import 'package:nike_store/ui/payment_webview.dart';
import 'package:nike_store/ui/receipt/payment_receipt.dart';
import 'package:nike_store/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  ShippingScreen(
      {Key? key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice})
      : super(key: key);
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'متین');

  final TextEditingController _lastNameController =
      TextEditingController(text: 'عفتی');

  final TextEditingController _phoneNumberController =
      TextEditingController(text: '09398300660');

  final TextEditingController _postalCodeController =
      TextEditingController(text: '3654657386');

  final TextEditingController _addressCodeController =
      TextEditingController(text: 'کرج فردیس خیابان سی و هشتم ساختمان حسام');

  StreamSubscription? subscription;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گیرنده'),
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          subscription = bloc.stream.listen((state) {
            if (state is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.exception.message),
              ));
            } else if (state is ShippingSuccess) {
              if (state.data.bankGatewayUrl.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentGatewayScreen(
                      bankGatewayUrl: state.data.bankGatewayUrl,
                    ),
                  ),
                );
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PaymentReceiptScreen(orderId: state.data.orderId),
                ));
              }
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  label: Text('نام'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  label: Text('نام خانوادگی'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  label: Text('شماره تماس'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  label: Text('کدپستی'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: _addressCodeController,
                decoration: const InputDecoration(
                  label: Text('آدرس تحویل گیرنده'),
                ),
              ),
              PriceInfo(
                payablePrice: widget.payablePrice,
                totalPrice: widget.totalPrice,
                shippingCost: widget.shippingCost,
              ),
              BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  return state is ShippingLoading
                      ? const CupertinoActivityIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                BlocProvider.of<ShippingBloc>(context).add(
                                  ShippingCreateOrder(
                                    CreateOrderParams(
                                      _nameController.text,
                                      _lastNameController.text,
                                      _phoneNumberController.text,
                                      _postalCodeController.text,
                                      _addressCodeController.text,
                                      PaymentMethod.cashOnDelivery,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('پرداخت در محل'),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<ShippingBloc>(context).add(
                                  ShippingCreateOrder(
                                    CreateOrderParams(
                                      _nameController.text,
                                      _lastNameController.text,
                                      _phoneNumberController.text,
                                      _postalCodeController.text,
                                      _addressCodeController.text,
                                      PaymentMethod.online,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('پرداخت اینترنتی'),
                            ),
                          ],
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
