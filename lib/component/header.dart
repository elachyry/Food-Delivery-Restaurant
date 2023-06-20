import '../controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/responsive.dart';
import '../style/colors.dart';
import '../style/style.dart';

class Header extends StatelessWidget {
  Header({
    super.key,
    required this.searchController,
    required this.descriptionController,
    required this.nameController,
    required this.priceController,
  });
  final TextEditingController searchController;
  final menuItemsController = Get.put(MenuItemsController());

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const PrimaryText(
            text: 'Menu Items', size: 30, fontWeight: FontWeight.w800),
        SizedBox(
          height: 70,
          width: 70,
          child: IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Theme.of(context).primaryColorDark,
              size: 50,
            ),
            onPressed: () {
              nameController.clear();
              descriptionController.clear();
              priceController.clear();
              menuItemsController.editImage.value = '';
              menuItemsController.isEditing.value = false;
              menuItemsController.isShowInfos.value = false;
            },
          ),
        ),
      ],
    );
  }
}
