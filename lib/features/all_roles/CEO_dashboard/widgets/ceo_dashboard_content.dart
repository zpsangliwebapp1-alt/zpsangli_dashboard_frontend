import 'package:flutter/material.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/place_holder_chart.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/revenue_chart.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/stat_card.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/top_products.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/visitor_insights_chart.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../BDO_dashboard/widgets/Bdo_customer_satisfaction_chart.dart';
import 'ceo_info_card.dart';
import 'ceo_stat_card.dart';

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

  // ✅ Dummy data prepared once
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
    "Finance": [
      for (var block in BlockConstants.blocks)
        {
          "block": block,
          "Budget Allocated (₹ Cr)": 100 + block.length * 10,
          "Expenditure (₹ Cr)": 90 + block.length * 8,
          "Revenue Collected (₹ Cr)": 80 + block.length * 7,
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
  };

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
              // Block selector
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedBlock,
                  decoration: const InputDecoration(
                    labelText: "Select Block",
                    border: OutlineInputBorder(),
                  ),
                  items: BlockConstants.blocks
                      .map((block) => DropdownMenuItem(
                    value: block,
                    child: Text(block),
                  ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => selectedBlock = val);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Department selector
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedDepartment,
                  decoration: const InputDecoration(
                    labelText: "Select Department",
                    border: OutlineInputBorder(),
                  ),
                  items: DepartmentConstants.departments
                      .map((dept) => DropdownMenuItem(
                    value: dept,
                    child: Text(dept),
                  ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => selectedDepartment = val);
                    }
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
              Expanded(
                flex: 2,
                child: CeoInfoCard(
                  title: "Today's Sales",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Expanded(
                            child: CeoStatCard(
                              title: '\$1k',
                              subtitle: 'Total Sales',
                              hint: '+8% from yesterday',
                              color: Color(0xFFFFE7E7),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: CeoStatCard(
                              title: '300',
                              subtitle: 'Total Order',
                              hint: '+5% from yesterday',
                              color: Color(0xFFFFF3DB),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: CeoStatCard(
                              title: '5',
                              subtitle: 'Product Sold',
                              hint: '+1.2% from yesterday',
                              color: Color(0xFFEAFDF0),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: CeoStatCard(
                              title: '8',
                              subtitle: 'New Customers',
                              hint: '0.5% from yesterday',
                              color: Color(0xFFF1EBFF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Builder(
                        builder: (_) {
                          final deptList = departmentData[selectedDepartment];
                          final blockData = deptList?.firstWhere(
                                (row) => row["block"] == selectedBlock,
                            orElse: () => {},
                          );

                          if (blockData == null || blockData.isEmpty) {
                            return const Text("No data available for this selection");
                          }

                          return SalesSummaryChart(data: blockData);
                        },
                      ),

                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: CeoInfoCard(
                  title: 'Visitor Insights',
                  child: const VisitorInsightsChart(),
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
                    children: const [
                      SizedBox(height: 8),
                      TopProductsList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CeoInfoCard(
                  title: 'Sales Mapping by Country',
                  child: const PlaceholderChart(
                    height: 180,
                    label: 'World map (color regions)',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CeoInfoCard(
                  title: 'Volume vs Service Level',
                  child: const PlaceholderChart(
                    height: 180,
                    label: 'Volume vs Service Level (bars)',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
        ],
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
