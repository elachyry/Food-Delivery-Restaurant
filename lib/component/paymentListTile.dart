import 'package:fde_restaurant_panel/screens/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/controllers.dart';
import '../models/models.dart';
import '../style/colors.dart';
import '../style/style.dart';

class PaymentListTile extends StatelessWidget {
  final String label;
  final String amount;
  final String status;
  final String address;
  final Color color;
  final Order order;

  const PaymentListTile({
    required this.label,
    required this.amount,
    required this.status,
    required this.address,
    required this.color,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final OrdersController ordersController = Get.put(OrdersController());

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 0, right: 20),
          visualDensity: VisualDensity.standard,
          leading: Container(
            width: 50,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: FittedBox(
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title:
              PrimaryText(text: label, size: 14, fontWeight: FontWeight.w500),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PrimaryText(
                text: address,
                size: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ),
              PrimaryText(text: amount, size: 16, fontWeight: FontWeight.w600),
            ],
          ),
          onTap: () {
            ordersController.orderInfos.value = order;
            Get.toNamed(OrdersScreen.appRoute);
          },
          // selected: true,
        ),
      ),
    );
  }
}
