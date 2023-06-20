import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers.dart';

class RestaurantController extends GetxController {
  final firestore = FirebaseFirestore.instance;
  final userController = Get.put(LoginController());

  var myData = {}.obs;
  var isLoading = false.obs;

  // var pickedImage = Rxn<File>();
  // var webImage = Rxn<Uint8List>();

  // var pickedImageLogo = Rxn<File>();
  // var webImageLogo = Rxn<Uint8List>();

  void getRestaurantData() async {
    final DocumentSnapshot snapshot = await firestore
        .collection('restaurants')
        .doc(userController.firebaseUser.value!.uid)
        .get();
    if (snapshot.exists) {
      myData.value = snapshot.data() as Map<dynamic, dynamic>;
      // print('restaurnts $myData');
    }
  }

  Future<void> updateRestaurant(Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      await firestore
          .collection('restaurants')
          .doc(userController.firebaseUser.value!.uid)
          .update(data);
      isLoading.value = false;
      getRestaurantData();
      showSnackBar('Sucses', 'your restaurant informaions has been updated',
          Colors.green.shade400);
    } catch (e) {
      isLoading.value = false;
      showSnackBar('Error', 'An error occurred, please try again later.',
          Colors.red.shade500);
    }
  }

  void showSnackBar(String titleText, String messageText, Color color) {
    Get.snackbar(titleText, messageText,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color,
        colorText: Colors.white,
        duration: const Duration(milliseconds: 2000));
  }
}
