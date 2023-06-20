import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/models.dart';

class CostumerRepository extends GetxController {
  final CollectionReference _costumerCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<List<Costumer>> getCostumers() {
    try {
      return _costumerCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return Costumer.fromFirestore(doc);
        }).toList();
      });
    } catch (error) {
      rethrow;
    }
  }
}
