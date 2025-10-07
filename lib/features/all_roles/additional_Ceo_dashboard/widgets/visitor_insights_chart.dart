// lib/ui/widgets/public_visitor_insights_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VisitorInsightsChart extends StatelessWidget {
  const VisitorInsightsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
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
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
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
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    return Text(
                      days[value.toInt()],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            _buildLine(
              color: Colors.deepPurple,
              spots: const [
                FlSpot(0, 30),
                FlSpot(1, 45),
                FlSpot(2, 40),
                FlSpot(3, 60),
                FlSpot(4, 50),
                FlSpot(5, 70),
                FlSpot(6, 65),
              ],
            ),
            _buildLine(
              color: Colors.orange,
              spots: const [
                FlSpot(0, 20),
                FlSpot(1, 25),
                FlSpot(2, 30),
                FlSpot(3, 35),
                FlSpot(4, 28),
                FlSpot(5, 40),
                FlSpot(6, 38),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _buildLine({required List<FlSpot> spots, required Color color}) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.15),
      ),
    );
  }
}
