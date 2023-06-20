import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/size_config.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../widgets.dart';

class OrderItem extends StatelessWidget {
  final Order order;
  OrderItem({
    super.key,
    required this.order,
  });

  final menuItemsController = Get.put(MenuItemsController());
  final ratingController = Get.put(RatingController());
  final OrdersController ordersController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    final String status = getStatusValue(order.status);
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
        color = Colors.indigo.shade400;
        break;
      case 'Denied':
        color = Colors.red.shade400;
        break;
      default:
        color = Colors.blue.shade400;
        break;
    }

    Widget rowBuilder(String label, String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  // fontWeight: FontWeight.bold,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: () {
        ordersController.orderInfos.value = order;
        // menuItemsController.isShowInfos.value = true;
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
              Container(
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width, 100),
                    ),
                    color: color),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    status,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    rowBuilder('Order Id :', order.id),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    rowBuilder(
                        'Order Date :',
                        DateFormat('dd MMM yyyy hh:mm a')
                            .format(DateTime.parse(order.addedAt))),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    rowBuilder('Customer FullName:',
                        ordersController.users[order.consumerId]['fullName']),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    rowBuilder(
                        'Customer Address :', order.address.toUpperCase()),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Total :',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${order.total.toStringAsFixed(2)} Dh',
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              if (status == 'Accepted')
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade400,
                        ),
                        icon: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        label: Text('Mark as Delivered'),
                        onPressed: () async {
                          bool shoudMarkasDelivered =
                              await MarkOrderAsDeliveredConfirmationDialog.show(
                                  context) as bool;
                          if (shoudMarkasDelivered) {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => Center(
                                      child: CircularProgressIndicator(),
                                    ));
                            await ordersController.changeOrderStatus(
                                order.id, order.consumerId, 'Delivered');
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              if (status == 'Pending')
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.check,
                        color: Colors.green.shade400,
                      ),
                      onPressed: () async {
                        bool shoudAcceppte =
                            await AccepteOrderConfirmationDialog.show(context)
                                as bool;
                        if (shoudAcceppte) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => Center(
                                    child: CircularProgressIndicator(),
                                  ));
                          await ordersController.changeOrderStatus(
                              order.id, order.consumerId, 'Accepted');
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeVertical * 4,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        bool shoudDenied =
                            await DeniedOrderConfirmationDialog.show(context)
                                as bool;
                        if (shoudDenied) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => Center(
                                    child: CircularProgressIndicator(),
                                  ));
                          await ordersController.changeOrderStatus(
                              order.id, order.consumerId, 'Denied');
                          Navigator.of(context).pop();
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
