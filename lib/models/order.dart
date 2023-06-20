// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import './models.dart';

class Order extends Equatable {
  final String id;
  final String consumerId;
  final String restaurantId;
  final Map<MenuItem, int> menuItems;
  final double total;
  final String address;
  final String paymentMathode;
  final Status status;
  final String addedAt;

  const Order({
    this.id = '',
    required this.consumerId,
    required this.restaurantId,
    required this.menuItems,
    required this.total,
    required this.status,
    required this.paymentMathode,
    required this.address,
    required this.addedAt,
  });

  Order copyWith({
    String? id,
    String? consumerId,
    String? restaurantId,
    Map<MenuItem, int>? menuItems,
    double? total,
    Status? status,
    String? addedAt,
    String? paymentMathode,
    String? address,
  }) {
    return Order(
      id: id ?? this.id,
      consumerId: consumerId ?? this.consumerId,
      restaurantId: restaurantId ?? this.restaurantId,
      paymentMathode: paymentMathode ?? this.paymentMathode,
      address: address ?? this.address,
      menuItems: menuItems ?? this.menuItems,
      total: total ?? this.total,
      status: status ?? this.status,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'consumerId': consumerId,
  //     'restaurantId': restaurantId,
  //     'menuItems': menuItems.map((x) => x.toMap()).toList(),
  //     'total': total,
  //     'status': getStatusValue(status),
  //     'addedAt': addedAt,
  //   };
  // }

  // factory Order.fromMap(Map<String, dynamic> map) {
  //   return Order(
  //     id: map['id'] as String,
  //     consumerId: map['consumerId'] as String,
  //     restaurantId: map['restaurantId'] as String,
  //     menuItems: List<MenuItem>.from(
  //       (map['menuItems'] as List<int>).map<MenuItem>(
  //         (x) => MenuItem.fromMap(x as Map<String, dynamic>),
  //       ),
  //     ),
  //     total: map['total'] as double,
  //     status: getStatus(map['status']),
  //     addedAt: map['addedAt'] as String,
  //   );
  // }

  @override
  List<Object> get props {
    return [
      id,
      consumerId,
      restaurantId,
      menuItems,
      total,
      status,
      addedAt,
    ];
  }

  Map<String, dynamic> toMap() {
    final List<Map<String, dynamic>> menuItemsList =
        menuItems.entries.map((entry) {
      final MenuItem menuItem = entry.key;
      final int quantity = entry.value;
      return {
        'menuItem': menuItem.toMap(),
        'quantity': quantity,
      };
    }).toList();
    return <String, dynamic>{
      'id': id,
      'consumerId': consumerId,
      'restaurantId': restaurantId,
      'menuItems': menuItemsList,
      'total': total,
      'status': getStatusValue(status),
      'paymentMathode': paymentMathode,
      'address': address,
      'addedAt': addedAt,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      consumerId: map['consumerId'] as String,
      restaurantId: map['restaurantId'] as String,
      menuItems:
          Map<MenuItem, int>.from((map['menuItems'] as Map<MenuItem, int>)),
      total: map['total'] as double,
      status: getStatus(map['status']),
      paymentMathode: map['paymentMathode'] as String,
      address: map['address'] as String,
      addedAt: map['addedAt'] as String,
    );
  }

  factory Order.fromFirestore(QueryDocumentSnapshot map) {
    final List<Map<String, dynamic>> menuItemsList =
        List<Map<String, dynamic>>.from(map['menuItems']);
    final Map<MenuItem, int> menuItems = menuItemsList.fold<Map<MenuItem, int>>(
      {},
      (acc, item) {
        final MenuItem menuItem = MenuItem.fromMap(item['menuItem']);
        final int quantity = item['quantity'];
        acc[menuItem] = quantity;
        return acc;
      },
    );

    return Order(
      id: map.id,
      consumerId: map['consumerId'] as String,
      restaurantId: map['restaurantId'] as String,
      menuItems: menuItems,
      total: map['total'] as double,
      status: getStatus(map['status']),
      paymentMathode: map['paymentMathode'] as String,
      address: map['address'] as String,
      addedAt: map['addedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
