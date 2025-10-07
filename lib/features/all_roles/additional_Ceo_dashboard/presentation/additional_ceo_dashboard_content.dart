import 'package:flutter/material.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/place_holder_chart.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/revenue_chart.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/stat_card.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/top_products.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/visitor_insights_chart.dart';


import '../../../../core/widgets/customer_satisfaction_chart.dart';
import '../../../../core/widgets/info_card.dart';
import '../widgets/ceo_info_card.dart';


class AdditionalCeoDashboardContent extends StatelessWidget {
  final bool mobile;
  const AdditionalCeoDashboardContent({super.key, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    // Main scrollable content area; we arrange cards to mirror the screenshot
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Row 1: Today's Sales (big) + Visitor Insights (chart)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: AdditionalCeoInfoCard(
                  title: "Today's Sales",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top stat small boxes
                      Row(
                        children: const [
                          Expanded(child: StatCard(title: '\$1k', subtitle: 'Total Sales', hint: '+8% from yesterday', color: Color(0xFFFFE7E7))),
                          SizedBox(width: 12),
                          Expanded(child: StatCard(title: '300', subtitle: 'Total Order', hint: '+5% from yesterday', color: Color(0xFFFFF3DB))),
                          SizedBox(width: 12),
                          Expanded(child: StatCard(title: '5', subtitle: 'Product Sold', hint: '+1.2% from yesterday', color: Color(0xFFEAFDF0))),
                          SizedBox(width: 12),
                          Expanded(child: StatCard(title: '8', subtitle: 'New Customers', hint: '0.5% from yesterday', color: Color(0xFFF1EBFF))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Placeholder for summary or small chart
                      const PlaceholderChart(height: 120, label: 'Sales Summary Chart'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: InfoCard(
                  title: 'Visitor Insights',
                  child: const VisitorInsightsChart(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row 2: Total Revenue | Customer Satisfaction | Target vs Reality
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InfoCard(
                  title: 'Total Revenue',
                  child: RevenueChart(revenueData: _getRevenueData()), // ✅ call the method
                ),
              ),

              const SizedBox(width: 16),
              Expanded(
                child: InfoCard(
                  title: 'Customer Satisfaction',
                  child: const CustomerSatisfactionChart(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InfoCard(
                  title: 'Target vs Reality',
                  child: const PlaceholderChart(height: 180, label: 'Target vs Reality (bars)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row 3: Top Products | Sales Mapping by Country | Volume vs Service Level
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded(
              //   child: InfoCard(
              //     title: 'Top Yojna',
              //     child: Column(
              //       children: const [
              //         SizedBox(height: 8),
              //         EkatmikBalvikastTopYojnaList(),
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(width: 16),
              Expanded(
                child: InfoCard(
                  title: 'Sales Mapping by Country',
                  child: const PlaceholderChart(height: 180, label: 'World map (color regions)'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InfoCard(
                  title: 'Volume vs Service Level',
                  child: const PlaceholderChart(height: 180, label: 'Volume vs Service Level (bars)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Map<String, double> _getRevenueData() {
    return {
      "Jan": 12000,
      "Feb": 15000,
      "Mar": 9000,
      "Apr": 17000,
      "May": 13000,
      "Jun": 18000,
    };
  }
}
