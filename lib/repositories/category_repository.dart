import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/category.dart';

class CategoryRepository extends GetxController {
  CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  Stream<QuerySnapshot> getCategoryStream() {
    return _categoryCollection.snapshots();
  }

  Future<void> addCategory(Category category) {
    return _categoryCollection.doc().set({
      'name': category.name,
      'imageUrl': category.imageUrl,
    });
  }
}
