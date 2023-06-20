import 'package:fde_restaurant_panel/models/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/category_controller.dart';

class AddCategoryDialog extends StatelessWidget {
  final _categoryNameController = TextEditingController();
  final _categoryImageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Category'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _categoryImageUrlController,
              decoration: InputDecoration(
                labelText: 'Category image Url',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'The category image Url field can\'t be empty';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _categoryNameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'The category name field can\'t be empty';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Obx(
          () => ElevatedButton(
            child: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Text('Add'),
            onPressed: controller.isLoading.value
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      try {
                        controller.addCategory(
                          Category(
                            name: _categoryNameController.text,
                            imageUrl: _categoryImageUrlController.text,
                          ),
                        );
                        showSnackBar(
                            'Error',
                            'The category added successfully.',
                            Colors.green.shade400);
                        Navigator.pop(context);
                      } catch (error) {
                        showSnackBar(
                            'Error',
                            'An error occurred, please try again later.',
                            Colors.red.shade400);
                      }
                    }
                    // controller.addCategory(categoryName);
                  },
          ),
        ),
      ],
    );
  }

  void showSnackBar(String titleText, String messageText, Color color) {
    Get.snackbar(titleText, messageText,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color,
        colorText: Colors.white,
        duration: const Duration(milliseconds: 2000));
  }
}
