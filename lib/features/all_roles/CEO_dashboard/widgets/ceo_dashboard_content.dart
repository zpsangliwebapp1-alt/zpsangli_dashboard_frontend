  import 'package:flutter/material.dart';
  import 'package:zp_sangali_dashboard_flutter/core/widgets/place_holder_chart.dart';
  import 'package:zp_sangali_dashboard_flutter/core/widgets/revenue_chart.dart';
  import 'package:zp_sangali_dashboard_flutter/core/widgets/stat_card.dart';
  import 'package:zp_sangali_dashboard_flutter/core/widgets/top_products.dart';
  import 'package:zp_sangali_dashboard_flutter/core/widgets/visitor_insights_chart.dart';

  import 'package:fl_chart/fl_chart.dart';
  import 'package:flutter/material.dart';

  import '../../../../core/constants/app_colors.dart';
  import '../../../../core/constants/app_fonts.dart';
  import '../../../../core/constants/app_text_styles.dart';
  import '../../BDO_dashboard/widgets/Bdo_customer_satisfaction_chart.dart';
  import 'ceo_info_card.dart';
  import 'ceo_pie_chart.dart';
  import 'ceo_stat_card.dart';
import 'department_overview_card.dart';

  class BlockConstants {
    static const List<String> blocks = [
      "Atpadi",
      "Jath",
      "Kadegaon",
      "Kavathe Mahankal",
      "Khanapur",
      "Miraj",
      "Palus",
      "Shirala",
      "Tasgaon",
      "Walwa",
    ];
  }

  class DepartmentConstants {
    static const List<String> departments = [
      "ICDS",
      "Women & Child Welfare",
      "Rural Water Supply",
      "PWD",
      "Education Primary",
      "Finance",
      "Agriculture",
      "Gram Panchayat",
      "Education Secondary",
      "Animal Husbandry",
      "General Administration",
      "Minor Irrigation",
      "Social Welfare",
      "SWM"
    ];
  }

  class TimeConstants {
    static const List<String> periods = [
      "2023",
      "2024",
      "2025",
      "Last 6 Months",
      "Last 3 Months",
      "This Month",
    ];
  }


  class CeoDashboardContent extends StatefulWidget {
    final bool mobile;
    const CeoDashboardContent({super.key, this.mobile = false});

    @override
    State<CeoDashboardContent> createState() => _CeoDashboardContentState();
  }

  class _CeoDashboardContentState extends State<CeoDashboardContent> {
    String selectedBlock = BlockConstants.blocks.first;
    String selectedDepartment = DepartmentConstants.departments.first;

    String selectedTime = "";

    @override
    void initState() {
      super.initState();
      // Default to first available month
      selectedTime = availableMonths.isNotEmpty ? availableMonths.first : "";
    }


// Extract months dynamically from departmentData["Agriculture"]
    late final List<String> availableMonths = departmentData["Agriculture"]!
        .map((entry) => entry["month"] as String)
        .toSet()
        .toList();
    // ✅ Dummy data prepared for ALL departments and ALL blocks
    final Map<String, List<Map<String, dynamic>>> departmentData = {
      "ICDS": [
        for (var block in BlockConstants.blocks)
          {
            "block": block,
            "Anganwadi Centers": 10 + block.length,
            "Children Enrolled": 1000 + block.length * 20,
            "Malnutrition Cases": 30 + block.length,
          }
      ],
      "Women & Child Welfare": [
        for (var block in BlockConstants.blocks)
          {
            "block": block,
            "Self Help Groups": 200 + block.length * 5,
            "Women Benefited": 1500 + block.length * 15,
            "Child Welfare Schemes": 50 + block.length,
          }
      ],
      "Rural Water Supply": [
        for (var block in BlockConstants.blocks)
          {
            "block": block,
            "Households Covered": 5000 + block.length * 40,
            "Functional Taps": 3000 + block.length * 30,
            "Water Quality Issues": 20 + block.length,
          }
      ],
      "PWD": [
        for (var block in BlockConstants.blocks)
          {
            "block": block,
            "Roads Constructed (km)": 100 + block.length * 5,
            "Bridges Built": 10 + block.length,
            "Buildings Completed": 15 + block.length,
          }
      ],
      "Education Primary": [
        for (var block in BlockConstants.blocks)
          {
            "block": block,
            "Schools": 80 + block.length,
            "Students Enrolled": 4000 + block.length * 50,
            "Teachers Available": 200 + block.length * 3,
          }
      ],
      "Finance": [
        for (var block in BlockConstants.blocks)
          {
            "block": block,
            "Budget Allocated (₹ Cr)": 100 + block.length * 10,
            "Expenditure (₹ Cr)": 90 + block.length * 8,
            "Revenue Collected (₹ Cr)": 80 + block.length * 7,
          }
      ],
      "Agriculture": [
        {
          "month": "Oct-24",
          "block": "TOTAL",
          "नवीन विहीर": {"Target": 0, "Achievement": 0, "Financial": 0},
          "जुनी विहीर दुरुस्ती": {"Target": 0, "Achievement": 0, "Financial": 0},
          "शेततळे प्लास्टिक अस्तरीकरण": {"Target": 0, "Achievement": 0, "Financial": 0},
          "इनवेल बोरिंग": {"Target": 0, "Achievement": 0, "Financial": 0},
          "वीजजोडणी आकार": {"Target": 0, "Achievement": 0, "Financial": 0},
          "ठिबक सिंचन संच": {"Target": 0, "Achievement": 0, "Financial": 0},
          "तुषार सिंचन संच": {"Target": 0, "Achievement": 0, "Financial": 0},
          "पंप संच": {"Target": 0, "Achievement": 0, "Financial": 0},
          "सोलार पंप": {"Target": 0, "Achievement": 0, "Financial": 0},
          "पाईप": {"Target": 0, "Achievement": 0, "Financial": 0},
          "परसबाग": {"Target": 0, "Achievement": 0, "Financial": 0},
          "यंत्रसामुग्री": {"Target": 0, "Achievement": 0, "Financial": 0},
          "अभिकरण शूल्क": {"Target": 0, "Achievement": 0, "Financial": 0},
          "आकस्मिक खर्च": {"Target": 0, "Achievement": 0, "Financial": 0},
          "TOTAL": {"Target": 0, "Achievement": 0, "Financial": 0}
        },
        {
          "month": "Nov-24",
          "block": "TOTAL",
          "नवीन विहीर": {"Target": 0, "Achievement": 0, "Financial": 0},
          "जुनी विहीर दुरुस्ती": {"Target": 0, "Achievement": 0, "Financial": 0},
          "शेततळे प्लास्टिक अस्तरीकरण": {"Target": 0, "Achievement": 0, "Financial": 0},
          "इनवेल बोरिंग": {"Target": 0, "Achievement": 0, "Financial": 0},
          "वीजजोडणी आकार": {"Target": 0, "Achievement": 0, "Financial": 0},
          "ठिबक सिंचन संच": {"Target": 0, "Achievement": 0, "Financial": 0},
          "तुषार सिंचन संच": {"Target": 0, "Achievement": 0, "Financial": 0},
          "पंप संच": {"Target": 0, "Achievement": 0, "Financial": 0},
          "सोलार पंप": {"Target": 0, "Achievement": 0, "Financial": 0},
          "पाईप": {"Target": 0, "Achievement": 0, "Financial": 0},
          "परसबाग": {"Target": 0, "Achievement": 0, "Financial": 0},
          "यंत्रसामुग्री": {"Target": 0, "Achievement": 0, "Financial": 0},
          "अभिकरण शूल्क": {"Target": 0, "Achievement": 0, "Financial": 0},
          "आकस्मिक खर्च": {"Target": 0, "Achievement": 0, "Financial": 0},
          "TOTAL": {"Target": 0, "Achievement": 0, "Financial": 0}
        },

      ],



      "Gram Panchayat": [
        for (var block in BlockConstants.blocks)
          {
            "block": block,
            "Village Panchayats": 50 + block.length,
            "Schemes Implemented": 20 + block.length * 2,
            "Pending Projects": 5 + block.length,
          }
      ],
      "Education Secondary": [
        for (var block in BlockConstants.blocks)
          {
            "block": block,
            "High Schools": 30 + block.length,
            "Students Enrolled": 6000 + block.length * 40,
            "Teachers Available": 350 + block.length * 4,
          }
      ],
      "Animal Husbandry": [
        for (var block in BlockConstants.blocks)
          {
            "block": block,
            "Cattle Population": 10000 + block.length * 200,
            "Veterinary Clinics": 15 + block.length,
            "Milk Production (liters)": 20000 + block.length * 300,
          }
      ],
      "General Administration": [
        for (var block in BlockConstants.blocks)
          {
            "block": block,
            "Offices Functional": 30 + block.length,
            "Employees": 500 + block.length * 10,
            "Citizen Services Delivered": 1000 + block.length * 25,
          }
      ],
      "Minor Irrigation": [
        for (var block in BlockConstants.blocks)
          {
            "block": block,
            "Irrigation Projects": 40 + block.length,
            "Storage Capacity (MLD)": 200 + block.length * 5,
            "Farmers Benefited": 1000 + block.length * 15,
          }
      ],
      "Social Welfare": [
        for (var block in BlockConstants.blocks)
          {
            "block": block,
            "Beneficiaries": 5000 + block.length * 60,
            "Pension Distributed (₹)": 100 + block.length * 2,
            "Welfare Schemes": 15 + block.length,
          }
      ],
      "SWM": [
        {"block": "Atpadi", "Target": 32, "Achievement": 19, "Remaining": 13, "Percent": 59.38},
        {"block": "Jath", "Target": 89, "Achievement": 50, "Remaining": 39, "Percent": 56.18},
        {"block": "Kadegaon", "Target": 25, "Achievement": 7, "Remaining": 18, "Percent": 28.00},
        {"block": "KavtheMahankal", "Target": 29, "Achievement": 9, "Remaining": 20, "Percent": 31.03},
        {"block": "Khanapur", "Target": 36, "Achievement": 13, "Remaining": 23, "Percent": 36.11},
        {"block": "Miraj", "Target": 57, "Achievement": 25, "Remaining": 32, "Percent": 43.86},
        {"block": "Palus", "Target": 24, "Achievement": 6, "Remaining": 18, "Percent": 25.00},
        {"block": "Shirala", "Target": 8, "Achievement": 4, "Remaining": 4, "Percent": 50.00},
        {"block": "Tasgaon", "Target": 39, "Achievement": 21, "Remaining": 18, "Percent": 53.85},
        {"block": "Walwa", "Target": 74, "Achievement": 44, "Remaining": 30, "Percent": 59.46},

        // ✅ AUTO TOTAL
        {
          "block": "TOTAL",
          "Target": [32, 89, 25, 29, 36, 57, 24, 8, 39, 74].reduce((a, b) => a + b),
          "Achievement": [19, 50, 7, 9, 13, 25, 6, 4, 21, 44].reduce((a, b) => a + b),
          "Remaining": [13, 39, 18, 20, 23, 32, 18, 4, 18, 30].reduce((a, b) => a + b),
          "Percent": (198 / 413 * 100),
        },
      ],
    };

    List<Map<String, dynamic>> _getFilteredData() {
      final deptData = departmentData[selectedDepartment] ?? [];

      // 👉 Only filter Agriculture if a month is selected
      if (selectedDepartment == "Agriculture" && selectedTime.contains("-")) {
        return deptData
            .where((entry) => entry["month"] == selectedTime)
            .toList();
      }

      return deptData;
    }


    @override
    Widget build(BuildContext context) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔽 Dropdown Filters
            Row(
              children: [
                // 🔹 Block selector
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedBlock,
                    decoration: _dropdownDecoration("Select Block", context),
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: Colors.grey.shade800,
                      fontWeight: AppFonts.regular,
                    ),
                    items: BlockConstants.blocks
                        .map((block) => DropdownMenuItem(
                      value: block,
                      child: Text(block,
                          style: AppTextStyles.bodySmall(context)
                              .copyWith(color: Colors.grey.shade800)),
                    ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedBlock = val);
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // 🔹 Department selector
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedDepartment,
                    decoration: _dropdownDecoration("Select Department", context),
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: Colors.grey.shade800,
                      fontWeight: AppFonts.regular,
                    ),
                    items: DepartmentConstants.departments
                        .map((dept) => DropdownMenuItem(
                      value: dept,
                      child: Text(dept,
                          style: AppTextStyles.bodySmall(context)
                              .copyWith(color: Colors.grey.shade800)),
                    ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedDepartment = val);
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // 🔹 Time selector
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedTime,
                    items: availableMonths.map((month) => DropdownMenuItem(
                      value: month,
                      child: Text(month),
                    )).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedTime = val);
                    },

                  ),
                ),
              ],
            ),


            const SizedBox(height: 24),

            // 👇 Rest of your original dashboard UI (unchanged)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Left side (Department Data + Stat Cards)
// 🔹 Replace your Left + Right side split with one combined card
                Expanded(
                  flex: 3,
                  child: CeoInfoCard(
                    title: "Department Overview",
                    child: Builder(
                      builder: (context) {
                        final filteredData = _getFilteredData();

                        if (filteredData.isEmpty) {
                          return Center(
                            child: Text(
                              "No data available",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          );
                        }

                        final blockData = filteredData.first;

                        return DepartmentOverviewCard(
                          block: selectedBlock,
                          department: selectedDepartment,
                          blockData: blockData,
                        );
                      },
                    ),
                  ),
                ),






              ],
            ),


            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CeoInfoCard(
                    title: 'Total Revenue',
                    child: const RevenueChart(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CeoInfoCard(
                    title: 'Customer Satisfaction',
                    child: const CeoCustomerSatisfactionChart(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CeoInfoCard(
                    title: 'Target vs Reality',
                    child: const PlaceholderChart(
                      height: 180,
                      label: 'Target vs Reality (bars)',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CeoInfoCard(
                    title: 'Top Products',
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                      TopProductsList(department: "SWM", departmentData: departmentData, // pass your map here

                      ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Expanded(
                //   child: CeoInfoCard(
                //     title: 'Sales Mapping by Country',
                //     child: const PlaceholderChart(
                //       height: 180,
                //       label: 'World map (color regions)',
                //     ),
                //   ),
                // ),
                const SizedBox(width: 16),
                // Expanded(
                //   child: CeoInfoCard(
                //     title: 'Volume vs Service Level',
                //     child: const PlaceholderChart(
                //       height: 180,
                //       label: 'Volume vs Service Level (bars)',
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 36),
          ],
        ),
      );
    }

    InputDecoration _dropdownDecoration(String label, BuildContext context) {
      return InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodySmall(context).copyWith(
          fontWeight: AppFonts.medium,
          color: Colors.grey.shade700,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
      );
    }

// 🔹 Helper Widget for KPI Cards
    Widget _infoKpiCard(String title, String value, IconData icon) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.blue, size: 20),
              const SizedBox(height: 6),
              Text(value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
              const SizedBox(height: 2),
              Text(title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  )),
            ],
          ),
        ),
      );
    }
  }


  class SalesSummaryChart extends StatelessWidget {
    final Map<String, dynamic> data;

    const SalesSummaryChart({
      super.key,
      required this.data,
    });

    @override
    Widget build(BuildContext context) {
      // Convert map to entries but remove "block" field
      final entries = data.entries.where((e) => e.key != "block").toList();

      return SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() < entries.length) {
                      return Text(
                        entries[value.toInt()].key,
                        style: const TextStyle(fontSize: 9),
                        textAlign: TextAlign.center,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, interval: 500),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            barGroups: [
              for (int i = 0; i < entries.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: (entries[i].value as num).toDouble(),
                      width: 18,
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    }
  }
