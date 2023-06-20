import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controllers.dart';
import '../models/models.dart';

class MenuItemsRepository extends GetxService {
  late FirebaseFirestore _firestore;

  final userController = Get.put(LoginController());
  final categoryController = Get.put(CategoryController());

  List<MenuItem> menuItems = [];

  Future<void> init() async {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> createMenuItem(MenuItem menuItem) async {
    try {
      CollectionReference menuItemsCollection =
          FirebaseFirestore.instance.collection('menuItems');
      DocumentReference restaurantDocRef =
          menuItemsCollection.doc((userController.firebaseUser.value!.uid));

      CollectionReference restaurantMenuItemsCollection =
          restaurantDocRef.collection('items');
      await restaurantMenuItemsCollection
          .doc(menuItem.id)
          .set(menuItem.toMap());

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(userController.firebaseUser.value!.uid)
          .update({
        'menuItemsId': FieldValue.arrayUnion([menuItem.id])
      });

      final DocumentSnapshot restaurantSnapshot = await FirebaseFirestore
          .instance
          .collection('restaurants')
          .doc(userController.firebaseUser.value!.uid)
          .get();
      final List<dynamic> tagsList = restaurantSnapshot['tags'];

      if (!tagsList.contains(categoryController.categories
          .firstWhere((element) => element.id == menuItem.categoryId)
          .name)) {
        tagsList.add(categoryController.categories
            .firstWhere((element) => element.id == menuItem.categoryId)
            .name);
        await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(userController.firebaseUser.value!.uid)
            .update({'tags': tagsList});
      }

      // await FirebaseFirestore.instance
      //     .collection('restaurants')
      //     .doc(userController.firebaseUser.value!.uid)
      //     .update({
      //   'tags': FieldValue.arrayUnion(
      //     [
      //       categoryController.categories
      //           .firstWhere((element) => element.id == menuItem.categoryId)
      //           .name,
      //     ],
      //   )
      // });

      userController.showSnackBar(
          'Succes', 'The menu item Added successfully ', Colors.green.shade400);
      // await _firestore
      //     .collection('menuItems')
      //     .doc(menuItem.id)
      //     .set(menuItem.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Future<List<MenuItem>> getMenuItems() async {
  //   try {
  //     CollectionReference menuItemsCollection =
  //         FirebaseFirestore.instance.collection('menuItems');
  //     DocumentReference restaurantDocRef =
  //         menuItemsCollection.doc((userController.firebaseUser.value!.uid));

  //     CollectionReference restaurantMenuItemsCollection =
  //         restaurantDocRef.collection('items');

  //     QuerySnapshot querySnapshot = await restaurantMenuItemsCollection.get();

  //     // QuerySnapshot querySnapshot =
  //     //     await _firestore.collection('menuItems').get();
  //     querySnapshot.docs.forEach((doc) {
  //       menuItems.add(MenuItem.fromFirestore(doc));
  //     });
  //     return menuItems;
  //   } catch (e) {
  //     userController.showSnackBar(
  //         'Error', 'Error getting menu items', Colors.red.shade400);
  //     print('Error getting menu items: $e');
  //     return [];
  //   }

  Stream<List<MenuItem>> getMenuItems() {
    // final querySnapshot =
    //     await _restaurantCollection.doc(restaurantId).collection('items').get();
    //     return querySnapshot.docs
    //     .map((doc) => MenuItem.fromFirestore(doc))
    //     .toList();

    return FirebaseFirestore.instance
        .collection('menuItems')
        .doc(userController.firebaseUser.value!.uid)
        .collection('items')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        // print('test ${MenuItem.fromFirestore(doc)}');
        return MenuItem.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> updateMenuItem(MenuItem menuItem) async {
    try {
      CollectionReference menuItemsCollection =
          FirebaseFirestore.instance.collection('menuItems');
      DocumentReference restaurantDocRef =
          menuItemsCollection.doc((userController.firebaseUser.value!.uid));

      CollectionReference restaurantMenuItemsCollection =
          restaurantDocRef.collection('items');

      await restaurantMenuItemsCollection
          .doc(menuItem.id)
          .update(menuItem.toMap());
      userController.showSnackBar('Succes',
          'The menu item Updated successfully ', Colors.green.shade400);
    } catch (e) {
      print('Error updating menu item: $e');
    }
  }

  Future<void> deleteMenuItem(String menuItemId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('menuItems')
          .doc(userController.firebaseUser.value!.uid)
          .collection('items')
          .get();

      menuItems =
          querySnapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();

      getMenuItems().listen((restaurantList) {
        menuItems = restaurantList;
      });
      // print(menuItems);
      MenuItem menuItem =
          menuItems.firstWhere((element) => element.id == menuItemId);

      String categoryName = categoryController.categories
          .firstWhere((element) => element.id == menuItem.categoryId)
          .name;
      CollectionReference menuItemsCollection =
          FirebaseFirestore.instance.collection('menuItems');
      DocumentReference restaurantDocRef =
          menuItemsCollection.doc((userController.firebaseUser.value!.uid));

      final menu1 = menuItems;
      print('menu1 $menu1');

      CollectionReference restaurantMenuItemsCollection =
          restaurantDocRef.collection('items');
      await restaurantMenuItemsCollection.doc(menuItemId).delete();

      final menu2 = menuItems;
      print('menu1 $menu2');

      final DocumentSnapshot restaurantSnapshot = await FirebaseFirestore
          .instance
          .collection('restaurants')
          .doc(userController.firebaseUser.value!.uid)
          .get();

      final List<dynamic> menuItemsIdList = restaurantSnapshot['menuItemsId'];

      menuItemsIdList.remove(menuItemId);
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(userController.firebaseUser.value!.uid)
          .update({'menuItemsId': menuItemsIdList});

      // final List<dynamic> tagsList = restaurantSnapshot['tags'];
      final list = (menu2
              .where((element) =>
                  element.restaurantId ==
                  userController.firebaseUser.value!.uid)
              .map((e) => categoryController.categories
                  .firstWhere((category) => category.id == e.categoryId)
                  .name)
              .toSet())
          .toList();

      // print('tagsList $list');
      // print('categoryName $categoryName');

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(userController.firebaseUser.value!.uid)
          .update({'tags': list});

      Get.back();
    } catch (e) {
      Get.back();
      userController.showSnackBar('Error',
          'An error occurred, please try again later.', Colors.red.shade400);
      print('Error deleting menu item: $e');
    }
  }

  Future<List<MenuItem>> searchDocuments(String searchTerm) async {
    CollectionReference menuItemsCollection =
        FirebaseFirestore.instance.collection('menuItems');
    DocumentReference restaurantDocRef =
        menuItemsCollection.doc((userController.firebaseUser.value!.uid));

    CollectionReference restaurantMenuItemsCollection =
        restaurantDocRef.collection('items');
    List<MenuItem> menuItems = [];
    if (searchTerm.isNotEmpty) {
      final querySnapshot = await restaurantMenuItemsCollection
          .where('name', isEqualTo: searchTerm)
          .get();
      querySnapshot.docs.forEach((doc) {
        menuItems.add(MenuItem.fromFirestore(doc));
      });
      return menuItems;
    } else {
      return [];
    }
  }
}
