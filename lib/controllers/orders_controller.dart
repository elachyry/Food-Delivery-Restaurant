import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/order.dart' as order;
import '../repositories/repositories.dart';

class OrdersController extends GetxController {
  final OrdersRepository _repository = OrdersRepository();
  RxList<order.Order> orders = <order.Order>[].obs;
  var users = {}.obs;

  var orderInfos = Rxn<order.Order>();

  // Stream<List<order.Order>> get ordersStream => _repository.getOrders();
  // List<order.Order> get orders => _orders;
  var isLoading = false.obs;
  var isLoading2 = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    getUsers();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   fetchOrders();
  // }

  Future<void> fetchOrders() async {
    List<order.Order> fetchedOrders = await _repository.getOrders();
    orders.value = fetchedOrders;
  }

  Future<void> getUsers() async {
    Map<String, dynamic> fetchedUsers = await _repository.getAllUsers();
    users.value = fetchedUsers;
  }

  Future<void> changeOrderStatus(
      String id, String userId, String status) async {
    try {
      await _repository.changeOrderStatus(id, userId, status);
      fetchOrders();
      if (status == 'Accepte') {
        showSnackBar(
            'Success',
            'You have  been accepted the Order successfully.',
            Colors.green.shade400);
      } else if (status == 'Denied') {
        showSnackBar('Success', 'You have  been denied the Order successfully.',
            Colors.green.shade400);
      } else if (status == 'Delivered') {
        showSnackBar(
            'Success',
            'You have  been mark the Order as delivered successfully.',
            Colors.green.shade400);
      }
    } catch (error) {
      showSnackBar('Error', 'An error occurred, please try again later.',
          Colors.red.shade400);
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
