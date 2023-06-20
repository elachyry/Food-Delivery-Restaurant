import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/size_config.dart';
import '../../models/models.dart';
import '../../controllers/controllers.dart';

class MenuItemShowInfos extends StatelessWidget {
  MenuItemShowInfos({
    super.key,
  });

  final menuItemController = Get.put(MenuItemsController());
  final categoryController = Get.put(CategoryController());
  final ratingController = Get.put(RatingController());
  final costumerController = Get.put(CostumerController());

  @override
  Widget build(BuildContext context) {
    costumerController.loadCostumers();
    var rating = 0.0;
    ratingController.fetchRatings();
    List<Rating> ratings = [];
    if (ratingController.ratings.isNotEmpty ||
        costumerController.costumers.isEmpty) {
      for (var element in ratingController.ratings) {
        if (element.menuItemId ==
            (menuItemController.menuItem.value as MenuItem).id) {
          ratings.add(element);
          rating += element.rate;
        }
      }
    }
    rating = rating / ratings.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          () => Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                image: NetworkImage(
                  (menuItemController.menuItem.value as MenuItem).imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        const Divider(),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Obx(
          () => Text(
            (menuItemController.menuItem.value as MenuItem).name,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        const Divider(),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Obx(
          () => Text(
            (menuItemController.menuItem.value as MenuItem).description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        const Divider(),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Obx(
          () => Text(
            '${(menuItemController.menuItem.value as MenuItem).price} Dh',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        const Divider(),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Category:',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Obx(
              () => Text(
                categoryController.categories
                    .firstWhere((element) =>
                        element.id ==
                        (menuItemController.menuItem.value as MenuItem)
                            .categoryId)
                    .name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        const Divider(),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Text(
          'Ingrediants',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Obx(
          () => Container(
            height: 28.0 *
                (menuItemController.menuItem.value as MenuItem)
                    .ingredientsId
                    .length,
            child: ListView.builder(
              itemCount: (menuItemController.menuItem.value as MenuItem)
                  .ingredientsId
                  .length,
              itemBuilder: (context, index) => Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                child: Text(
                  (menuItemController.menuItem.value as MenuItem)
                      .ingredientsId[index],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        const Divider(),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Text(
          'Elements',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Obx(
          () => Container(
            height: 30.0 *
                (menuItemController.menuItem.value as MenuItem)
                    .elements
                    .keys
                    .length,
            child: ListView.builder(
              itemCount: (menuItemController.menuItem.value as MenuItem)
                  .elements
                  .keys
                  .length,
              itemBuilder: (context, index) => Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (menuItemController.menuItem.value as MenuItem)
                          .elements
                          .keys
                          .elementAt(index),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'x${(menuItemController.menuItem.value as MenuItem).elements.values.elementAt(index)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        const Divider(),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Text(
          'Reviews',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        ratings.isEmpty
            ? Text(
                'No reviews',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
              )
            : Obx(() {
                if (ratingController.ratings.isEmpty ||
                    costumerController.costumers.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Container(
                  height: 70.0 * ratings.length,
                  child: ListView.builder(
                      itemCount: ratings.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          child: ListTile(
                            trailing: Text(
                              DateFormat('dd MMM yyyy HH:mm').format(
                                DateTime.parse(ratings[index].addedAt),
                              ),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                            title: Text(
                              costumerController.costumers
                                  .firstWhere((element) =>
                                      element.id == ratings[index].custmerId)
                                  .fullName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              ratings[index].comment,
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: Text(
                                ratings[index].rate.toStringAsFixed(1),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }),
      ],
    );
  }
}
