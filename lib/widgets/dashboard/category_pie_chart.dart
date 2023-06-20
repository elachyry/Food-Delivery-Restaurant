import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/controllers.dart';

class ChartData {
  ChartData(this.category, this.value);
  final String category;
  final double value;
}

class CategoryPieChart extends StatefulWidget {
  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  final menuItemsController = Get.put(MenuItemsController());

  final categoryController = Get.put(CategoryController());

  final userController = Get.put(LoginController());
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categoryList = (menuItemsController.menuItems
        .where((element) =>
            element.restaurantId == userController.firebaseUser.value!.uid)
        .map((e) => categoryController.categories
            .firstWhere((category) => category.id == e.categoryId)
            .name)).toList();

    Map<String, int> resultMap = {};

    for (String item in categoryList) {
      if (resultMap.containsKey(item)) {
        resultMap[item] = resultMap[item]! + 1;
      } else {
        resultMap[item] = 1;
      }
    }
    List<ChartData> getChartData() {
      return resultMap.entries
          .map((entry) => ChartData(entry.key, entry.value.toDouble()))
          .toList();
    }

    return SfCircularChart(
      title: ChartTitle(text: 'The number of product for each category'),
      legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom),
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        PieSeries<ChartData, String>(
          explode: true,
          explodeIndex: 0,
          dataSource: getChartData(),
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
          ),
          enableTooltip: true,
        ),
      ],
    );
  }
}
