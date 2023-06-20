import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  const Ingredient({
    this.id = '',
    required this.name,
    required this.imageUrl,
  });

  factory Ingredient.fromFirestore(DocumentSnapshot snap) {
    return Ingredient(
      id: snap.id,
      name: snap['name'],
      imageUrl: snap['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
      ];
}
