import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'login_controller.dart';

class MenuItemsController extends GetxController {
  final MenuItemsRepository _menuItemsRepo = Get.put(MenuItemsRepository());

  RxList<MenuItem> searchResults = RxList<MenuItem>([]);
  var isSidBarExpanded = false.obs;
  var pickedImage = Rxn<File>();
  var webImage = Rxn<Uint8List>();

  var isCleanName = true.obs;
  var isCleanDescription = true.obs;
  var isCleanPrice = true.obs;

  var isLoading = false.obs;
  var isLoading2 = true.obs;

  var isEditing = false.obs;
  var isShowInfos = false.obs;
  var isading = false.obs;

  var menuItem = Rxn<MenuItem>();

  var editImage = ''.obs;

  RxList<MenuItem> menuItems = RxList<MenuItem>([]);
  Stream<List<MenuItem>> get menuItemsStream => _menuItemsRepo.getMenuItems();
  final userController = Get.put(LoginController());

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _menuItemsRepo.init();
    if (userController.firebaseUser.value != null) {
      loadMenuItems();
    }
  }

  // void loadMenuItems() async {
  //   List<MenuItem> menuItems = await _menuItemsRepo.getMenuItems();
  //   _menuItems.value = menuItems;
  //   // print('test $menuItems');
  // }
  void loadMenuItems() {
    menuItemsStream.listen((restaurantList) {
      isLoading2.value = false;
      menuItems.value = restaurantList;
    });
  }

  void addMenuItem(MenuItem menuItem) async {
    isLoading.value = true;
    await _menuItemsRepo.createMenuItem(menuItem);
    loadMenuItems();
    isLoading.value = false;
  }

  void updateMenuItem(MenuItem menuItem) async {
    isLoading.value = true;
    await _menuItemsRepo.updateMenuItem(menuItem);
    loadMenuItems();
    isLoading.value = false;
  }

  void deleteMenuItem(MenuItem menuItem, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    await _menuItemsRepo.deleteMenuItem(menuItem.id);
    showSnackBar(
        'Succes', 'The menu item Deleted successfully ', Colors.green.shade400);
    loadMenuItems();
    Get.back();
  }

  void searchDocuments(String searchTerm) async {
    print('search $searchTerm');
    final results = await _menuItemsRepo.searchDocuments(searchTerm);
    searchResults.value = results;
    print(searchResults);
  }

  void showSnackBar(String titleText, String messageText, Color color) {
    Get.snackbar(titleText, messageText,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color,
        colorText: Colors.white,
        duration: const Duration(milliseconds: 2000));
  }
}
