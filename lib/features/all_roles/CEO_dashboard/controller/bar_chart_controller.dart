import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BarChartController with ChangeNotifier {
  List<BarChartGroupData> _groups = [];
  bool _isLoading = true;

  List<BarChartGroupData> get groups => _groups;
  bool get isLoading => _isLoading;

  Future<void> fetchChartData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("https://your-api-url.com/chart-data"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        /// Expecting API like:
        /// [{ "department": "Sales", "target": 50, "achievement": 45 }, ...]

        _groups = data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return BarChartGroupData(
            x: index,
            barsSpace: 8,
            barRods: [
              // 🎯 Target Bar (Blue)
              BarChartRodData(
                toY: (item["target"] ?? 0).toDouble(),
                color: Colors.blueAccent,
                width: 18,
                borderRadius: BorderRadius.circular(6),
              ),
              // 🟢 Achievement Bar (Dynamic color based on performance)
              BarChartRodData(
                toY: (item["achievement"] ?? 0).toDouble(),
                color: (item["achievement"] >= item["target"])
                    ? Colors.greenAccent.shade400
                    : Colors.orangeAccent.shade200,
                width: 18,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          );
        }).toList();
      }
    } catch (e) {
      debugPrint("Error fetching chart data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
