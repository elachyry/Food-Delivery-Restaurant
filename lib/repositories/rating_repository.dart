import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RatingRepository extends GetxController {
  final CollectionReference ratingsCollection =
      FirebaseFirestore.instance.collection('ratings');

  Stream<QuerySnapshot> streamRatings() {
    return ratingsCollection.orderBy('addedAt', descending: true).snapshots();
  }
}
