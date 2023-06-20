// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'models.dart';

class Costumer extends Equatable {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String userImage;
  final String email;
  final String password;
  final String addedAt;

  const Costumer({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.userImage,
    required this.email,
    required this.password,
    required this.addedAt,
  });

  Costumer copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? userImage,
    String? email,
    String? password,
    String? addedAt,
  }) {
    return Costumer(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userImage: userImage ?? this.userImage,
      email: email ?? this.email,
      password: password ?? this.password,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'userImage': userImage,
      'email': email,
      'password': password,
      'addedAt': addedAt,
    };
  }

  factory Costumer.fromMap(Map<String, dynamic> map) {
    return Costumer(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      userImage: map['userImage'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      addedAt: map['addedAt'] as String,
    );
  }

  factory Costumer.fromFirestore(DocumentSnapshot snap) {
    return Costumer(
      id: snap.id,
      fullName: snap['fullName'] as String,
      phoneNumber: snap['phoneNumber'] as String,
      userImage: snap['userImage'] as String,
      email: snap['email'] as String,
      password: snap['password'] as String,
      addedAt: snap['createdAt'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Costumer.fromJson(String source) =>
      Costumer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      fullName,
      phoneNumber,
      userImage,
      email,
      password,
      addedAt,
    ];
  }
}
