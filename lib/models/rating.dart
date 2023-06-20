import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  final String id;
  final String custmerId;
  final String restaurantId;
  final String menuItemId;
  final double rate;
  final String comment;
  final String addedAt;

  const Rating({
    this.id = '',
    required this.custmerId,
    required this.restaurantId,
    required this.menuItemId,
    required this.rate,
    required this.comment,
    required this.addedAt,
  });

  factory Rating.fromFirestore(DocumentSnapshot snap) {
    // print('id ${snap.id}');
    // print('custmerId ${snap['custmerId']}');
    // print('stars ${snap['stars']}');
    // print('comment ${snap['comment']}');
    return Rating(
      id: snap.id,
      custmerId: snap['custmerId'],
      restaurantId: snap['restaurantId'],
      menuItemId: snap['menuItemId'],
      rate: snap['stars'],
      comment: snap['comment'],
      addedAt: snap['addedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'custmerId': custmerId,
      'restaurantId': restaurantId,
      'menuItemId': menuItemId,
      'stars': rate,
      'comment': comment,
      'addedAt': addedAt,
    };
  }

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      custmerId: json['custmerId'],
      restaurantId: json['restaurantId'],
      menuItemId: json['menuItemId'],
      rate: json['stars'].toDouble(),
      comment: json['comment'],
      addedAt: json['addedAt'],
    );
  }
  factory Rating.fromFireStore(DocumentSnapshot doc) {
    return Rating(
      id: doc.id,
      custmerId: doc['custmerId'],
      restaurantId: doc['restaurantId'],
      menuItemId: doc['menuItemId'],
      rate: doc['stars'].toDouble(),
      comment: doc['comment'],
      addedAt: doc['addedAt'],
    );
  }

  @override
  List<Object?> get props =>
      [id, custmerId, rate, comment, restaurantId, menuItemId];
}
