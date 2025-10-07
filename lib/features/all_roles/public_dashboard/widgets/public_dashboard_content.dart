import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/responsive_layout.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/ekatmik_balvikas_yojna_dashboard/widgets/stat_card.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/public_dashboard/widgets/public_TopYojnaList.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/public_dashboard/widgets/public_stat_card.dart';
import 'public_customer_satisfaction_chart.dart';
import 'public_info_card.dart';
import 'public_revenue_chart.dart';

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
          /// Row 1: Info cards (responsive wrap)
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

          /// 🔹 Carousel Slider for Latest Schemes
          Text(
            "Latest Schemes / नवीन योजना",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildSchemesCarousel(),

          const SizedBox(height: 24),

          /// Row 2: Charts
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

          /// Row 3: Top Yojna List
          PublicInfoCard(
            title: 'Ekatmik Balvikas Yojna / एकात्मिक बालविकास योजना',
            child: const PublicTopYojnaList(),
          ),
        ],
      ),
    );
  }

  /// 🔹 Reusable bottom sheet to show data list
  void _showDetailSheet(
      BuildContext context, String title, List<String> dataList) {
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

  /// 🔹 Carousel Slider Widget
  Widget _buildSchemesCarousel() {
    final List<Map<String, String>> schemes = [
      {
        "title": "Arogya Mission Abhiyaan",
        "subtitle": "Nutritional awareness among rural families",
        "image": "assets/images/aroya_mission_banner.jpg",
      },
      {
        "title": "Jal Jeevan Mission",
        "subtitle": "Water purity and safety",
        "image": "assets/images/jal_jivan_banner.jpg",
      },
      {
        "title": "Krushi Yojna",
        "subtitle": "Support for rural farmers",
        "image": "assets/images/krushi_yojna_banner.jpg",
      },
    ];

    return CarouselSlider.builder(
      itemCount: schemes.length,
      itemBuilder: (context, index, realIndex) {
        final scheme = schemes[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(scheme["image"]!, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scheme["title"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scheme["subtitle"]!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
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
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayCurve: Curves.easeInOut,
      ),
    );
  }

  // ✅ Stat Rows
  Widget _statRowMobile(BuildContext context) => Column(
    children: [
      GestureDetector(
        onTap: () => _showDetailSheet(context, 'Anganwadi Centers', [
          'Center 1 - Atpadi',
          'Center 2 - Kavathe',
          'Center 3 - Jath',
        ]),
        child: const PublicStatCard(
          title: '1250',
          subtitle: 'Total Anganwadi Centers',
          hint: '+2% from last month',
          color: Color(0xFFFFE7E7),
        ),
      ),
      const SizedBox(height: 12),
      GestureDetector(
        onTap: () => _showDetailSheet(context, 'Children Enrolled', [
          'Pre-School: 8500',
          'Primary: 5000',
          'Secondary: 3000',
        ]),
        child: const PublicStatCard(
          title: '18,500',
          subtitle: 'Children Enrolled (3-6 yrs)',
          hint: '+5% from last month',
          color: Color(0xFFFFF3DB),
        ),
      ),
    ],
  );

  Widget _statRowMobile2(BuildContext context) => Column(
    children: [
      GestureDetector(
        onTap: () => _showDetailSheet(context, 'Pregnant Women Benefited', [
          'ICDS Scheme - 1200',
          'Arogya Mission - 800',
          'Poshan Abhiyaan - 1200',
        ]),
        child: const PublicStatCard(
          title: '3,200',
          subtitle: 'Pregnant Women Benefited',
          hint: 'Through ICDS Programs',
          color: Color(0xFFEAFDF0),
        ),
      ),
      const SizedBox(height: 12),
      GestureDetector(
        onTap: () =>
            _showDetailSheet(context, 'Nutrition Kits Distributed', [
              'Poshan Abhiyaan - 4000',
              'Balvikas Mission - 3000',
              'CSR Programs - 5000',
            ]),
        child: const PublicStatCard(
          title: '12,000',
          subtitle: 'Nutrition Kits Distributed',
          hint: 'Poshan Abhiyaan 2025',
          color: Color(0xFFF1EBFF),
        ),
      ),
    ],
  );

  Widget _statRowTablet(BuildContext context) => Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () => _showDetailSheet(context, 'Tap Water Households', [
            'Village: Sangliwadi - 2300',
            'Village: Tasgaon - 3100',
            'Village: Atpadi - 3000',
          ]),
          child: const PublicStatCard(
            title: '8,400',
            subtitle: 'Rural Households with Tap Water',
            hint: 'Jal Jeevan Mission',
            color: Color(0xFFDDF6FF),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: GestureDetector(
          onTap: () => _showDetailSheet(context, 'Active Anganwadi Centers', [
            'Atpadi - 230',
            'Kavathe - 120',
            'Jath - 180',
          ]),
          child: const PublicStatCard(
            title: '1,250',
            subtitle: 'Active Anganwadi Centers',
            hint: '+2% growth since 2024',
            color: Color(0xFFFFE7E7),
          ),
        ),
      ),
    ],
  );

  Widget _statRowTablet2(BuildContext context) => Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () => _showDetailSheet(context, 'School Enrollment', [
            'Primary: 6000',
            'Middle: 4000',
            'High School: 2500',
          ]),
          child: const PublicStatCard(
            title: '95%',
            subtitle: 'School Enrollment (6–14 yrs)',
            hint: 'Sarva Shiksha Mission',
            color: Color(0xFFE8F8EE),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: GestureDetector(
          onTap: () => _showDetailSheet(context, 'Village Toilets', [
            'Completed: 4300',
            'Under Construction: 50',
          ]),
          child: const PublicStatCard(
            title: '4,350',
            subtitle: 'Toilets Built in Villages',
            hint: 'Swachh Bharat Mission',
            color: Color(0xFFFDF1E8),
          ),
        ),
      ),
    ],
  );

  Widget _statRowDesktop(BuildContext context) => Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () =>
              _showDetailSheet(context, 'Tap Water Villages', ['Sangliwadi', 'Atpadi', 'Tasgaon']),
          child: const PublicStatCard(
            title: '8,400',
            subtitle: 'Rural Households with Tap Water',
            hint: 'Jal Jeevan Mission',
            color: Color(0xFFDDF6FF),
          ),
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: GestureDetector(
          onTap: () =>
              _showDetailSheet(context, 'Anganwadi Centers', ['Atpadi - 250', 'Miraj - 200']),
          child: const PublicStatCard(
            title: '1,250',
            subtitle: 'Active Anganwadi Centers',
            hint: '+2% from last year',
            color: Color(0xFFFFE7E7),
          ),
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: GestureDetector(
          onTap: () => _showDetailSheet(context, 'Enrollment', ['Primary - 95%', 'Secondary - 90%']),
          child: const PublicStatCard(
            title: '95%',
            subtitle: 'School Enrollment (6–14 yrs)',
            hint: 'Sarva Shiksha Mission',
            color: Color(0xFFE8F8EE),
          ),
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: GestureDetector(
          onTap: () =>
              _showDetailSheet(context, 'Pregnant Women Benefited', ['ICDS - 1200', 'Arogya - 2000']),
          child: const PublicStatCard(
            title: '3,200',
            subtitle: 'Pregnant Women Benefited',
            hint: 'ICDS Schemes',
            color: Color(0xFFF1EBFF),
          ),
        ),
      ),
    ],
  );

  Widget _statRowDesktop2(BuildContext context) => Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () =>
              _showDetailSheet(context, 'Nutrition Kits', ['Distributed - 12,000']),
          child: const PublicStatCard(
            title: '12,000',
            subtitle: 'Nutrition Kits Distributed',
            hint: 'Poshan Abhiyaan 2025',
            color: Color(0xFFFDF1E8),
          ),
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: GestureDetector(
          onTap: () =>
              _showDetailSheet(context, 'Village Toilets', ['Completed - 4350']),
          child: const PublicStatCard(
            title: '4,350',
            subtitle: 'Toilets Built in Villages',
            hint: 'Swachh Bharat Mission',
            color: Color(0xFFEFF8FA),
          ),
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: GestureDetector(
          onTap: () =>
              _showDetailSheet(context, 'SHG Groups', ['Total - 2800']),
          child: const PublicStatCard(
            title: '2,800',
            subtitle: 'Self-Help Groups Active',
            hint: 'Women Empowerment',
            color: Color(0xFFF7E9FB),
          ),
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: GestureDetector(
          onTap: () =>
              _showDetailSheet(context, 'Village Roads', ['Repaired - 1120 km']),
          child: const PublicStatCard(
            title: '1,120',
            subtitle: 'Village Roads Repaired (km)',
            hint: 'Gramin Vikas Dept.',
            color: Color(0xFFEAFDF0),
          ),
        ),
      ),
    ],
  );
}
