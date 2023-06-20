import 'package:fde_restaurant_panel/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/controllers.dart';

class ChartData2 {
  ChartData2(this.category, this.value);
  final String category;
  final double value;
}

class OrderDounatChart extends StatefulWidget {
  @override
  State<OrderDounatChart> createState() => _OrderDounatChartState();
}

class _OrderDounatChartState extends State<OrderDounatChart> {
  final orderController = Get.put(OrdersController());

  final userController = Get.put(LoginController());
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> resultMap = {
      'Pending': 0,
      'Accepted': 0,
      'Cancelled': 0,
      'Delivered': 0,
      'Denied': 0,
    };

    for (Order item in orderController.orders) {
      resultMap[getStatusValue(item.status)] =
          resultMap[getStatusValue(item.status)]! + 1;
    }
    List<ChartData2> getChartData() {
      return resultMap.entries
          .map((entry) => ChartData2(entry.key, entry.value.toDouble()))
          .toList();
    }

    return SfCircularChart(
      title: ChartTitle(text: 'The number of orders for each order status'),
      legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom),
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        DoughnutSeries<ChartData2, String>(
          explode: true,
          explodeIndex: 0,
          dataSource: getChartData(),
          xValueMapper: (ChartData2 data, _) => data.category,
          yValueMapper: (ChartData2 data, _) => data.value,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
          ),
          enableTooltip: true,
        ),
      ],
    );
  }
}
