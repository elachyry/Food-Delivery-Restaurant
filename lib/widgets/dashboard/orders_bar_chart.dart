import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../../controllers/controllers.dart';
import '../../models/models.dart';

class OrdersBarChart extends StatefulWidget {
  OrdersBarChart({
    Key? key,
  }) : super(key: key);

  @override
  _OrdersBarChartState createState() => _OrdersBarChartState();
}

class _OrdersBarChartState extends State<OrdersBarChart> {
  late List<ChartData32> _chartData;
  late TooltipBehavior _tooltipBehavior;
  final orderController = Get.put(OrdersController());

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Number of orders per day for the last 7 days'),
      legend: Legend(isVisible: true),
      tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        BarSeries<ChartData32, String>(
            name: 'Orders',
            dataSource: _chartData,
            xValueMapper: (ChartData32 gdp, _) => gdp.day,
            yValueMapper: (ChartData32 gdp, _) => gdp.count,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            enableTooltip: true,
            color: Theme.of(context).primaryColorDark)
      ],
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        numberFormat: NumberFormat(),
        // title: AxisTitle(text: 'GDP in billions of U.S. Dollars'),
      ),
    );
  }

  List<ChartData32> getChartData() {
    final orders = orderController.orders;
    final orderCountByDay = getOrderCountByDay(orders);

    print('orderCountByDay $orderCountByDay');

    final List<ChartData32> chartData = [];

    orderCountByDay.forEach((key, value) {
      chartData.add(
        ChartData32(
          key,
          value.toDouble(),
        ),
      );
    });

    return chartData.reversed.toList();
  }
}

DateTime extractDay(String addedAt) {
  final DateTime dateTime = DateTime.parse(addedAt);
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

Map<String, int> getOrderCountByDay(List<Order> orders) {
  final Map<String, int> orderCountByDay = {};
  final DateFormat dateFormat = DateFormat('EEEE');

  final DateTime currentDate = DateTime.now();

  for (int i = 0; i < 7; i++) {
    final DateTime date = currentDate.subtract(Duration(days: i));

    final String dayName = dateFormat.format(date);

    orderCountByDay[dayName] = 0;
  }

  for (final Order order in orders) {
    final DateTime orderDate = DateTime.parse(order.addedAt);
    final String dayName = dateFormat.format(orderDate);

    orderCountByDay[dayName] = (orderCountByDay[dayName] ?? 0) + 1;
  }

  return orderCountByDay;
}

class ChartData32 {
  ChartData32(this.day, this.count);
  final String day;
  final double count;
}
