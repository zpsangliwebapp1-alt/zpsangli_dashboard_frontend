import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zp_sangali_dashboard_flutter/core/constants/app_colors.dart';
import '../../../../core/widgets/responsive_layout.dart';

class Achievement {
  final DateTime date;
  final String title;
  final double value;
  Achievement({required this.date, required this.title, required this.value});
}

// Also define ChartData unless you import it
class ChartData {
  final String x;
  final double y;
  ChartData(this.x, this.y);
}

class DepartmentOverviewCard extends StatelessWidget {
  final String block;
  final String department;
  final Map<String, Map<String, double>> monthlyTotals;
  final DateTime lastUpdated;
  final String selectedMonth;
  final String selectedYear;
  final Map<String, List<Map<String, dynamic>>>? departmentData;
  final VoidCallback? onRefresh;
  final Map<String, double> satisfactionData;

  const DepartmentOverviewCard({
    super.key,
    required this.block,
    required this.department,
    required this.monthlyTotals,
    required this.lastUpdated,
    required this.selectedMonth,
    required this.selectedYear,
    this.departmentData,
    this.onRefresh,
    required this.satisfactionData,
  });

  static const double _cornerRadius = 16.0;

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
    final totalTarget = monthlyTotals.values.fold(0.0, (s, m) => s + (m["target"] ?? 0.0));
    final totalAchievement = monthlyTotals.values.fold(0.0, (s, m) => s + (m["achievement"] ?? 0.0));
    final totalFinancial = monthlyTotals.values.fold(0.0, (s, m) => s + (m["financial"] ?? 0.0));
    final schemes = _schemesFromDepartment();

    final smallTextStyle = GoogleFonts.poppins(
        fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary
    );
    final mediumTextStyle = GoogleFonts.poppins(
        fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.secondary
    );
    final largeTextStyle = GoogleFonts.poppins(
        fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cornerRadius),
      ),
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(department, style: largeTextStyle),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          "Month: $selectedMonth",
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: Colors.deepPurple,
                      ),
                      const SizedBox(width: 12),
                      Chip(
                        label: Text(
                          "Year: $selectedYear",
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: Colors.deepPurple,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text("Block: $block", style: mediumTextStyle),
              const SizedBox(height: 12),

              // KPIs
              Row(
                children: [
                  _kpiCard(context, Icons.account_balance_wallet, "₹${_formatNumber(totalFinancial)}", "Total Budget", Colors.red),
                  const SizedBox(width: 12),
                  _kpiCard(context, Icons.flag, _formatNumber(totalTarget), "Total Target", Colors.orange),
                  const SizedBox(width: 12),
                  _kpiCard(context, Icons.check_circle, _formatNumber(totalAchievement), "Achievement", Colors.green),
                  const SizedBox(width: 12),
                  _kpiCard(context, Icons.business, "${schemes.length}", "Schemes", Colors.purple),
                ],
              ),
              const SizedBox(height: 18),

              // CHART GRID 1 - RESPONSIVE
              _responsiveChartGrid1(context, satisfactionData, selectedMonth, selectedYear, monthlyTotals, totalTarget, totalAchievement),
              const SizedBox(height: 18),

              // CHART GRID 2 (Can also make responsive if desired)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 300,
                      child: _chartCard("KPI Distribution", _kpiPieChart(totalFinancial, totalTarget, totalAchievement, schemes.length)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 300,
                      child: _chartCard("Budget Utilization", _pieChart(schemes)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ACHIEVEMENTS TIMELINE Placeholder
              Text("Achievements Timeline", style: largeTextStyle),
              const SizedBox(height: 8),
              // Insert your timeline or more widgets here

              const SizedBox(height: 18),

              // FOOTER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Last Updated: ${_formatDateTime(lastUpdated)}",
                    style: smallTextStyle.copyWith(color: Colors.grey),
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
        ),
      ),
    );
  }

  /// Responsive chart grid for Achievement Trend and Target vs Actual
  Widget _responsiveChartGrid1(
      BuildContext context,
      Map<String, double> satisfactionData,
      String selectedMonth,
      String selectedYear,
      Map<String, Map<String, double>> monthlyTotals,
      double totalTarget,
      double totalAchievement,
      ) {
    Widget achievementChart = SizedBox(
      height: 300,
      child: _chartCard(
        "Achievement Trend",
        professionalSplineChart(satisfactionData, "Achievement"),
      ),
    );
    Widget targetVsActualChart = SizedBox(
      height: 300,
      child: _chartCard(
        "Target vs Actual",
        _targetVsReality(monthlyTotals, totalTarget, totalAchievement, selectedMonth, selectedYear),
      ),
    );
    if (ResponsiveLayout.isDesktop(context)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: achievementChart),
          const SizedBox(width: 16),
          Expanded(child: targetVsActualChart),
        ],
      );
    } else {
      return Column(
        children: [
          achievementChart,
          const SizedBox(height: 16),
          targetVsActualChart,
        ],
      );
    }
  }

  Widget _kpiCard(BuildContext context, IconData icon, String value, String label, Color color) {
    const Color kpiValueColor = Color(0xFF2E7D32);
    const Color kpiLabelColor = Color(0xFF6C757D);

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
            color: color.withOpacity(0.10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 10),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: kpiValueColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kpiLabelColor,
                  letterSpacing: 0.1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chartCard(String title, Widget chart) {
    final largeTextStyle = GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cornerRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: largeTextStyle),
            const SizedBox(height: 12),
            Expanded(child: chart),
          ],
        ),
      ),
    );
  }

  // -- Chart methods unchanged below! --
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

  Widget _kpiPieChart(double totalBudget, double totalTarget, double totalAchievement, int totalSchemes) {
    final pieData = [
      {"name": "Budget", "value": totalBudget},
      {"name": "Target", "value": totalTarget},
      {"name": "Achievements", "value": totalAchievement},
      {"name": "Schemes", "value": totalSchemes.toDouble()},
    ];
    return SfCircularChart(
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      series: <CircularSeries>[
        DoughnutSeries<Map<String, dynamic>, String>(
          dataSource: pieData,
          xValueMapper: (d, _) => d["name"] as String,
          yValueMapper: (d, _) => d["value"] as double,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
          ),
          explode: true,
          explodeIndex: 0,
        ),
      ],
    );
  }

  Widget professionalSplineChart(Map<String, double> satisfactionData, String label) {
    final chartData = [
      for (var entry in satisfactionData.entries)
        ChartData(entry.key, entry.value)
    ];
    double minY = chartData.isNotEmpty ? chartData.map((e) => e.y).reduce((a, b) => a < b ? a : b) : 0;
    double maxY = chartData.isNotEmpty ? chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) : 1000;
    double padding = (maxY - minY) * 0.1;
    minY = minY - padding;
    maxY = maxY + padding;
    if (minY < 0) minY = 0;
    if (maxY > 1000) maxY = 1000;
    final largeTextStyle = GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700);
    final mediumTextStyle = GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500);
    return SfCartesianChart(
      plotAreaBackgroundColor: Colors.grey[50],
      title: ChartTitle(
        text: "",
        textStyle: largeTextStyle.copyWith(color: const Color(0xFF2E7D32)),
        alignment: ChartAlignment.near,
      ),
      legend: Legend(isVisible: false),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x : point.y%',
        header: "",
        textStyle: mediumTextStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        canShowMarker: true,
      ),
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: label, textStyle: mediumTextStyle.copyWith(fontWeight: FontWeight.w600)),
        axisLine: const AxisLine(width: 1.5, color: Color(0xFF2E7D32)),
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: mediumTextStyle,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: "Satisfaction %", textStyle: mediumTextStyle.copyWith(fontWeight: FontWeight.w600)),
        axisLine: const AxisLine(width: 1.5, color: Color(0xFF2E7D32)),
        majorTickLines: const MajorTickLines(size: 0),
        labelStyle: mediumTextStyle,
        majorGridLines: MajorGridLines(
          color: Colors.greenAccent.withOpacity(0.13),
          width: 1,
          dashArray: <double>[5, 3],
        ),
        minimum: minY,
        maximum: maxY,
        interval: ((maxY - minY) / 4).clamp(10, 25),
      ),
      series: <CartesianSeries>[
        SplineAreaSeries<ChartData, String>(
          name: "Satisfaction",
          dataSource: chartData,
          xValueMapper: (d, _) => d.x,
          yValueMapper: (d, _) => d.y,
          borderColor: Colors.green.shade700,
          borderWidth: 4,
          color: Colors.green.withOpacity(0.25),
          gradient: const LinearGradient(
            colors: [Color(0xFF43A047), Color(0xFFB2FF59)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.circle,
            borderWidth: 2,
            borderColor: Color(0xFF1565C0),
            color: Colors.white,
            width: 8,
            height: 8,
          ),
          dataLabelSettings: const DataLabelSettings(isVisible: false),
          opacity: 0.92,
        ),
      ],
    );
  }

  Widget _targetVsReality(
      Map<String, Map<String, double>> monthlyTotals,
      double totalTarget,
      double totalAchievement,
      String selectedMonth,
      String selectedYear,
      ) {
    final filteredMonthlyTotals = monthlyTotals.entries
        .where((e) => e.key == selectedMonth)
        .toList();
    List<ChartData> targetSeries = [];
    List<ChartData> actualSeries = [];
    if (filteredMonthlyTotals.isNotEmpty) {
      final monthData = filteredMonthlyTotals.first.value;
      targetSeries.add(ChartData(selectedMonth, monthData["target"] ?? 0.0));
      actualSeries.add(ChartData(selectedMonth, monthData["achievement"] ?? 0.0));
    } else {
      targetSeries = [
        for (var entry in monthlyTotals.entries)
          ChartData(entry.key, entry.value["target"] ?? 0.0)
      ];
      actualSeries = [
        for (var entry in monthlyTotals.entries)
          ChartData(entry.key, entry.value["achievement"] ?? 0.0)
      ];
    }
    final mediumTextStyle = GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Row(
            children: [
              Chip(
                backgroundColor: Colors.orange.shade50,
                label: Text(
                  "Total Target ($selectedMonth $selectedYear): ${_formatNumber(totalTarget)}",
                  style: mediumTextStyle.copyWith(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Chip(
                backgroundColor: Colors.blue.shade50,
                label: Text(
                  "Total Achieved ($selectedMonth $selectedYear): ${_formatNumber(totalAchievement)}",
                  style: mediumTextStyle.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(),
            legend: const Legend(isVisible: true, position: LegendPosition.bottom),
            series: <CartesianSeries>[
              ColumnSeries<ChartData, String>(
                name: "Target",
                dataSource: targetSeries,
                xValueMapper: (d, _) => d.x,
                yValueMapper: (d, _) => d.y,
                color: Colors.orange,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              ColumnSeries<ChartData, String>(
                name: "Actual",
                dataSource: actualSeries,
                xValueMapper: (d, _) => d.x,
                yValueMapper: (d, _) => d.y,
                color: Colors.blue,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatNumber(double value) {
    if (value >= 1e7) return "${(value / 1e7).toStringAsFixed(1)} Cr";
    if (value >= 1e5) return "${(value / 1e5).toStringAsFixed(1)} L";
    if (value >= 1e3) return "${(value / 1e3).toStringAsFixed(1)} K";
    return value.toStringAsFixed(0);
  }

  static String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
