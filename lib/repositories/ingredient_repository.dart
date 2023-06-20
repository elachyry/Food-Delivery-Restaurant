import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/ingredient.dart';

class IngredientRepository extends GetxController {
  CollectionReference _ingredientCollection =
      FirebaseFirestore.instance.collection('ingredient');

  Stream<QuerySnapshot> getIngredientStream() {
    return _ingredientCollection.snapshots();
  }

  Future<void> addIngrediant(Ingredient ingredient) {
    return _ingredientCollection.doc().set({
      'name': ingredient.name,
      'imageUrl': ingredient.imageUrl,
    });
  }
}
