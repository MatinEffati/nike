import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_store/data/repo/auth_repository.dart';
import 'package:nike_store/data/repo/cart_repository.dart';
import 'package:nike_store/ui/cart/cart.dart';
import 'package:nike_store/ui/home/home.dart';
import 'package:nike_store/ui/profile/profile.dart';
import 'package:nike_store/ui/widgets/badge.dart';

const int homeIndex = 0;
const int cartIndex = 1;
const int profileIndex = 2;

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedTabIndex = homeIndex;

  final List<int> _history = [];

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _cartKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    cartIndex: _cartKey,
    profileIndex: _profileKey
  };

  Future<bool> onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedTabIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedTabIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  void initState() {
    cartRepository.count();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: IndexedStack(
            index: selectedTabIndex,
            children: [
              _navigator(_homeKey, homeIndex, const HomeScreen()),
              _navigator(
                _cartKey,
                cartIndex,
                const CartScreen(),
              ),
              _navigator(
                _profileKey,
                profileIndex,
                ProfileScreen()
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: 'خانه'),
              BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(CupertinoIcons.cart),
                      Positioned(
                        right: -10,
                        child: ValueListenableBuilder<int>(
                          valueListenable: CartRepository.cartItemCountNotifier,
                          builder: (context, value, child) {
                            return Badge(value: value);
                          },
                        ),
                      ),
                    ],
                  ),
                  label: 'سبد خرید'),
              const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person), label: 'پروفایل')
            ],
            currentIndex: selectedTabIndex,
            onTap: (selectedIndex) {
              setState(() {
                _history.remove(selectedTabIndex);
                _history.add(selectedTabIndex);
                selectedTabIndex = selectedIndex;
              });
            },
          ),
        ),
        onWillPop: onWillPop);
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedTabIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => Offstage(
                offstage: selectedTabIndex != index,
                child: child,
              ),
            ),
          );
  }
}
