import 'dart:async';

import 'package:fde_restaurant_panel/controllers/controllers.dart';
import 'package:fde_restaurant_panel/dashboard.dart';
import 'package:fde_restaurant_panel/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static final String appRoute = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;
  final GlobalKey<ScaffoldState> _gloablKey = GlobalKey();
  int? initScreen;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final restaurantController = Get.put(RestaurantController());
  final ordersConroller = Get.put(OrdersController());
  final menuItemsConroller = Get.put(MenuItemsController());
  final costumerController = Get.put(CostumerController());

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    Timer(const Duration(seconds: 3), () {
      //  AuthRepository.instance.firebaseUser.value != null
      //       ? Get.offAllNamed(AppRoutes.dashboardScreenRoute)
      //       : Get.offAllNamed(AppRoutes.dashboardScreenRoute);

      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          print('not user null ');
          restaurantController.getRestaurantData();
          menuItemsConroller.loadMenuItems();
          ordersConroller.fetchOrders();
          costumerController.loadCostumers();
          Get.offAllNamed(Dashboard.appRoute);
        } else {
          print('user null ');

          Get.offAllNamed(SignInScreen.appRoute);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _gloablKey,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ScaleTransition(
            scale: animation,
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(right: 15, bottom: 10),
                child: Image.asset(
                  'assets/delevry-outline.gif',
                  width: 200,
                ),
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/logo.png',
              width: 200,
            ),
          ),
        ],
      ),
    );
  }
}
