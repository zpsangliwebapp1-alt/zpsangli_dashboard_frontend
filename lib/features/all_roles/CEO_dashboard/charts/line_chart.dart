import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';




class LineChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  const LineChartWidget({required this.spots});

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) return const Center(child: Text("No Data"));
    return RepaintBoundary(
        child: LineChart(LineChartData(
          lineBarsData: [
            LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.green,
                dotData: const FlDotData(show: false),
                belowBarData:
                BarAreaData(show: true, color: Colors.green.withOpacity(0.15)))
          ],
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
        )));
  }
}