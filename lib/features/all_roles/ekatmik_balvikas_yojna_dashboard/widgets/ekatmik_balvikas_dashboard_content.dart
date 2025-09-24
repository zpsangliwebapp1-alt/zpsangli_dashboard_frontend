import 'package:flutter/material.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/place_holder_chart.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/revenue_chart.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/stat_card.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/top_products.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/visitor_insights_chart.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/ekatmik_balvikas_yojna_dashboard/widgets/ekatmikBalvikastTopYojnaList.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/ekatmik_balvikas_yojna_dashboard/widgets/stat_card.dart';

import '../../../../core/widgets/responsive_layout.dart';
import 'ekatmik_yojns_customer_satisfaction_chart.dart';
import 'ekatmik_balvikas_info_card.dart';
import 'ekatmik_balvikas_revenue_chart.dart';

class EkatmikBalvikasDashboardContent extends StatelessWidget {
  final bool mobile;
  const EkatmikBalvikasDashboardContent({super.key, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          /// Row 1: Info cards (responsive wrap)
          ResponsiveLayout(
            mobile: Column(
              children: [
                _statRowMobile(),
                const SizedBox(height: 12),
                _statRowMobile2(),
              ],
            ),
            tablet: Column(
              children: [
                _statRowTablet(),
                const SizedBox(height: 12),
                _statRowTablet2(),
              ],
            ),
            desktop: Column(
              children: [
                _statRowDesktop(),
                const SizedBox(height: 16),
                _statRowDesktop2(),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// Row 2: Charts (wrap for smaller screens)
          ResponsiveLayout(
            mobile: Column(
              children: [
                EkatmikBalvikasInfoCard(
                  title: 'Monthly Expenditure - Supplementary Nutrition (₹)',
                  child: const EkatmikBalvikasRevenueChart(),
                ),
                const SizedBox(height: 12),
                EkatmikBalvikasInfoCard(
                  title: 'Customer Satisfaction',
                  child: const EkatmikYojnaCustomerSatisfactionChart(),
                ),
              ],
            ),
            tablet: Row(
              children: [
                Expanded(
                  child: EkatmikBalvikasInfoCard(
                    title: 'Monthly Expenditure - Supplementary Nutrition (₹)',
                    child: const EkatmikBalvikasRevenueChart(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: EkatmikBalvikasInfoCard(
                    title: 'Customer Satisfaction',
                    child: const EkatmikYojnaCustomerSatisfactionChart(),
                  ),
                ),
              ],
            ),
            desktop: Row(
              children: [
                Expanded(
                  child: EkatmikBalvikasInfoCard(
                    title: 'Monthly Expenditure - Supplementary Nutrition (₹)',
                    child: const EkatmikBalvikasRevenueChart(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: EkatmikBalvikasInfoCard(
                    title: 'Ekatmik Balvikas Yojna Report (Quarterly)',
                    child: const EkatmikYojnaCustomerSatisfactionChart(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// Row 3: Top Yojna List
          EkatmikBalvikasInfoCard(
            title: 'Ekatmik Balvikas Yojna / एकात्मिक बालविकास योजना',
            child: const EkatmikBalvikastTopYojnaList(),
          ),
        ],
      ),
    );
  }

  /// Different row configs
  Widget _statRowMobile() => Column(
    children: const [
      EkatmikBalvikasYojnaStatCard(
        title: '1250',
        subtitle: 'Total Anganwadi Centers',
        hint: '+2% from last month',
        color: Color(0xFFFFE7E7),
      ),
      SizedBox(height: 12),
      EkatmikBalvikasYojnaStatCard(
        title: '18,500',
        subtitle: 'Children Enrolled (3-6 yrs)',
        hint: '+5% from last month',
        color: Color(0xFFFFF3DB),
      ),
    ],
  );

  Widget _statRowMobile2() => Column(
    children: const [
      EkatmikBalvikasYojnaStatCard(
        title: '3,200',
        subtitle: 'Pregnant Women Benefited',
        hint: 'Stable',
        color: Color(0xFFEAFDF0),
      ),
      SizedBox(height: 12),
      EkatmikBalvikasYojnaStatCard(
        title: '12,000',
        subtitle: 'Nutrition Kits Distributed',
        hint: '+3% from last month',
        color: Color(0xFFF1EBFF),
      ),
    ],
  );

  Widget _statRowTablet() => Row(
    children: const [
      Expanded(
        child: EkatmikBalvikasYojnaStatCard(
          title: '1250',
          subtitle: 'Total Anganwadi Centers',
          hint: '+2% from last month',
          color: Color(0xFFFFE7E7),
        ),
      ),
      SizedBox(width: 16),
      Expanded(
        child: EkatmikBalvikasYojnaStatCard(
          title: '18,500',
          subtitle: 'Children Enrolled (3-6 yrs)',
          hint: '+5% from last month',
          color: Color(0xFFFFF3DB),
        ),
      ),
    ],
  );

  Widget _statRowTablet2() => Row(
    children: const [
      Expanded(
        child: EkatmikBalvikasYojnaStatCard(
          title: '3,200',
          subtitle: 'Pregnant Women Benefited',
          hint: 'Stable',
          color: Color(0xFFEAFDF0),
        ),
      ),
      SizedBox(width: 16),
      Expanded(
        child: EkatmikBalvikasYojnaStatCard(
          title: '12,000',
          subtitle: 'Nutrition Kits Distributed',
          hint: '+3% from last month',
          color: Color(0xFFF1EBFF),
        ),
      ),
    ],
  );

  Widget _statRowDesktop() => Row(
    children: const [
      Expanded(
        child: EkatmikBalvikasYojnaStatCard(
          title: '1250',
          subtitle: 'Total Anganwadi Centers',
          hint: '+2% from last month',
          color: Color(0xFFFFE7E7),
        ),
      ),
      SizedBox(width: 20),
      Expanded(
        child: EkatmikBalvikasYojnaStatCard(
          title: '18,500',
          subtitle: 'Children Enrolled (3-6 yrs)',
          hint: '+5% from last month',
          color: Color(0xFFFFF3DB),
        ),
      ),
      SizedBox(width: 20),
      Expanded(
        child: EkatmikBalvikasYojnaStatCard(
          title: '3,200',
          subtitle: 'Pregnant Women Benefited',
          hint: 'Stable',
          color: Color(0xFFEAFDF0),
        ),
      ),
      SizedBox(width: 20),
      Expanded(
        child: EkatmikBalvikasYojnaStatCard(
          title: '12,000',
          subtitle: 'Nutrition Kits Distributed',
          hint: '+3% from last month',
          color: Color(0xFFF1EBFF),
        ),
      ),
    ],
  );

  Widget _statRowDesktop2() => const SizedBox.shrink();
}
