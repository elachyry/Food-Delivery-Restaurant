import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';

class RatingController extends GetxController {
  final RatingRepository _ratingRepository = Get.put(RatingRepository());

  final List<Rating> ratings = <Rating>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRatings();
  }

  void fetchRatings() {
    _ratingRepository.streamRatings().listen((snapshot) {
      final List<Rating> fetchedRatings = [];
      for (final ratingDoc in snapshot.docs) {
        // final ratingData = ratingDoc.data() as Map<String, dynamic>;
        final rating = Rating.fromFireStore(ratingDoc);
        fetchedRatings.add(rating);
      }
      ratings.assignAll(fetchedRatings);
    });
  }

  Stream<QuerySnapshot> streamRatings() {
    return _ratingRepository.streamRatings();
  }

  Rating? getRating(String costumerId, String restaurantId, String menuIremId) {
    List<Rating> matchingRatings = [];

    if (restaurantId == '') {
      matchingRatings = ratings
          .where((rating) =>
              rating.menuItemId == menuIremId && rating.custmerId == costumerId)
          .toList();
    } else {
      matchingRatings = ratings.where((rating) {
        return rating.restaurantId == restaurantId &&
            rating.custmerId == costumerId;
      }).toList();
    }
    if (matchingRatings.isNotEmpty) {
      return matchingRatings.first;
    } else {
      return null;
    }
  }
}
