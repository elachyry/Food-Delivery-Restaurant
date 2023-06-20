import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/size_config.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../widgets.dart';

class MenuItems extends StatelessWidget {
  final MenuItem menuItem;
  MenuItems({
    super.key,
    required this.menuItem,
    required this.categoriesController,
    required this.descriptionController,
    required this.ingrediantsController,
    required this.priceController,
    required this.nameController,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final SingleValueDropDownController categoriesController;
  final MultiValueDropDownController ingrediantsController;
  final categorCOntroller = Get.put(CategoryController());

  final menuItemsController = Get.put(MenuItemsController());
  final ratingController = Get.put(RatingController());

  @override
  Widget build(BuildContext context) {
    var rating = 0.0;
    ratingController.fetchRatings();
    List<Rating> ratings = [];

    if (ratingController.ratings.isNotEmpty) {
      for (var element in ratingController.ratings) {
        if (element.menuItemId == menuItem.id) {
          ratings.add(element);
          rating += element.rate;
        }
      }
    }
    return InkWell(
      onTap: () {
        menuItemsController.menuItem.value = menuItem;
        menuItemsController.isShowInfos.value = true;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: FadeInImage(
                  placeholder: AssetImage('assets/menu-item-placeholder.jpg'),
                  image: NetworkImage(
                    menuItem.imageUrl,
                  ),
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        menuItem.name,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Text(
                          rating.isNaN || ratings.isEmpty
                              ? 'No ratings'
                              : '$rating (${ratings.length})',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.grid_view_rounded,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        categorCOntroller.categories
                            .firstWhere((category) =>
                                category.id == menuItem.categoryId)
                            .name,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${menuItem.price} Dh',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue.shade400,
                    ),
                    onPressed: () {
                      nameController.text = menuItem.name;
                      descriptionController.text = menuItem.description;
                      priceController.text = menuItem.price.toString();
                      menuItemsController.isShowInfos.value = false;

                      menuItemsController.isEditing.value = true;
                      menuItemsController.menuItem.value = menuItem;
                      menuItemsController.editImage.value = menuItem.imageUrl;
                    },
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeVertical * 2,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      bool shouldDelete =
                          await DeleteConfirmationDialog.show(context) as bool;
                      if (shouldDelete) {
                        menuItemsController.menuItem.value = menuItem;

                        menuItemsController.deleteMenuItem(
                            menuItemsController.menuItem.value as MenuItem,
                            context);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
