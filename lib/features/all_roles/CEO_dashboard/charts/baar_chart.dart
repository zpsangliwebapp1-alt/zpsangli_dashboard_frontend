import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';



class BarChartWidget extends StatelessWidget {
  final List<BarChartGroupData> groups;
  const BarChartWidget({required this.groups});

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const Center(child: Text("No Data"));
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final maxY = _getMaxY();
    final interval = _getInterval();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.blueGrey.shade900, Colors.blueGrey.shade800]
              : [Colors.white, Colors.blue.shade50],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ✅ Scrollable + Zoomable Chart Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                minScale: 0.8,
                maxScale: 2.0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: groups.length > 6 ? groups.length * 80 : 500,
                    child: BarChart(
                      BarChartData(
                        maxY: maxY,
                        alignment: BarChartAlignment.spaceAround,
                        groupsSpace: 24,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: interval,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: interval,
                              getTitlesWidget: (value, _) => Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 10,
                                ),
                              ),
                              reservedSize: 30,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) => Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "Dept ${value.toInt() + 1}",
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          topTitles: const AxisTitles(),
                          rightTitles: const AxisTitles(),
                        ),
                        barGroups: groups
                            .map(
                              (group) => BarChartGroupData(
                            x: group.x,
                            barsSpace: 6,
                            barRods: group.barRods.map((rod) {
                              // 🎨 Dynamic colors for Achievement bars
                              final bool isAchievement =
                                  rod.toY > 0 && rod.gradient?.colors.first == Colors.greenAccent;
                              final colorGradient = isAchievement
                                  ? LinearGradient(
                                colors: [
                                  Colors.orangeAccent.withOpacity(0.9),
                                  Colors.greenAccent.withOpacity(0.9),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              )
                                  : LinearGradient(
                                colors: [
                                  Colors.blueAccent.withOpacity(0.9),
                                  Colors.lightBlue.withOpacity(0.8),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              );

                              return BarChartRodData(
                                toY: rod.toY,
                                width: 18,
                                borderRadius: BorderRadius.circular(8),
                                gradient: colorGradient,
                              );
                            }).toList(),
                          ),
                        )
                            .toList(),
                      ),
                    ).animate().fadeIn(duration: const Duration(milliseconds: 700)).scale(),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ✅ Legend Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(Colors.blueAccent, "Target"),
              const SizedBox(width: 12),
              _legendDot(Colors.greenAccent, "Achievement"),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
      ],
    );
  }

  double _getMaxY() {
    final values = groups.expand((g) => g.barRods.map((r) => r.toY));
    return values.isEmpty ? 0 : (values.reduce((a, b) => a > b ? a : b) * 1.3);
  }

  double _getInterval() {
    final maxY = _getMaxY();
    return (maxY / 4).clamp(1, 100000);
  }
}