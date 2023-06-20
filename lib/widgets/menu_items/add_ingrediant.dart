import 'package:fde_restaurant_panel/models/category.dart';
import 'package:fde_restaurant_panel/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/controllers.dart';

class AddIngrediantDialog extends StatelessWidget {
  final _ingrediantNameController = TextEditingController();
  final _ingrediantImageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(IngredientController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Ingredient'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _ingrediantImageUrlController,
              decoration: InputDecoration(
                labelText: 'Ingredient image Url',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'The Ingredient image Url field can\'t be empty';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _ingrediantNameController,
              decoration: InputDecoration(
                labelText: 'Ingredient Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'The Ingredient name field can\'t be empty';
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
                        controller.addIngrediant(
                          Ingredient(
                            name: _ingrediantNameController.text,
                            imageUrl: _ingrediantImageUrlController.text,
                          ),
                        );
                        Navigator.pop(context);
                        showSnackBar(
                            'Error',
                            'The ingredient added successfully.',
                            Colors.green.shade400);
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
