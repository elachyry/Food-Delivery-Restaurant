import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/appBarActionItems.dart';
import '../../component/header.dart';
import '../../component/sideMenu.dart';
import '../../config/responsive.dart';
import '../../config/size_config.dart';
import '../../controllers/menu_items_controller.dart';
import '../../style/colors.dart';
import '../../widgets/widgets.dart';

class MenuItemsScreen extends StatelessWidget {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  static final String appRoute = '/menu-item';
  final menuItemsController = Get.put(MenuItemsController());

  final searchController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final categoriesController = SingleValueDropDownController();
  final ingrediantsController = MultiValueDropDownController();
  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
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
                      Header(
                        searchController: searchController,
                        descriptionController: descriptionController,
                        priceController: priceController,
                        nameController: nameController,
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 4,
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 5,
                      ),
                      Obx(() {
                        if (menuItemsController.isLoading2.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (menuItemsController.menuItems.isEmpty) {
                          Future.delayed(Duration(seconds: 3), () {
                            if (menuItemsController.menuItems.isEmpty) {
                              // menuItemsController.menuItems.add(MenuItem()); // Add a placeholder menu item
                            }
                          });
                          return Center(
                            child: Image.asset(
                              'assets/man.png',
                              width: 100,
                              height: 100,
                            ),
                          );
                        } else {
                          return Container(
                            height: SizeConfig.screenHeight,
                            child: GridView(
                              padding: const EdgeInsets.all(20),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      // mainAxisExtent: 200,
                                      childAspectRatio:
                                          Responsive.isMobile(context)
                                              ? 1
                                              : Responsive.isTablet(context)
                                                  ? 1
                                                  : 3 / 4,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      crossAxisCount:
                                          Responsive.isMobile(context)
                                              ? 1
                                              : Responsive.isTablet(context)
                                                  ? 2
                                                  : 3),
                              children: menuItemsController.menuItems
                                  .map(
                                    (e) => SizedBox(
                                      width: 250,
                                      child: MenuItems(
                                        key: ValueKey(e.id),
                                        menuItem: e,
                                        categoriesController:
                                            categoriesController,
                                        descriptionController:
                                            descriptionController,
                                        ingrediantsController:
                                            ingrediantsController,
                                        nameController: nameController,
                                        priceController: priceController,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        }
                      }),
                      if (!Responsive.isDesktop(context))
                        AddProduct(
                          categoriesController: categoriesController,
                          descriptionController: descriptionController,
                          ingrediantsController: ingrediantsController,
                          nameController: nameController,
                          priceController: priceController,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (Responsive.isDesktop(context))
              Obx(
                () => Expanded(
                  flex: 4,
                  child: SafeArea(
                    child: Container(
                      width: double.infinity,
                      height: SizeConfig.screenHeight,
                      decoration: BoxDecoration(color: Colors.white),
                      child: SingleChildScrollView(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                        child: Column(
                          children: [
                            // AppBarActionItems(),
                            menuItemsController.isShowInfos.value
                                ? MenuItemShowInfos()
                                : AddProduct(
                                    categoriesController: categoriesController,
                                    descriptionController:
                                        descriptionController,
                                    ingrediantsController:
                                        ingrediantsController,
                                    nameController: nameController,
                                    priceController: priceController,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
