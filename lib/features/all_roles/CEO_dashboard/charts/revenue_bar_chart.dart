import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CeoPageRevenueBarChart extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> departmentData;
  final String department;
  final String metric;
  final Color barColor;

  const CeoPageRevenueBarChart({
    Key? key,
    required this.departmentData,
    required this.department,
    required this.metric,
    this.barColor = Colors.deepPurple,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final series = (departmentData[department] ?? [])
        .map<double>((blockData) {
      final value = blockData[metric];
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return 0.0;
    }).toList();

    final labels = (departmentData[department] ?? [])
        .map<String>((blockData) => blockData['block']?.toString() ?? '')
        .toList();

    return SizedBox(
      width: MediaQuery.of(context).size.width/1, // full width
      height: 400, // adjust height as needed
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween, // distribute bars across full width
          maxY: series.isNotEmpty ? series.reduce((a, b) => a > b ? a : b) * 1.25 : 100,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < labels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        labels[idx],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
          barGroups: series.asMap().entries.map((e) {
            final i = e.key;
            final v = e.value;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: v,
                  width: 18,
                  borderRadius: BorderRadius.circular(8),
                  color: barColor,
                  backDrawRodData: BackgroundBarChartRodData(show: true, toY: 0),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

