// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  const Category({
    this.id = '',
    required this.name,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [id, name, imageUrl];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  String toJson() => json.encode(toMap());

  factory Category.fromFirestore(DocumentSnapshot snap) {
    return Category(
      id: snap.id,
      name: snap['name'] as String,
      imageUrl: snap['imageUrl'] as String,
    );
  }
}
