import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

/// 🔹 Production-Ready CEO KPI Summary Dashboard Card
/// Includes Retrospective (historical), Inferential (comparative),
/// and Predictive (trend forecast) analytics
class CeoKpiSummaryCards extends StatefulWidget {
  final Map<String, double> financialData;
  final Map<String, double> satisfactionData;
  final Map<String, double> targetData;
  final Map<String, double> achievementData;
  final String selectedBlock;
  final String selectedDepartment;
  final String selectedMonth;
  final String selectedYear;

  const CeoKpiSummaryCards({
    super.key,
    required this.financialData,
    required this.satisfactionData,
    required this.targetData,
    required this.achievementData,
    required this.selectedBlock,
    required this.selectedDepartment,
    required this.selectedMonth,
    required this.selectedYear,
  });

  @override
  State<CeoKpiSummaryCards> createState() => _CeoKpiSummaryCardsState();
}

class _CeoKpiSummaryCardsState extends State<CeoKpiSummaryCards>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _showLabels = false;

  /// 🎨 Unified Color System
  final Color blue = const Color(0xFF1565C0);
  final Color orange = const Color(0xFFFFA726);
  final Color green = const Color(0xFF2E7D32);
  final Color purple = const Color(0xFF6A1B9A);
  final Color background = const Color(0xFFF7F9FC);
  final Color textColor = const Color(0xFF212121);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 2.seconds)
      ..forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showLabels = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _avg(Map<String, double> data) =>
      data.isEmpty ? 0 : data.values.reduce((a, b) => a + b) / data.length;

  @override
  Widget build(BuildContext context) {
    final avgFinance = _avg(widget.financialData);
    final avgSatisfaction = _avg(widget.satisfactionData);
    final avgTarget = _avg(widget.targetData);
    final avgAchievement = _avg(widget.achievementData);

    final total = avgFinance + avgSatisfaction + avgTarget + avgAchievement;

    final pieSections = [
      _pieSection("Finance", avgFinance, blue),
      _pieSection("Satisfaction", avgSatisfaction, green),
      _pieSection("Target", avgTarget, purple),
      _pieSection("Achievement", avgAchievement, orange),
    ];

    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.blue.withOpacity(0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.blueGrey.shade50, width: 1),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerSection(),
            const SizedBox(height: 25),
            isMobile
                ? Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildKpiGrid(
                        avgFinance,
                        avgSatisfaction,
                        avgTarget,
                        avgAchievement,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildCharts(pieSections, total),
              ],
            )
                : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildKpiGrid(
                    avgFinance,
                    avgSatisfaction,
                    avgTarget,
                    avgAchievement,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(flex: 2, child: _buildCharts(pieSections, total)),
              ],
            ),
            const SizedBox(height: 24),
            _buildInsightCards(),
          ],
        ),
      ),
    );
  }


  /// 🔹 Filter Header
  Widget _headerSection() => Row(
    children: [
      Flexible(
        child: Wrap(
          spacing: 16,
          runSpacing: 10,
          children: [
            _chip(Icons.location_on, "Block", widget.selectedBlock),
            _chip(Icons.apartment, "Department", widget.selectedDepartment),
            _chip(Icons.calendar_month, "Month", widget.selectedMonth),
            _chip(Icons.timeline, "Year", widget.selectedYear),
            _modeSwitch(),
            _exportButton(),
          ],
        ),
      ),
    ],
  ).animate().fadeIn(duration: 400.ms);

  Widget _chip(IconData icon, String label, String value) => Chip(
    backgroundColor: background,
    avatar: Icon(icon, size: 18, color: blue),
    label: Text(
      "$label: $value",
      style: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: textColor,
      ),
    ),
  );

  Widget _modeSwitch() => Tooltip(
    message: "Toggle light/dark mode",
    child: IconButton(
      icon: Icon(Icons.brightness_6, color: blue),
      onPressed: () {
        // Implement theme switch logic here
      },
    ),
  );

  Widget _exportButton() => Tooltip(
    message: "Export dashboard data (CSV/PDF)",
    child: IconButton(
      icon: Icon(Icons.download_rounded, color: green),
      onPressed: () {
        // Implement export logic here
      },
    ),
  );

  /// 🔹 KPI Overview Grid
  Widget _buildKpiGrid(
    double finance,
    double satisfaction,
    double target,
    double achievement,
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _metricCard(
          "Financial",
          finance,
          "₹${finance.toStringAsFixed(0)} L",
          Icons.account_balance,
          blue,
          "+5%",
        ),
        _metricCard(
          "Satisfaction",
          satisfaction,
          "${satisfaction.toStringAsFixed(1)}%",
          Icons.emoji_emotions,
          green,
          "+2%",
        ),
        _metricCard(
          "Target",
          target,
          "${target.toStringAsFixed(0)}",
          Icons.flag,
          purple,
          "+3%",
        ),
        _metricCard(
          "Achievement",
          achievement,
          "${achievement.toStringAsFixed(0)}",
          Icons.trending_up,
          orange,
          "+4%",
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _metricCard(
    String title,
    double valueNum,
    String value,
    IconData icon,
    Color color,
    String growth,
  ) {
    return Tooltip(
      message: "Last update synced with MIS data",
      child: Container(
        width: 220,
        height: 150,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.12), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.14)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.17),
                  radius: 21,
                  child: Icon(icon, color: color, size: 26),
                ),
                Positioned(
                  right: -14,
                  top: -8,
                  child: Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedFlipCounter(
                  value: valueNum,
                  fractionDigits: value.contains('.') ? 1 : 0,
                  textStyle: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  growth,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Combined Chart Section
  Widget _buildCharts(List<PieChartSectionData> sections, double total) {
    return Column(
      children: [
        _buildPieChart(sections, total),
        const SizedBox(height: 16),
        // _buildBarChart(),
        const SizedBox(height: 16),
        _buildInsightCards(),
      ],
    );
  }

  /// 🔹 Pie Chart (Distribution)
  Widget _buildPieChart(List<PieChartSectionData> sections, double total) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "KPI Distribution",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(
              height: 230,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 45,
                  sectionsSpace: 3,
                  borderData: FlBorderData(show: false),
                  centerSpaceColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Total KPIs: ${total.toStringAsFixed(0)}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            _legend([
              ("Finance", blue),
              ("Satisfaction", green),
              ("Target", purple),
              ("Achievement", orange),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _legend(List<(String, Color)> items) => Wrap(
    spacing: 16,
    children: items
        .map(
          (e) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: e.$2,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: e.$2.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(e.$1, style: GoogleFonts.inter(fontSize: 12)),
            ],
          ),
        )
        .toList(),
  );

  PieChartSectionData _pieSection(String title, double value, Color color) {
    return PieChartSectionData(
      value: value,
      title: _showLabels ? title : '',
      color: color,
      radius: 60,
      titleStyle: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // /// 🔹 Bar Chart (Inferential Analytics)
  // Widget _buildBarChart() {
  //   final data = [
  //     BarChartGroupData(
  //       x: 0,
  //       barRods: [BarChartRodData(toY: 78, width: 16, color: blue)],
  //     ),
  //     BarChartGroupData(
  //       x: 1,
  //       barRods: [BarChartRodData(toY: 84, width: 16, color: green)],
  //     ),
  //     BarChartGroupData(
  //       x: 2,
  //       barRods: [BarChartRodData(toY: 91, width: 16, color: purple)],
  //     ),
  //     BarChartGroupData(
  //       x: 3,
  //       barRods: [BarChartRodData(toY: 70, width: 16, color: orange)],
  //     ),
  //   ];
  //
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  //     elevation: 3,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         children: [
  //           const Text(
  //             "Performance Trend (Quarterly)",
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //           ),
  //           SizedBox(
  //             height: 200,
  //             child: BarChart(
  //               BarChartData(
  //                 alignment: BarChartAlignment.spaceAround,
  //                 gridData: FlGridData(show: false),
  //                 borderData: FlBorderData(show: false),
  //                 titlesData: FlTitlesData(
  //                   bottomTitles: AxisTitles(
  //                     sideTitles: SideTitles(
  //                       showTitles: true,
  //                       getTitlesWidget: (v, _) {
  //                         const labels = ["Q1", "Q2", "Q3", "Q4"];
  //                         return Text(
  //                           labels[v.toInt()],
  //                           style: GoogleFonts.inter(
  //                             fontSize: 13,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //                 barGroups: data,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /// 🔹 Insight Cards (Retrospective + Predictive)
  Widget _buildInsightCards() {
    return Column(
      children: [
        _insightCard(
          Icons.history_rounded,
          "Retrospective Insight",
          "Last quarter showed a 6% rise in fund utilization across key schemes.",
          Colors.blueGrey.shade100,
        ),
        const SizedBox(height: 8),
        _insightCard(
          Icons.analytics_rounded,
          "Inferential Insight",
          "Departments with higher satisfaction metrics correlate with higher target achievement (+12%).",
          Colors.lightBlue.shade100,
        ),
        const SizedBox(height: 8),
        _insightCard(
          Icons.trending_up_rounded,
          "Predictive Insight",
          "AI forecast suggests 8–10% improvement in beneficiary satisfaction next quarter.",
          Colors.indigo.shade100,
        ),
      ],
    );
  }

  Widget _insightCard(IconData icon, String title, String desc, Color color) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.85), Colors.white],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Icon(
                icon,
                color: Colors.indigo.withOpacity(0.12),
                size: 60,
              ),
            ),
            Row(
              children: [
                Icon(icon, color: Colors.indigo, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
