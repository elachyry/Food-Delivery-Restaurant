// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String categoryId;
  final String description;
  final Map<String, String> elements;
  final List<String> ingredientsId;
  final double price;
  final String imageUrl;
  final List<String> ratingsId;

  MenuItem({
    this.id = '',
    required this.restaurantId,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.elements,
    required this.ingredientsId,
    required this.price,
    required this.imageUrl,
    this.ratingsId = const [],
  });

  @override
  List<Object> get props {
    return [
      id,
      restaurantId,
      name,
      categoryId,
      description,
      elements,
      ingredientsId,
      price,
      imageUrl,
      ratingsId,
    ];
  }

  MenuItem copyWith({
    String? id,
    String? restaurantId,
    String? name,
    String? categoryId,
    String? description,
    Map<String, String>? elements,
    List<String>? ingredientsId,
    double? price,
    String? imageUrl,
    List<String>? ratingsId,
  }) {
    return MenuItem(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      elements: elements ?? this.elements,
      ingredientsId: ingredientsId ?? this.ingredientsId,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      ratingsId: ratingsId ?? this.ratingsId,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'restaurantId': restaurantId,
  //     'name': name,
  //     'categoryId': categoryId,
  //     'description': description,
  //     'elements': elements,
  //     'ingredients': ingredients.map((x) => x.toJson()).toList(),
  //     'price': price,
  //     'imageUrl': imageUrl,
  //     'ratings': ratings.map((x) => x.toJson()).toList(),
  //   };
  // }

  factory MenuItem.fromFirestore(DocumentSnapshot snap) => MenuItem(
        id: snap.id,
        restaurantId: snap['restaurantId'] as String,
        name: snap['name'] as String,
        categoryId: snap['categoryId'] as String,
        description: snap['description'] as String,
        elements: Map<String, String>.from(snap['elements']),
        ingredientsId: List<String>.from(snap['ingredientsId']),
        price: snap['price'].toDouble(),
        imageUrl: snap['imageUrl'] as String,
        ratingsId: List<String>.from(snap['ratingsId']),
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'restaurantId': restaurantId,
      'name': name,
      'categoryId': categoryId,
      'description': description,
      'elements': elements,
      'ingredientsId': ingredientsId,
      'price': price,
      'imageUrl': imageUrl,
      'ratingsId': ratingsId,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] as String,
      restaurantId: map['restaurantId'] as String,
      name: map['name'] as String,
      categoryId: map['categoryId'] as String,
      description: map['description'] as String,
      elements: Map<String, String>.from((map['elements'])),
      ingredientsId: List<String>.from((map['ingredientsId'])),
      price: map['price'] as double,
      imageUrl: map['imageUrl'] as String,
      ratingsId: List<String>.from((map['ratingsId'])),
    );
  }

  // factory MenuItem.fromMap(Map<String, dynamic> map) {
  //   return MenuItem(
  //       id: map['id'] as String,
  //       restaurantId: map['restaurantId'] as String,
  //       name: map['name'] as String,
  //       categoryId: map['categoryId'] as String,
  //       description: map['description'] as String,
  //       elements: List<Map<String, String>>.from(
  //         (map['elements'] as List<int>).map<Map<String, String>>(
  //           (x) => x,
  //         ),
  //       ),
  //       ingredientsId: List<String>.from(
  //         (map['ingredientsId'] as List<String>),
  //         price: map['price'] as double,
  //         imageUrl: map['imageUrl'] as String,
  //         ratings: List<Rating>.from(
  //           (map['ratings'] as List<int>).map<Rating>(
  //             (x) => Rating.fromMap(x as Map<String, dynamic>),
  //           ),
  //         ),
  //       ));
  // }

  String toJson() => json.encode(toMap());

//   factory MenuItem.fromJson(String source) =>
//       MenuItem.fromMap(json.decode(source) as Map<String, dynamic>);
// }
}
