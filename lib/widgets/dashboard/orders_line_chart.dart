import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../../controllers/controllers.dart';
import '../../models/models.dart';

class OrdersLineChart extends StatefulWidget {
  OrdersLineChart({
    Key? key,
  }) : super(key: key);

  @override
  _OrdersLineChartState createState() => _OrdersLineChartState();
}

class _OrdersLineChartState extends State<OrdersLineChart> {
  late List<ChartData3> _chartData;
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
      title:
          ChartTitle(text: 'Transactions amount per day for the last 7 days'),
      legend: Legend(isVisible: true),
      tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        ColumnSeries<ChartData3, String>(
            name: 'Amount',
            dataSource: _chartData,
            xValueMapper: (ChartData3 gdp, _) => gdp.day,
            yValueMapper: (ChartData3 gdp, _) => gdp.count,
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

  List<ChartData3> getChartData() {
    final orders = orderController.orders;
    final orderCountByDay = getOrderAmountByDay(orders);

    print('orderCountByDay $orderCountByDay');

    final List<ChartData3> chartData = [];

    orderCountByDay.forEach((key, value) {
      chartData.add(
        ChartData3(
          key,
          value.toDouble(),
        ),
      );
    });

    return chartData.reversed.toList();
  }
}

Map<String, double> getOrderAmountByDay(List<Order> orders) {
  final Map<String, double> orderCountByDay = {};
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

    double value =
        (getStatusValue(order.status) == 'Delivered') ? order.total : 0;
    orderCountByDay[dayName] = (orderCountByDay[dayName] ?? 0) + value;
  }

  return orderCountByDay;
}

class ChartData3 {
  ChartData3(this.day, this.count);
  final String day;
  final double count;
}
