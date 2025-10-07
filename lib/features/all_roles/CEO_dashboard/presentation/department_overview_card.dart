import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../presentation/department_overview_card.dart';
import 'block_barchart_screen.dart';

/// -------------------- OVERVIEW CARD --------------------
class DepartmentOverviewCard extends StatelessWidget {
  final String block;
  final String department;
  final Map<String, Map<String, double>> monthlyTotals;
  final DateTime lastUpdated;
  final Map<String, List<Map<String, dynamic>>>? departmentData;
  final VoidCallback? onRefresh;

  const DepartmentOverviewCard({
    super.key,
    required this.block,
    required this.department,
    required this.monthlyTotals,
    required this.lastUpdated,
    this.departmentData,
    this.onRefresh,
  });

  static const double _cornerRadius = 16.0;

  /// Fallback Data
  List<Map<String, dynamic>> get _fallbackSchemes => [
    {"name": "PM-Kisan", "budget": 1200000.0, "spent": 900000.0},
    {"name": "MGNREGA", "budget": 2500000.0, "spent": 2000000.0},
    {"name": "Swachh Bharat", "budget": 800000.0, "spent": 600000.0},
    {"name": "Digital India", "budget": 500000.0, "spent": 450000.0},
  ];

  List<Map<String, dynamic>> _schemesFromDepartment() {
    if (departmentData == null) return _fallbackSchemes;
    final entries = departmentData![department] ?? [];
    if (entries.isEmpty) return _fallbackSchemes;

    final latest = entries.last;
    final items = (latest["items"] as List?)?.cast<Map<String, dynamic>>() ?? [];

    final schemes = items
        .map((it) => {
      "name": it["name"]?.toString() ?? "Scheme",
      "budget": (it["financial"] as num?)?.toDouble() ?? 0.0,
      "spent": (it["achievement"] as num?)?.toDouble() ?? 0.0,
    })
        .toList();

    return schemes.isEmpty ? _fallbackSchemes : schemes;
  }

  @override
  Widget build(BuildContext context) {
    final totalTarget =
    monthlyTotals.values.fold(0.0, (s, m) => s + (m["target"] ?? 0.0));
    final totalAchievement = monthlyTotals.values
        .fold(0.0, (s, m) => s + (m["achievement"] ?? 0.0));
    final totalFinancial =
    monthlyTotals.values.fold(0.0, (s, m) => s + (m["financial"] ?? 0.0));

    final schemes = _schemesFromDepartment();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// KPI Row
          Row(
            children: [
              _kpiCard(context, Icons.account_balance_wallet,
                  "₹${_formatNumber(totalFinancial)}", "Total Budget", Colors.red),
              const SizedBox(width: 12),
              _kpiCard(context, Icons.flag, _formatNumber(totalTarget),
                  "Total Target", Colors.orange),
              const SizedBox(width: 12),
              _kpiCard(context, Icons.check_circle,
                  _formatNumber(totalAchievement), "Achievement", Colors.green),
              const SizedBox(width: 12),
              _kpiCard(context, Icons.business, "${schemes.length}", "Schemes",
                  Colors.purple),
            ],
          ),
          const SizedBox(height: 24),


          const SizedBox(height: 16),

          /// Charts Grid - Row 1
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  height: 300,
                  child: _chartCard("Budget Utilization", _pieChart(schemes)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 300,
                  child: _chartCard("Revenue Trend", _barChart()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Charts Grid - Row 2
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  height: 300,
                  child: _chartCard("Customer Satisfaction", _splineChart()),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 300,
                  child: _chartCard("Target vs Actual", _targetVsReality()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          /// Footer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Last Updated: ${_formatDateTime(lastUpdated)}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              if (onRefresh != null)
                IconButton(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// KPI Card
  Widget _kpiCard(BuildContext context, IconData icon, String value,
      String label, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cornerRadius),
        ),
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_cornerRadius),
            color: color.withOpacity(0.08),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Chart Wrapper
  Widget _chartCard(String title, Widget chart) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cornerRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: chart),
          ],
        ),
      ),
    );
  }

  /// Charts
  Widget _pieChart(List<Map<String, dynamic>> schemes) {
    return SfCircularChart(
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      series: <CircularSeries>[
        DoughnutSeries<Map<String, dynamic>, String>(
          dataSource: schemes,
          xValueMapper: (d, _) => d["name"],
          yValueMapper: (d, _) => d["spent"],
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
          ),
          explode: true,
          explodeIndex: 0,
        )
      ],
    );
  }

  Widget _barChart() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      series: <ColumnSeries>[
        ColumnSeries<ChartData, String>(
          dataSource: [
            ChartData("Mon", 120),
            ChartData("Tue", 150),
            ChartData("Wed", 180),
            ChartData("Thu", 100),
            ChartData("Fri", 220),
          ],
          xValueMapper: (d, _) => d.x,
          yValueMapper: (d, _) => d.y,
          color: Colors.blueAccent,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _splineChart() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      series: <SplineSeries>[
        SplineSeries<ChartData, String>(
          dataSource: [
            ChartData("Mon", 80),
            ChartData("Tue", 90),
            ChartData("Wed", 100),
            ChartData("Thu", 70),
            ChartData("Fri", 95),
          ],
          xValueMapper: (d, _) => d.x,
          yValueMapper: (d, _) => d.y,
          color: Colors.green,
          width: 3,
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.circle,
            borderWidth: 2,
            borderColor: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _targetVsReality() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      series: <CartesianSeries>[
        ColumnSeries<ChartData, String>(
          name: "Target",
          dataSource: [
            ChartData("Mon", 200),
            ChartData("Tue", 220),
            ChartData("Wed", 250),
            ChartData("Thu", 230),
            ChartData("Fri", 240),
          ],
          xValueMapper: (d, _) => d.x,
          yValueMapper: (d, _) => d.y,
          color: Colors.orange,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        ColumnSeries<ChartData, String>(
          name: "Actual",
          dataSource: [
            ChartData("Mon", 180),
            ChartData("Tue", 200),
            ChartData("Wed", 240),
            ChartData("Thu", 210),
            ChartData("Fri", 220),
          ],
          xValueMapper: (d, _) => d.x,
          yValueMapper: (d, _) => d.y,
          color: Colors.blue,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
      ],
    );
  }

  /// Format large numbers nicely
  static String _formatNumber(double value) {
    if (value >= 1e7) return "${(value / 1e7).toStringAsFixed(1)} Cr";
    if (value >= 1e5) return "${(value / 1e5).toStringAsFixed(1)} L";
    if (value >= 1e3) return "${(value / 1e3).toStringAsFixed(1)} K";
    return value.toStringAsFixed(0);
  }

  /// Format DateTime nicely
  static String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}

/// -------------------- DATA MODEL --------------------
class ChartData {
  final String x;
  final double y;
  ChartData(this.x, this.y);
}
