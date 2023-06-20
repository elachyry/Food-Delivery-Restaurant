import 'package:fde_restaurant_panel/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../component/paymentListTile.dart';
import '../config/size_config.dart';
import '../models/rating.dart';
import '../models/status.dart';
import '../style/style.dart';

class PaymentDetailList extends StatelessWidget {
  PaymentDetailList({
    super.key,
  });
  final restaurantController = Get.put(RestaurantController());
  final OrdersController ordersController = Get.put(OrdersController());
  final ratingController = Get.put(RatingController());
  final userController = Get.put(LoginController());
  final costumerController = Get.put(CostumerController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical * 3,
        ),
        Obx(
          () {
            if (restaurantController.myData.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Obx(
                () => ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/restaurant.png'),
                    image: NetworkImage(
                      restaurantController.myData['logoUrl'],
                    ),
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/restaurant.png'),
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 5,
        ),
        Obx(
          () {
            if (restaurantController.myData.isEmpty ||
                ratingController.ratings.isEmpty ||
                costumerController.costumers.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            String restaurantId = userController.firebaseUser.value!.uid;

            var rating = 0.0;
            ratingController.fetchRatings();
            List<Rating> ratings = [];
            if (ratingController.ratings.isNotEmpty) {
              for (var element in ratingController.ratings) {
                if (element.restaurantId == restaurantId) {
                  ratings.add(element);
                  rating += element.rate;
                }
              }
            }
         
            // print('ratingController.ratings ${ratingController.ratings}');
            rating = rating / ratings.length;
            return Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        rating.isNaN ? 'No rating' : rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: rating.isNaN ? 30 : 40,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      rating.isNaN
                          ? Container()
                          : Text(
                              '(${ratings.length})',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  Center(
                    child: RatingBar.builder(
                      initialRating: rating.isNaN
                          ? 0.0
                          : double.parse(rating.toStringAsFixed(1)),
                      direction: Axis.horizontal,
                      itemSize: 30,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      ignoreGestures: true,
                      onRatingUpdate: (rating) {},
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                          text: 'Feedbacks',
                          size: 18,
                          fontWeight: FontWeight.w800),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  Container(
                    height: 70.0 * ratings.length,
                    child: ListView.separated(
                      itemCount: ratings.length < 5 ? ratings.length : 5,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) => Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 5),
                        child: ListTile(
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
                          trailing: Text(
                            DateFormat('dd MMM yyyy HH:mm').format(
                              DateTime.parse(ratings[index].addedAt),
                            ),
                            style: TextStyle(
                              color: Colors.grey.shade500,
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
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
                text: 'Recent Orders', size: 18, fontWeight: FontWeight.w800),
          ],
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Obx(() {
          if (ordersController.orders.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: List.generate(
              ordersController.orders.length < 10
                  ? ordersController.orders.length
                  : 10,
              (index) {
                final String status =
                    getStatusValue(ordersController.orders[index].status);
                final Color color;

                switch (status) {
                  case 'Pending':
                    color = Colors.blue.shade400;
                    break;
                  case 'Accepted':
                    color = Colors.green.shade400;
                    break;
                  case 'Cancelled':
                    color = Colors.orange.shade400;
                    break;
                  case 'Delivered':
                    color = Colors.grey.shade400;
                    break;
                  case 'Denied':
                    color = Colors.red.shade400;
                    break;
                  default:
                    color = Colors.blue.shade400;
                    break;
                }
                return PaymentListTile(
                  status: status,
                  label: ordersController
                          .users[ordersController.orders[index].consumerId]
                      ['fullName'] as String,
                  amount:
                      '${ordersController.orders[index].total.toStringAsFixed(2)} Dh',
                  address: ordersController.orders[index].address,
                  color: color,
                  order: ordersController.orders[index],
                );
              },
            ),
          );
        }),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 5,
        ),
      ],
    );
  }
}
