import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../core/constants/app_colors.dart';

import 'dart:math' as math;
class ChartData {
  final String x;
  final double y;
  ChartData(this.x, this.y);
}

class DepartmentOverviewCard extends StatelessWidget {
  final String department;
  final String block;
  final int departmentId;
  final Map<String, double> satisfactionData;
  final DateTime lastUpdated;
  final VoidCallback? onRefresh;

  const DepartmentOverviewCard({
    super.key,
    required this.department,
    required this.block,
    required this.departmentId,
    required this.satisfactionData,
    required this.lastUpdated,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final entries = satisfactionData.entries.toList();

    final total = entries.fold(0.0, (s, e) => s + e.value);
    final avg = entries.isEmpty ? 0.0 : total / entries.length;
    final max = entries.isEmpty ? 0.0 : entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final min = entries.isEmpty ? 0.0 : entries.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final latest = entries.isEmpty ? 0.0 : entries.last.value;

    final titleStyle = GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold);
    final labelStyle = GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary);

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias, // 👈 ensures background image respects rounded corners
      child: Stack(
        children: [
          // 🖼️ Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_image.png"), // 👈 your image file
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.85), // soft overlay for readability
                  BlendMode.lighten,
                ),
              ),
            ),
          ),

          // 🌫️ Optional blur effect (for glassy background)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(0.2)),
          ),

          // 📊 Foreground content
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(department, style: titleStyle),
                const SizedBox(height: 4),
                Text("Block: $block", style: labelStyle),
                const SizedBox(height: 16),

                // KPI Cards
                Row(
                  children: [
                    Expanded(
                      child: _kpiCard(
                        Icons.bar_chart_rounded,
                        _formatNumber(latest),
                        "Current Achievement",
                        const Color(0xFF1E8FAB),
                        const Color(0xFF42C3D8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _kpiCard(
                        Icons.show_chart_rounded,
                        _formatNumber(avg),
                        "Average",
                        const Color(0xFF4CAF50),
                        const Color(0xFF81C784),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _kpiCard(
                        Icons.trending_up_rounded,
                        _formatNumber(max),
                        "Highest",
                        const Color(0xFFFF9800),
                        const Color(0xFFFFB74D),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _kpiCard(
                        Icons.trending_down_rounded,
                        _formatNumber(min),
                        "Lowest",
                        const Color(0xFFE53935),
                        const Color(0xFFEF5350),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Charts Section
                SizedBox(
                  height: 480,
                  child: chartCard(
                    "Performance Distribution",
                    PerformanceDashboard(
                      talukaData: _generateTalukaData(),
                      villageData: _generateVillageData(),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 260,
                  child: chartCard(
                    "Achievement Trend",
                    _splineChart(entries),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Last Updated: ${_formatDateTime(lastUpdated)}",
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                    if (onRefresh != null)
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.blue),
                        onPressed: onRefresh,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // ---- Reusable Widgets ----
  Widget _kpiCard(IconData icon, String value, String label, Color startColor, Color endColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: endColor.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }





  Widget chartCard(
      String title,
      Widget chart, {
        String? subtitle,
        Widget? action,
      }) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (action != null) action,
              ],
            ),

            // Optional subtitle
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Chart container with subtle border & elevation
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: chart,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Charts ----
  Widget _splineChart(List<MapEntry<String, double>> entries) {
    final data = entries.map((e) => ChartData(e.key, e.value)).toList();

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <SplineSeries<ChartData, String>>[
        SplineSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (d, _) => d.x,
          yValueMapper: (d, _) => d.y,
          color: Colors.blueAccent,
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        ),
      ],
    );
  }



  Widget _pieChart(List<MapEntry<String, double>> entries) {
    return SfCircularChart(
      title: ChartTitle(
        text: 'Taluka-wise Performance',
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.right,
        overflowMode: LegendItemOverflowMode.wrap,
        textStyle: const TextStyle(fontSize: 12),
      ),
      tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x : point.y%'),
      series: <DoughnutSeries<MapEntry<String, double>, String>>[
        DoughnutSeries<MapEntry<String, double>, String>(
          dataSource: entries,
          xValueMapper: (e, _) => e.key,
          yValueMapper: (e, _) => e.value,
          pointColorMapper: (e, _) => _getColorForSegment(e.key),
          dataLabelMapper: (e, _) => '${e.value.toStringAsFixed(2)}%',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          innerRadius: '60%',
          radius: '95%',
          explode: true,
          explodeOffset: '5%',
        ),
      ],
    );
  }

  /// 🎨 Gives consistent color to each Taluka (custom palette)
  Color _getColorForSegment(String talukaName) {
    const colors = [
      Color(0xFF4FC3F7),
      Color(0xFFFF8A65),
      Color(0xFFBA68C8),
      Color(0xFFFFD54F),
      Color(0xFF81C784),
      Color(0xFFE57373),
      Color(0xFF64B5F6),
      Color(0xFFA1887F),
      Color(0xFFFFB74D),
      Color(0xFF90CAF9),
      Color(0xFF4DB6AC),
      Color(0xFF9575CD),
      Color(0xFF7986CB),
      Color(0xFFCE93D8),
    ];

    // Assign color based on index hash
    return colors[talukaName.hashCode % colors.length];
  }


  // ---- Utilities ----

  String _formatNumber(double val) {
    final formatter = NumberFormat.decimalPattern(); // adds commas, e.g., 1,62,200
    return formatter.format(val);
  }

  String _formatDateTime(DateTime dt) =>
      "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";

  List<Map<String, dynamic>> _generateTalukaData() {
    // Convert satisfactionData (Map<String, double>) to list of maps
    return satisfactionData.entries.map((e) {
      return {
        'name': e.key,
        'value': e.value,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _generateVillageData() {
    // Sort by value to show top 5 and bottom 5
    final sorted = satisfactionData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top5 = sorted.take(5).toList();
    final bottom5 = sorted.reversed.take(5).toList();

    // Merge top and worst performers
    final merged = [...top5, ...bottom5];

    return merged.map((e) => {
      'village': e.key,
      'value': e.value,
    }).toList();
  }

}






class KpiSection extends StatelessWidget {
  final double latest;
  final double avg;
  final double max;
  final double min;

  const KpiSection({
    super.key,
    required this.latest,
    required this.avg,
    required this.max,
    required this.min,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // 💻 Desktop → Row layout (4 items)
    if (width >= 1024) {
      return Row(
        children: [
          Expanded(
            child: ResponsiveKpiCard(
              icon: Icons.bar_chart_rounded,
              value: latest.toString(),
              label: "Current Achievement",
              startColor: const Color(0xFF1E8FAB),
              endColor: const Color(0xFF42C3D8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ResponsiveKpiCard(
              icon: Icons.show_chart_rounded,
              value: avg.toString(),
              label: "Average",
              startColor: const Color(0xFF4CAF50),
              endColor: const Color(0xFF81C784),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ResponsiveKpiCard(
              icon: Icons.trending_up_rounded,
              value: max.toString(),
              label: "Highest",
              startColor: const Color(0xFFFF9800),
              endColor: const Color(0xFFFFB74D),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ResponsiveKpiCard(
              icon: Icons.trending_down_rounded,
              value: min.toString(),
              label: "Lowest",
              startColor: const Color(0xFFE53935),
              endColor: const Color(0xFFEF5350),
            ),
          ),
        ],
      );
    }

    // 📱 Mobile / 💊 Tablet → 2x2 grid
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: width >= 600 ? 2.2 : 1.3,
      children: [
        ResponsiveKpiCard(
          icon: Icons.bar_chart_rounded,
          value: latest.toString(),
          label: "Current Achievement",
          startColor: const Color(0xFF1E8FAB),
          endColor: const Color(0xFF42C3D8),
        ),
        ResponsiveKpiCard(
          icon: Icons.show_chart_rounded,
          value: avg.toString(),
          label: "Average",
          startColor: const Color(0xFF4CAF50),
          endColor: const Color(0xFF81C784),
        ),
        ResponsiveKpiCard(
          icon: Icons.trending_up_rounded,
          value: max.toString(),
          label: "Highest",
          startColor: const Color(0xFFFF9800),
          endColor: const Color(0xFFFFB74D),
        ),
        ResponsiveKpiCard(
          icon: Icons.trending_down_rounded,
          value: min.toString(),
          label: "Lowest",
          startColor: const Color(0xFFE53935),
          endColor: const Color(0xFFEF5350),
        ),
      ],
    );
  }
}





class ResponsiveKpiCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color startColor;
  final Color endColor;

  const ResponsiveKpiCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // 📱 Responsive scaling
    double iconSize;
    double padding;
    double valueFont;
    double labelFont;

    if (width >= 1024) {
      // 💻 Desktop
      iconSize = 28;
      padding = 18;
      valueFont = 22;
      labelFont = 14;
    } else if (width >= 600) {
      // 💊 Tablet
      iconSize = 24;
      padding = 16;
      valueFont = 20;
      labelFont = 13;
    } else {
      // 📱 Mobile
      iconSize = 20;
      padding = 12;
      valueFont = 16;
      labelFont = 12;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: endColor.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: iconSize + 16,
              width: iconSize + 16,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: iconSize),
            ),
            SizedBox(height: padding * 0.6),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: valueFont,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: labelFont,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class PerformanceDashboard extends StatefulWidget {
  final List<Map<String, dynamic>>? talukaData;
  final List<Map<String, dynamic>>? villageData;

  const PerformanceDashboard({
    super.key,
    required this.talukaData,
    required this.villageData,
  });

  @override
  State<PerformanceDashboard> createState() => _PerformanceDashboardState();
}

class _PerformanceDashboardState extends State<PerformanceDashboard>
    with SingleTickerProviderStateMixin {
  late TooltipBehavior _tooltipBehavior;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _rotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _rotationAnimation = Tween<double>(begin: 0, end: 360).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
    _rotationController.forward();
  }

  @override
  void didUpdateWidget(covariant PerformanceDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _rotationController
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasTalukaData =
        widget.talukaData != null && widget.talukaData!.isNotEmpty;
    final hasVillageData =
        widget.villageData != null && widget.villageData!.isNotEmpty;

    // 🟡 If no data — show beautiful empty state
    if (!hasTalukaData && !hasVillageData) {
      return _buildNoDataUI(context);
    }

    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: hasTalukaData
                    ? Transform.rotate(
                  angle: (_rotationAnimation.value * math.pi) / 180,
                  child: SfCircularChart(
                    title: ChartTitle(
                      text: 'Taluka-wise Performance',
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.right,
                      overflowMode: LegendItemOverflowMode.wrap,
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    tooltipBehavior: _tooltipBehavior,
                    series: <DoughnutSeries<Map<String, dynamic>, String>>[
                      DoughnutSeries<Map<String, dynamic>, String>(
                        dataSource: widget.talukaData!,
                        xValueMapper: (data, _) => data['name'],
                        yValueMapper: (data, _) => data['value'],
                        pointColorMapper: (data, _) =>
                            _getColorForSegment(data['name']),
                        dataLabelMapper: (data, _) =>
                        '${data['value'].toStringAsFixed(2)}%',
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          textStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        innerRadius: '60%',
                        radius: '95%',
                        explode: true,
                        explodeOffset: '5%',
                      ),
                    ],
                  ),
                )
                    : _buildChartPlaceholder('No Taluka Data'),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: hasVillageData
                    ? SfCartesianChart(
                  title: ChartTitle(
                    text: 'Top/Worst Performing Villages',
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  primaryXAxis: CategoryAxis(
                    labelStyle: const TextStyle(fontSize: 12),
                    majorGridLines: const MajorGridLines(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    labelStyle: const TextStyle(fontSize: 11),
                    majorGridLines: const MajorGridLines(width: 0),
                  ),
                  series: <CartesianSeries<Map<String, dynamic>, String>>[
                    BarSeries<Map<String, dynamic>, String>(
                      dataSource: widget.villageData!,
                      xValueMapper: (data, _) => data['village'],
                      yValueMapper: (data, _) =>
                          (data['value'] as num).toDouble(),
                      pointColorMapper: (data, _) =>
                      data['value'] >= 20
                          ? Colors.cyan[300]
                          : Colors.pink[200],
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                )
                    : _buildChartPlaceholder('No Village Data'),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🎨 Professional no-data state (beautiful and animated)
  Widget _buildNoDataUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insights_outlined,
              size: 90, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'No Performance Data Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please refresh or check data source.',
            style: TextStyle(fontSize: 14, color: Colors.black45),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // e.g., trigger a refresh callback
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reload Data'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder(String message) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
              color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Color _getColorForSegment(String name) {
    final colors = [
      Colors.teal,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.cyan,
      Colors.green,
      Colors.indigo,
      Colors.redAccent,
    ];
    return colors[name.hashCode % colors.length];
  }
}


/// 🎨 Custom consistent colors
Color _getColorForSegment(String name) {
  const palette = [
    Color(0xFF4FC3F7),
    Color(0xFFFF8A65),
    Color(0xFFBA68C8),
    Color(0xFFFFD54F),
    Color(0xFF81C784),
    Color(0xFFE57373),
    Color(0xFF64B5F6),
    Color(0xFFA1887F),
    Color(0xFFFFB74D),
    Color(0xFF90CAF9),
    Color(0xFF4DB6AC),
    Color(0xFF9575CD),
  ];
  return palette[name.hashCode % palette.length];
}
