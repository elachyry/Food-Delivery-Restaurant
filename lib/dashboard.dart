import 'package:fde_restaurant_panel/models/models.dart';
import 'package:fde_restaurant_panel/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/appBarActionItems.dart';
import '../component/barChart.dart';
import '../component/infoCard.dart';
import '../component/paymentDetailList.dart';
import '../component/sideMenu.dart';
import '../config/responsive.dart';
import '../config/size_config.dart';
import '../style/colors.dart';
import '../style/style.dart';
import 'controllers/controllers.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dashboard extends StatelessWidget {
  static final String appRoute = '/';
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final OrdersController ordersController = Get.put(OrdersController());
  final menuItemsController = Get.put(MenuItemsController());

  @override
  Widget build(BuildContext context) {
    double totaleTransactions = 0;
    for (var order in ordersController.orders) {
      if (getStatusValue(order.status) == 'Delivered') {
        totaleTransactions += order.total;
      }
    }
    SizeConfig().init(context);
    return Scaffold(
      key: _drawerKey,
      drawer: SizedBox(width: 100, child: SideMenu()),
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              elevation: 0,
              backgroundColor: AppColors.white,
              leading: IconButton(
                  onPressed: () {
                    _drawerKey.currentState!.openDrawer();
                  },
                  icon: Icon(Icons.menu, color: AppColors.black)),
              actions: [
                AppBarActionItems(),
              ],
            )
          : PreferredSize(
              preferredSize: Size.zero,
              child: SizedBox(),
            ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 1,
                child: SideMenu(),
              ),
            Expanded(
              flex: 10,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header(),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 4,
                      ),
                      Obx(() {
                        if (ordersController.orders.isEmpty ||
                            menuItemsController.menuItems.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return SizedBox(
                          width: SizeConfig.screenWidth,
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              InfoCard(
                                  icon: 'assets/clipboard.png',
                                  label: 'Orders',
                                  amount: ordersController.orders.length
                                      .toString()),
                              InfoCard(
                                  icon: 'assets/economy.png',
                                  label: 'Total transactions',
                                  amount:
                                      '${totaleTransactions.toStringAsFixed(2)} Dh'),
                              InfoCard(
                                  icon: 'assets/food.png',
                                  label: 'Product',
                                  amount: menuItemsController.menuItems.length
                                      .toString()),
                            ],
                          ),
                        );
                      }),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 4,
                      ),

                      if (Responsive.isDesktop(context))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Obx(() {
                              if (menuItemsController.menuItems.isEmpty) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.white,
                                  ),
                                  height: 250,
                                  child: CategoryPieChart(),
                                ),
                              );
                            }),
                            SizedBox(
                              width: SizeConfig.blockSizeVertical * 5,
                            ),
                            Obx(() {
                              if (ordersController.orders.isEmpty) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Expanded(
                                flex: 7,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.white,
                                  ),
                                  height: 250,
                                  child: OrderDounatChart(),
                                ),
                              );
                            }),
                          ],
                        ),
                      if (!Responsive.isDesktop(context))
                        Container(
                          height: 600,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Obx(() {
                                if (menuItemsController.menuItems.isEmpty) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Expanded(
                                  flex: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColors.white,
                                    ),
                                    height: 250,
                                    child: CategoryPieChart(),
                                  ),
                                );
                              }),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 5,
                              ),
                              Obx(() {
                                if (ordersController.orders.isEmpty) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Expanded(
                                  flex: 7,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColors.white,
                                    ),
                                    height: 250,
                                    child: OrderDounatChart(),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 5,
                      ),
                      Obx(
                        () {
                          if (ordersController.orders.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.white,
                            ),
                            height: 250,
                            child: OrdersBarChart(),
                          );
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 5,
                      ),
                      Obx(
                        () {
                          if (ordersController.orders.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.white,
                            ),
                            height: 250,
                            child: OrdersLineChart(),
                          );
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      if (!Responsive.isDesktop(context)) PaymentDetailList()
                    ],
                  ),
                ),
              ),
            ),
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 4,
                child: SafeArea(
                  child: Container(
                    width: double.infinity,
                    height: SizeConfig.screenHeight,
                    decoration: BoxDecoration(color: Colors.white),
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                      child: Column(
                        children: [
                          // AppBarActionItems(),
                          PaymentDetailList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
