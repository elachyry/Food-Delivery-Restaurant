import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../controllers/controllers.dart';
import '../models/models.dart' as order;

class OrdersRepository extends GetxController {
  final CollectionReference<Map<String, dynamic>> _ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  List<String> userId = [];

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  final userController = Get.put(LoginController());

  Future<Map<String, dynamic>> getAllUsers() async {
    final querySnapshot = await _usersCollection.get();
    final usersMap = <String, dynamic>{};

    querySnapshot.docs.forEach((doc) {
      final userId = doc.id;
      final userData = doc.data();
      usersMap[userId] = userData;
    });

    return usersMap;
  }

  Future<List<order.Order>> getOrders() async {
    List<order.Order> orders = [];

    try {
      final querySnapshot = await _usersCollection.get();
      userId = querySnapshot.docs.map((doc) {
        return doc.id;
      }).toList();

      for (var element in userId) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .doc(element)
            .collection('orders')
            .where('restaurantId',
                isEqualTo: userController.firebaseUser.value!.uid)
            .orderBy('addedAt', descending: true)
            .get();

        orders.addAll(
          querySnapshot.docs.map((doc) => order.Order.fromFirestore(doc)),
        );
      }
      // print('test $orders');
      return orders;
    } catch (error) {
      // Handle the error
      rethrow;
    }
  }

  Future<void> changeOrderStatus(
      String id, String userId, String status) async {
    return FirebaseFirestore.instance
        .collection('orders')
        .doc(userId)
        .collection('orders')
        .doc(id)
        .update({'status': status});
  }
}
