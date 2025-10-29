import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import 'package:zp_sangali_dashboard_flutter/core/widgets/responsive_layout.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/ekatmik_balvikas_yojna_dashboard/widgets/stat_card.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/public_dashboard/widgets/public_stat_card.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/public_dashboard/widgets/public_TopYojnaList.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/public_dashboard/widgets/public_customer_satisfaction_chart.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/public_dashboard/widgets/public_info_card.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/public_dashboard/widgets/public_revenue_chart.dart';
import '../../../../core/constants/broadcast_carosal.dart';
import '../../CEO_dashboard/presentation/ceo_dashboard_content.dart';
import '../provider/broadcast_provider.dart';

class PublicDashboardContent extends StatelessWidget {
  final bool mobile;
  const PublicDashboardContent({super.key, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Latest Announcements",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height:18),
          /// 📊 Row 1: Info Cards - Responsive Layout
          ///      /// --- 📸 Carousel Section ---
          BroadcastFeed(),
          SizedBox(height:12),

          ResponsiveLayout(
            mobile: Column(
              children: [
                _statRowMobile(context),
                const SizedBox(height: 12),
                _statRowMobile2(context),
              ],
            ),
            tablet: Column(
              children: [
                _statRowTablet(context),
                const SizedBox(height: 12),
                _statRowTablet2(context),
              ],
            ),
            desktop: Column(
              children: [
                _statRowDesktop(context),
                const SizedBox(height: 16),
                _statRowDesktop2(context),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 🏷️ Carousel Slider
          Text(
            "Latest Schemes / नवीन योजना",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),



          const SizedBox(height: 24),

          /// 📈 Charts Section
          ResponsiveLayout(
            mobile: Column(
              children: [
                PublicInfoCard(
                  title: 'Monthly Expenditure - Supplementary Nutrition (₹)',
                  child: const PublicRevenueChart(),
                ),
                const SizedBox(height: 12),
                PublicInfoCard(
                  title: 'Customer Satisfaction',
                  child: const PublicCustomerSatisfactionChart(),
                ),
              ],
            ),
            tablet: Row(
              children: [
                Expanded(
                  child: PublicInfoCard(
                    title: 'Monthly Expenditure - Supplementary Nutrition (₹)',
                    child: const PublicRevenueChart(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PublicInfoCard(
                    title: 'Customer Satisfaction',
                    child: const PublicCustomerSatisfactionChart(),
                  ),
                ),
              ],
            ),
            desktop: Row(
              children: [
                Expanded(
                  child: PublicInfoCard(
                    title: 'Monthly Expenditure - Supplementary Nutrition (₹)',
                    child: const PublicRevenueChart(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: PublicInfoCard(
                    title: 'Ekatmik Balvikas Yojna Report (Quarterly)',
                    child: const PublicCustomerSatisfactionChart(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 📝 Top Yojna List
          PublicInfoCard(
            title: 'Ekatmik Balvikas Yojna / एकात्मिक बालविकास योजना',
            child: const PublicTopYojnaList(),
          ),
        ],
      ),
    );
  }

  // 📥 Reusable BottomSheet — Detail List
  void _showDetailSheet(BuildContext context, String title, List<String> dataList) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: dataList.length,
                  itemBuilder: (_, index) => ListTile(
                    leading: const Icon(Icons.circle, size: 10),
                    title: Text(
                      dataList[index],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🖼️ Carousel Widget
  Widget _buildSchemesCarousel() {
    return Consumer<PublicBroadcastProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.broadcasts.isEmpty) {
          return const SizedBox(
            height: 180,
            child: Center(child: Text('No active broadcasts')),
          );
        }

        return CarouselSlider.builder(
          itemCount: provider.broadcasts.length,
          itemBuilder: (context, index, realIndex) {
            final broadcast = provider.broadcasts[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  broadcast.imageUrl != null
                      ? Image.network(
                    broadcast.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    ),
                  )
                      : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    right: 16,
                    child: Text(
                      broadcast.message ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.easeInOut,
          ),
        );
      },
    );
  }

  // 📊 Stat Rows — Mobile, Tablet, Desktop
  Widget _statRowMobile(BuildContext context) => Column(
    children: [
      _buildStatCard(
        context,
        title: '1250',
        subtitle: 'Total Anganwadi Centers',
        hint: '+2% from last month',
        color: const Color(0xFFFFE7E7),
        list: ['Center 1 - Atpadi', 'Center 2 - Kavathe', 'Center 3 - Jath'],
      ),
      const SizedBox(height: 12),
      _buildStatCard(
        context,
        title: '18,500',
        subtitle: 'Children Enrolled (3-6 yrs)',
        hint: '+5% from last month',
        color: const Color(0xFFFFF3DB),
        list: ['Pre-School: 8500', 'Primary: 5000', 'Secondary: 3000'],
      ),
    ],
  );

  Widget _statRowMobile2(BuildContext context) => Column(
    children: [
      _buildStatCard(
        context,
        title: '3,200',
        subtitle: 'Pregnant Women Benefited',
        hint: 'Through ICDS Programs',
        color: const Color(0xFFEAFDF0),
        list: [
          'ICDS Scheme - 1200',
          'Arogya Mission - 800',
          'Poshan Abhiyaan - 1200',
        ],
      ),
      const SizedBox(height: 12),
      _buildStatCard(
        context,
        title: '12,000',
        subtitle: 'Nutrition Kits Distributed',
        hint: 'Poshan Abhiyaan 2025',
        color: const Color(0xFFF1EBFF),
        list: [
          'Poshan Abhiyaan - 4000',
          'Balvikas Mission - 3000',
          'CSR Programs - 5000',
        ],
      ),
    ],
  );

  Widget _statRowTablet(BuildContext context) => Row(
    children: [
      Expanded(
        child: _buildStatCard(
          context,
          title: '8,400',
          subtitle: 'Rural Households with Tap Water',
          hint: 'Jal Jeevan Mission',
          color: const Color(0xFFDDF6FF),
          list: ['Sangliwadi - 2300', 'Tasgaon - 3100', 'Atpadi - 3000'],
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: _buildStatCard(
          context,
          title: '1,250',
          subtitle: 'Active Anganwadi Centers',
          hint: '+2% growth since 2024',
          color: const Color(0xFFFFE7E7),
          list: ['Atpadi - 230', 'Kavathe - 120', 'Jath - 180'],
        ),
      ),
    ],
  );

  Widget _statRowTablet2(BuildContext context) => Row(
    children: [
      Expanded(
        child: _buildStatCard(
          context,
          title: '95%',
          subtitle: 'School Enrollment (6–14 yrs)',
          hint: 'Sarva Shiksha Mission',
          color: const Color(0xFFE8F8EE),
          list: ['Primary: 6000', 'Middle: 4000', 'High School: 2500'],
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: _buildStatCard(
          context,
          title: '4,350',
          subtitle: 'Toilets Built in Villages',
          hint: 'Swachh Bharat Mission',
          color: const Color(0xFFFDF1E8),
          list: ['Completed: 4300', 'Under Construction: 50'],
        ),
      ),
    ],
  );

  Widget _statRowDesktop(BuildContext context) => Row(
    children: [
      Expanded(
        child: _buildStatCard(
          context,
          title: '8,400',
          subtitle: 'Rural Households with Tap Water',
          hint: 'Jal Jeevan Mission',
          color: const Color(0xFFDDF6FF),
          list: ['Sangliwadi', 'Atpadi', 'Tasgaon'],
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: _buildStatCard(
          context,
          title: '1,250',
          subtitle: 'Active Anganwadi Centers',
          hint: '+2% from last year',
          color: const Color(0xFFFFE7E7),
          list: ['Atpadi - 250', 'Miraj - 200'],
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: _buildStatCard(
          context,
          title: '95%',
          subtitle: 'School Enrollment (6–14 yrs)',
          hint: 'Sarva Shiksha Mission',
          color: const Color(0xFFE8F8EE),
          list: ['Primary - 95%', 'Secondary - 90%'],
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: _buildStatCard(
          context,
          title: '3,200',
          subtitle: 'Pregnant Women Benefited',
          hint: 'ICDS Schemes',
          color: const Color(0xFFF1EBFF),
          list: ['ICDS - 1200', 'Arogya - 2000'],
        ),
      ),
    ],
  );

  Widget _statRowDesktop2(BuildContext context) => Row(
    children: [
      Expanded(
        child: _buildStatCard(
          context,
          title: '12,000',
          subtitle: 'Nutrition Kits Distributed',
          hint: 'Poshan Abhiyaan 2025',
          color: const Color(0xFFFDF1E8),
          list: ['Distributed - 12,000'],
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: _buildStatCard(
          context,
          title: '4,350',
          subtitle: 'Toilets Built in Villages',
          hint: 'Swachh Bharat Mission',
          color: const Color(0xFFEFF8FA),
          list: ['Completed - 4350'],
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: _buildStatCard(
          context,
          title: '2,800',
          subtitle: 'Self-Help Groups Active',
          hint: 'Women Empowerment',
          color: const Color(0xFFF7E9FB),
          list: ['Total - 2800'],
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: _buildStatCard(
          context,
          title: '1,120',
          subtitle: 'Village Roads Repaired (km)',
          hint: 'Gramin Vikas Dept.',
          color: const Color(0xFFEAFDF0),
          list: ['Repaired - 1120 km'],
        ),
      ),
    ],
  );

  // 🧩 Reusable StatCard Builder
  Widget _buildStatCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String hint,
        required Color color,
        required List<String> list,
      }) {
    return GestureDetector(
      onTap: () => _showDetailSheet(context, subtitle, list),
      child: PublicStatCard(
        title: title,
        subtitle: subtitle,
        hint: hint,
        color: color,
      ),
    );
  }
}
