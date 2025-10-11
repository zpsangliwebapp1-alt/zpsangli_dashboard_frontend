import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zp_sangali_dashboard_flutter/core/constants/app_colors.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../models/json_data_model.dart' show ApiItemLabels; // Import ApiItem with ApiItemLabels

class ChartData {
  final String x;
  final double y;
  ChartData(this.x, this.y);
}

class DepartmentOverviewCard extends StatelessWidget {
  final String block;
  final String department;
  final int departmentId; // ✅ departmentId injected
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
    required this.departmentId,
    required this.monthlyTotals,
    required this.lastUpdated,
    required this.selectedMonth,
    required this.selectedYear,
    this.departmentData,
    this.onRefresh,
    required this.satisfactionData,
  });

  static const double _cornerRadius = 16.0;

  // Fallback schemes
  List<Map<String, dynamic>> get _fallbackSchemes => [
    {"name": "PM-Kisan", "budget": 1200000.0, "spent": 900000.0},
    {"name": "MGNREGA", "budget": 2500000.0, "spent": 2000000.0},
    {"name": "Swachh Bharat", "budget": 800000.0, "spent": 600000.0},
    {"name": "Digital India", "budget": 500000.0, "spent": 450000.0},
  ];

  // Schemes for department
  List<Map<String, dynamic>> _schemesFromDepartment() {
    if (departmentData == null) return _fallbackSchemes;
    final entries = departmentData![department] ?? [];
    if (entries.isEmpty) return _fallbackSchemes;
    final latest = entries.last;
    print("Department Data keys: ${departmentData?.keys}");
    print("Looking for key: $department");

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
    // ✅ Get department labels dynamically
    final fieldLabels = ApiItemLabels.fromDepartment(departmentId);
    print("***********");
    print(fieldLabels);

    final totalTarget = monthlyTotals.values.fold(0.0, (s, m) => s + (m["target"] ?? 0.0));
    final totalAchievement = monthlyTotals.values.fold(0.0, (s, m) => s + (m["achievement"] ?? 0.0));
    final totalFinancial = monthlyTotals.values.fold(0.0, (s, m) => s + (m["financial"] ?? 0.0));
    final totalEstimatedCost = monthlyTotals.values.fold(0.0, (s, m) => s + (m["estimatedCost"] ?? 0.0));
    final schemes = _schemesFromDepartment();

    final smallTextStyle = GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
    );
    final mediumTextStyle = GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: AppColors.secondary,
    );
    final largeTextStyle = GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.primary,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cornerRadius),
      ),
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveLayout.isDesktop(context) ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Text(department, style: largeTextStyle),
            const SizedBox(height: 6),
            Text("Block: $block", style: mediumTextStyle),
            if (ResponsiveLayout.isDesktop(context))
              Row(
                children: [
                  Chip(
                    label: Text(
                      "Month: $selectedMonth",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    backgroundColor: Colors.deepPurple,
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      "Year: $selectedYear",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    backgroundColor: Colors.deepPurple,
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // KPI GRID
            ResponsiveLayout.isDesktop(context)
                ? Row(
              children: [
                Expanded(
                  child: _kpiCard(
                    context,
                    Icons.account_balance_wallet,
                    "${fieldLabels['unit'] ?? ''}${_formatNumber(totalFinancial)}",
                    fieldLabels['financialLabel'] ?? "Financial",
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _kpiCard(
                    context,
                    Icons.flag,
                    _formatNumber(totalTarget),
                    fieldLabels['targetLabel'] ?? "Target",
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _kpiCard(
                    context,
                    Icons.check_circle,
                    _formatNumber(totalAchievement),
                    fieldLabels['achievementLabel'] ?? "Achieved",
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _kpiCard(
                    context,
                    Icons.currency_rupee,
                    _formatNumber(totalEstimatedCost),
                    "Estimated Cost",
                    Colors.green,
                  ),
                ),
              ],
            )
                : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _kpiCard(
                        context,
                        Icons.account_balance_wallet,
                        "${fieldLabels['unit'] ?? ''}${_formatNumber(totalFinancial)}",
                        fieldLabels['financialLabel'] ?? "Financial",
                        Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _kpiCard(
                        context,
                        Icons.flag,
                        _formatNumber(totalTarget),
                        fieldLabels['targetLabel'] ?? "Target",
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _kpiCard(
                        context,
                        Icons.check_circle,
                        _formatNumber(totalAchievement),
                        fieldLabels['achievementLabel'] ?? "Achieved",
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _kpiCard(
                        context,
                        Icons.business,
                        "${schemes.length}",
                        "Schemes",
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            // CHART GRID 1
            _responsiveChartGrid1(
              context,
              satisfactionData,
              selectedMonth,
              selectedYear,
              monthlyTotals,
              totalTarget,
              totalAchievement,
              fieldLabels,
            ),

            const SizedBox(height: 18),

            // CHART GRID 2
            ResponsiveLayout.isDesktop(context)
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 300,
                    child: _chartCard(
                      "KPI Distribution",
                      _kpiPieChart(totalFinancial, totalTarget, totalAchievement, schemes.length, fieldLabels),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 300,
                    child: _chartCard("Budget Utilization", _pieChart(schemes, fieldLabels)),
                  ),
                ),
              ],
            )
                : Column(
              children: [
                SizedBox(
                  height: 250,
                  child: _chartCard(
                    "KPI Distribution",
                    _kpiPieChart(totalFinancial, totalTarget, totalAchievement, schemes.length, fieldLabels),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250,
                  child: _chartCard("Budget Utilization", _pieChart(schemes, fieldLabels)),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Achievements Timeline
            Text("Achievements Timeline", style: largeTextStyle),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // replace with actual achievements
                itemBuilder: (context, index) {
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text("Achievement ${index + 1}", style: mediumTextStyle)),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Last Updated: ${_formatDateTime(lastUpdated)}", style: smallTextStyle.copyWith(color: Colors.grey)),
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
    );
  }

  // ------------------ HELPER METHODS ------------------

  Widget _kpiCard(BuildContext context, IconData icon, String value, String label, Color color) {
    const Color kpiValueColor = Color(0xFF2E7D32);
    const Color kpiLabelColor = Color(0xFF6C757D);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.08),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: kpiValueColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: kpiLabelColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartCard(String title, Widget chart, {double? height}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.08),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: chart),
          ],
        ),
      ),
    );
  }

  // ------------------ CHART METHODS ------------------

  Widget _pieChart(List<Map<String, dynamic>> schemes, Map<String, String> labels) {
    return SfCircularChart(
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      series: <CircularSeries>[
        DoughnutSeries<Map<String, dynamic>, String>(
          dataSource: schemes,
          xValueMapper: (d, _) => d["name"],
          yValueMapper: (d, _) => d["spent"],
          dataLabelMapper: (d, _) =>
          "${d["name"]}: ${_formatNumber(d["spent"])} ${labels['unit'] ?? ''}",
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

  Widget _kpiPieChart(
      double totalBudget,
      double totalTarget,
      double totalAchievement,
      int totalSchemes,
      Map<String, String> labels,
      ) {
    final pieData = [
      {"name": labels['financialLabel'] ?? "Budget", "value": totalBudget},
      {"name": labels['targetLabel'] ?? "Target", "value": totalTarget},
      {"name": labels['achievementLabel'] ?? "Achievement", "value": totalAchievement},
      {"name": "Schemes", "value": totalSchemes.toDouble()},
    ];
    return SfCircularChart(
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      series: <CircularSeries>[
        DoughnutSeries<Map<String, dynamic>, String>(
          dataSource: pieData,
          xValueMapper: (d, _) => d["name"] as String,
          yValueMapper: (d, _) => d["value"] as double,
          dataLabelMapper: (d, _) => "${_formatNumber(d["value"])} ${labels['unit'] ?? ''}",
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

  Widget _responsiveChartGrid1(
      BuildContext context,
      Map<String, double> satisfactionData,
      String selectedMonth,
      String selectedYear,
      Map<String, Map<String, double>> monthlyTotals,
      double totalTarget,
      double totalAchievement,
      Map<String, String> fieldLabels,
      ) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 800;
    final isMobile = !isDesktop;

    final chartHeight = isMobile ? 220.0 : 300.0;
    final spacing = isMobile ? 12.0 : 16.0;

    Widget achievementChart = _chartCard(
      "Achievement Trend",
      professionalSplineChart(satisfactionData, fieldLabels['achievementLabel'] ?? "Achievement"),
      height: chartHeight,
    );

    Widget targetVsActualChart = _chartCard(
      "Target vs Actual",
      _targetVsReality(
        monthlyTotals,
        totalTarget,
        totalAchievement,
        selectedMonth,
        selectedYear,
        fieldLabels,
      ),
      height: chartHeight,
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: achievementChart),
          SizedBox(width: spacing),
          Expanded(child: targetVsActualChart),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            achievementChart,
            SizedBox(height: spacing),
            targetVsActualChart,
          ],
        ),
      );
    }
  }

  // ------------------ UTILITY METHODS ------------------

  static String _formatNumber(double value) {
    if (value >= 1e7) return "${(value / 1e7).toStringAsFixed(1)} Cr";
    if (value >= 1e5) return "${(value / 1e5).toStringAsFixed(1)} L";
    if (value >= 1e3) return "${(value / 1e3).toStringAsFixed(1)} K";
    return value.toStringAsFixed(0);
  }

  static String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  Widget _targetVsReality(
      Map<String, Map<String, double>> monthlyTotals,
      double totalTarget,
      double totalAchievement,
      String selectedMonth,
      String selectedYear,
      Map<String, String> fieldLabels,
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
        for (var entry in monthlyTotals.entries) ChartData(entry.key, entry.value["target"] ?? 0.0)
      ];
      actualSeries = [
        for (var entry in monthlyTotals.entries) ChartData(entry.key, entry.value["achievement"] ?? 0.0)
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
                  "Total ${fieldLabels['targetLabel'] ?? 'Target'} ($selectedMonth $selectedYear): ${_formatNumber(totalTarget)} ${fieldLabels['unit'] ?? ''}",
                  style: mediumTextStyle.copyWith(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Chip(
                backgroundColor: Colors.blue.shade50,
                label: Text(
                  "Total ${fieldLabels['achievementLabel'] ?? 'Achieved'} ($selectedMonth $selectedYear): ${_formatNumber(totalAchievement)} ${fieldLabels['unit'] ?? ''}",
                  style: mediumTextStyle.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              title: AxisTitle(
                text: "Month",
                textStyle: mediumTextStyle.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                text: "${fieldLabels['unit'] ?? ''} ${fieldLabels['achievementLabel'] ?? 'Value'}",
                textStyle: mediumTextStyle.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            legend: const Legend(isVisible: true, position: LegendPosition.bottom),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              header: "",
              format: '{point.x} : {point.y}' + (fieldLabels['unit'] ?? ''),
              textStyle: mediumTextStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            series: <CartesianSeries>[
              ColumnSeries<ChartData, String>(
                name: fieldLabels['targetLabel'] ?? "Target",
                dataSource: targetSeries,
                xValueMapper: (d, _) => d.x,
                yValueMapper: (d, _) => d.y,
                color: Colors.orange,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              ColumnSeries<ChartData, String>(
                name: fieldLabels['achievementLabel'] ?? "Achievement",
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

  Widget professionalSplineChart(
      Map<String, double> satisfactionData,
      String valueLabel, {
        String? unit,
        Map<String, String>? fieldLabels,
      }) {
    final chartData = [
      for (var entry in satisfactionData.entries) ChartData(entry.key, entry.value)
    ];

    // Determine minY and maxY safely
    double minY = 0;
    double maxY = 100;
    if (chartData.isNotEmpty) {
      minY = chartData.map((e) => e.y).reduce((a, b) => a < b ? a : b);
      maxY = chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b);
      double padding = (maxY - minY) * 0.1;

      // Ensure minY != maxY
      if ((maxY - minY).abs() < 0.001) {
        maxY += 1;
        minY -= 1;
      }

      minY = (minY - padding).clamp(0, double.infinity);
      maxY = (maxY + padding).clamp(0, double.infinity);
    }

    // Safe interval calculation
    double interval = ((maxY - minY) / 4);
    if (interval <= 0) interval = 1;

    final largeTextStyle =
    GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700);
    final mediumTextStyle =
    GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500);

    return SfCartesianChart(
      plotAreaBackgroundColor: Colors.grey[50],
      legend: Legend(isVisible: false),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: "",
        format: '{point.x} : {point.y}' + (unit ?? '%'),
        textStyle: mediumTextStyle.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        canShowMarker: true,
      ),
      primaryXAxis: CategoryAxis(
        title: AxisTitle(
          text: valueLabel,
          textStyle: mediumTextStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        axisLine: const AxisLine(width: 1.5, color: Color(0xFF2E7D32)),
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: mediumTextStyle,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text:
          (fieldLabels?['unit'] ?? '%') + ' ' + (fieldLabels?['achievementLabel'] ?? 'Satisfaction'),
          textStyle: mediumTextStyle.copyWith(fontWeight: FontWeight.w600),
        ),
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
        interval: interval,
      ),
      series: chartData.isEmpty
          ? []
          : <CartesianSeries>[
        SplineAreaSeries<ChartData, String>(
          name: valueLabel,
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
  }}
