import 'package:fde_restaurant_panel/dashboard.dart';
import 'package:fde_restaurant_panel/screens/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../config/size_config.dart';
import '../controllers/controllers.dart';
import '../style/colors.dart';

class SideMenu extends StatelessWidget {
  SideMenu({
    super.key,
  });

  final menuItemsController = Get.put(MenuItemsController());
  final ratingController = Get.put(RatingController());
  final restaurantController = Get.put(RestaurantController());
  final ordersController = Get.put(OrdersController());
  final ordersConroller = Get.put(OrdersController());
  final menuItemsConroller = Get.put(MenuItemsController());
  final costumerController = Get.put(CostumerController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        width: double.infinity,
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(color: AppColors.secondaryBg),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/delevry-outline.gif',
                    width: 40,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Image.asset(
                    'assets/logo.png',
                    width: 40,
                  ),
                ],
              ),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/home.svg',
                    color: AppColors.iconGray,
                  ),
                  onPressed: () {
                    restaurantController.getRestaurantData();
                    menuItemsConroller.loadMenuItems();
                    ordersConroller.fetchOrders();
                    costumerController.loadCostumers();
                    Get.toNamed(Dashboard.appRoute);
                  }),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/clipboard.svg',
                    color: AppColors.iconGray,
                  ),
                  onPressed: () {
                    ordersController.fetchOrders();
                    Get.toNamed(OrdersScreen.appRoute);
                  }),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: Icon(
                    Icons.grid_view_outlined,
                    color: AppColors.iconGray,
                  ),
                  onPressed: () {
                    menuItemsController.loadMenuItems();
                    ratingController.fetchRatings();

                    Get.toNamed(MenuItemsScreen.appRoute);
                  }),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: Icon(
                    Icons.person,
                    color: AppColors.iconGray,
                  ),
                  onPressed: () {
                    restaurantController.getRestaurantData();

                    Get.toNamed(ProfileScreen.appRoute);
                  }),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    final loginController = Get.put(LoginController());
                    loginController.signOut();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
