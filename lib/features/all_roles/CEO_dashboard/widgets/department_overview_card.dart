import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'ceo_pie_chart.dart';

class DepartmentOverviewCard extends StatelessWidget {
  final String block;
  final String department;
  final Map<String, dynamic> blockData;

  const DepartmentOverviewCard({
    super.key,
    required this.block,
    required this.department,
    required this.blockData,
  });

  @override
  Widget build(BuildContext context) {
    final chartData = {
      for (var e in blockData.entries)
        if (e.key.toLowerCase() != "block" && e.value is num)
          e.key: (e.value as num).toDouble(),
    };


    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 750;

          return isMobile
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              const SizedBox(height: 20),
              _tableSection(context),
              const SizedBox(height: 20),
              _highlightSection(context),
              const SizedBox(height: 20),
              _chartSection(chartData), // pie chart खाली येईल mobile वर
            ],
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Side (info, table, highlights)
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(context),
                    const SizedBox(height: 20),
                    _tableSection(context),
                    const SizedBox(height: 20),
                    // _highlightSection(context),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Right Side (PieChart)
              Expanded(
                flex: 1,
                child: _chartSection(chartData),
              ),
            ],
          );
        },
      ),
    );
  }

  // 🔹 Header
  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Left Accent Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.apartment_rounded,
              color: AppColors.primary,
              size: AppSizes.iconSize + 4,
            ),
          ),
          const SizedBox(width: 16),

          // 🔹 Titles
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Block: $block",
                style: AppTextStyles.headline2(context).copyWith(
                  fontWeight: AppFonts.semiBold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Department: $department",
                style: AppTextStyles.bodySmall(context).copyWith(
                  fontWeight: AppFonts.medium,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const Spacer(),

          // 🔹 Accent Gradient Bar
          Container(
            height: 28,
            width: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Table style list
  Widget _tableSection(BuildContext context) {
    final entries = blockData.entries.toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          // 🔹 Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade50,
                  Colors.blue.shade100.withOpacity(0.5),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Metric",
                    style: AppTextStyles.body(context).copyWith(
                      fontWeight: AppFonts.semiBold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  "Value",
                  style: AppTextStyles.body(context).copyWith(
                    fontWeight: AppFonts.semiBold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Scrollable Rows
          SizedBox(
            height: 250, // fixed height for scroll area
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < entries.length; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: i.isEven ? Colors.grey.shade50 : Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              entries[i].key,
                              style: AppTextStyles.bodySmall(context).copyWith(
                                fontWeight: AppFonts.medium,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            entries[i].value.toString(),
                            style: AppTextStyles.body(context).copyWith(
                              fontWeight: AppFonts.bold,
                              color: Colors.blueGrey.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Highlight cards
  Widget _highlightSection(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: blockData.entries.map((e) {
        return _highlightCard(e.key, e.value.toString(), context);
      }).toList(),
    );
  }

  Widget _highlightCard(String title, String value, BuildContext context) {
    final color = title.toLowerCase().contains("children")
        ? Colors.deepPurple
        : title.toLowerCase().contains("malnutrition")
        ? Colors.blue
        : Colors.orange;

    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "$title\nBlock $block",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 PieChart Section
  Widget _chartSection(Map<String, double> chartData) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Distribution",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 370,
            child: CeoPieChart(data: chartData),
          ),
        ],
      ),
    );
  }
}
