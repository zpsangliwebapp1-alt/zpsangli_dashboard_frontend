import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controller/bar_chart_controller.dart';
import 'package:provider/provider.dart';

import 'dynamic_bar_chart.dart';

class BarChartScreen extends StatefulWidget {
  const BarChartScreen({super.key});

  @override
  State<BarChartScreen> createState() => _BarChartScreenState();
}

class _BarChartScreenState extends State<BarChartScreen> {
  late BarChartController controller;

  @override
  void initState() {
    super.initState();
    controller = BarChartController();
    controller.fetchChartData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Scaffold(
        appBar: AppBar(title: const Text("Department Performance")),
        body: const Padding(
          padding: EdgeInsets.all(12.0),
          child: DynamicBarChart(),
        ),
      ),
    );
  }
}
