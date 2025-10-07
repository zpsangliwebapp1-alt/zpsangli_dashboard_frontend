import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PublicCustomerSatisfactionChart extends StatelessWidget {
  const PublicCustomerSatisfactionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // responsive sizing
        final isMobile = constraints.maxWidth < 600;
        final chartHeight = isMobile ? 200.0 : 280.0;
        final labelFontSize = isMobile ? 10.0 : 12.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "",
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: chartHeight,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 40,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 20 == 0) {
                            return Text(
                              '${value.toInt()}%',
                              style: TextStyle(
                                fontSize: labelFontSize,
                                color: Colors.grey,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const labels = ['Q1', 'Q2', 'Q3', 'Q4'];
                          if (value.toInt() >= 0 && value.toInt() < labels.length) {
                            return Text(
                              labels[value.toInt()],
                              style: TextStyle(
                                fontSize: labelFontSize,
                                color: Colors.grey,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),

                  // ✅ Report Data
                  lineBarsData: [
                    // Beneficiary Satisfaction %
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 68),
                        FlSpot(1, 74),
                        FlSpot(2, 81),
                        FlSpot(3, 78),
                      ],
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [Colors.deepPurple, Colors.purpleAccent],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple.withOpacity(0.25),
                            Colors.transparent
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                    // Malnutrition Reduction %
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 40),
                        FlSpot(1, 45),
                        FlSpot(2, 55),
                        FlSpot(3, 60),
                      ],
                      isCurved: true,
                      color: Colors.redAccent,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),

                    // Coverage of Anganwadi %
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 72),
                        FlSpot(1, 76),
                        FlSpot(2, 83),
                        FlSpot(3, 88),
                      ],
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ✅ Custom Legend
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: const [
                _LegendItem(color: Colors.deepPurple, text: "Satisfaction %"),
                _LegendItem(color: Colors.redAccent, text: "Malnutrition Reduction %"),
                _LegendItem(color: Colors.green, text: "Anganwadi Coverage %"),
              ],
            )
          ],
        );
      },
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 14, height: 14, color: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
      ],
    );
  }
}
