import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PublicRevenueChart extends StatelessWidget {
  const PublicRevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340, // 🔥 Fixed height दिला
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nutrition Expenditure (₹)",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20000,
                barTouchData: BarTouchData(enabled: true),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value % 5000 == 0) {
                          return Text(
                            '${value ~/ 1000}k',
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
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: _nutritionExpenditureData(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _nutritionExpenditureData() {
    /// Example: Supplementary Nutrition Expenditure (₹)
    final expenditure = [12000.0, 15000.0, 9000.0, 17000.0, 13000.0, 18000.0];
    return List.generate(expenditure.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: expenditure[i],
            color: Colors.deepPurple,
            width: 18,
            borderRadius: BorderRadius.circular(6),
          )
        ],
      );
    });
  }
}
