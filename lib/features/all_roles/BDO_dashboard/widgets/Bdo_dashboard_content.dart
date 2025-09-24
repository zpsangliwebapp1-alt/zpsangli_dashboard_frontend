// import 'package:flutter/material.dart';
// import 'package:zp_sangali_dashboard_flutter/core/widgets/place_holder_chart.dart';
// import 'package:zp_sangali_dashboard_flutter/core/widgets/revenue_chart.dart';
// import 'package:zp_sangali_dashboard_flutter/core/widgets/stat_card.dart';
// import 'package:zp_sangali_dashboard_flutter/core/widgets/top_products.dart';
// import 'package:zp_sangali_dashboard_flutter/core/widgets/visitor_insights_chart.dart';
//
// import '../../../../core/widgets/customer_satisfaction_chart.dart';
// import 'Bdo_customer_satisfaction_chart.dart';
// import 'ceo_info_card.dart';
//
// class CeoDashboardContent extends StatelessWidget {
//   final bool mobile;
//   const CeoDashboardContent({super.key, this.mobile = false});
//
//   /// Dummy Talukas and Departments
//   final List<String> talukas = const [
//     'Atpadi',
//     'Jath',
//     'Kadegaon',
//     'Kavathe Mahankal',
//     'Khanapur',
//     'Miraj',
//     'Palus',
//     'Shirala',
//     'Tasgaon',
//     'Walwa'
//   ];
//
//   final List<String> departments = const [
//     'ICDS',
//     'Women & Child Welfare',
//     'Rural Water Supply',
//     'PWD',
//     'Education (Primary)',
//     'Finance',
//     'Agriculture',
//     'Gram Panchayat',
//     'Education (Secondary)',
//     'Animal Husbandry',
//     'General Administration',
//     'Minor Irrigation',
//     'Social Welfare',
//   ];
//
//   /// Generates dummy KPI for BDOs
//   int _generateKpi(String taluka, String dept, int bdoIndex) {
//     return ((taluka.hashCode + dept.hashCode + bdoIndex) % 20) + 5; // random 5-24
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         children: [
//           // -------------------------------
//           // Row 1: Today's KPI Overview + Visitor Insights
//           // -------------------------------
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: InfoCard(
//                   title: "Today's KPI Overview",
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: const [
//                           Expanded(
//                               child: StatCard(
//                                   title: '45',
//                                   subtitle: 'Active Projects',
//                                   hint: '+3 from yesterday',
//                                   color: Color(0xFFFFF3DB))),
//                           SizedBox(width: 12),
//                           Expanded(
//                               child: StatCard(
//                                   title: '12',
//                                   subtitle: 'Pending Approvals',
//                                   hint: '+2 from yesterday',
//                                   color: Color(0xFFFFE7E7))),
//                           SizedBox(width: 12),
//                           Expanded(
//                               child: StatCard(
//                                   title: '320',
//                                   subtitle: 'Beneficiary Visits',
//                                   hint: '+5% from last week',
//                                   color: Color(0xFFEAFDF0))),
//                           SizedBox(width: 12),
//                           Expanded(
//                               child: StatCard(
//                                   title: '8',
//                                   subtitle: 'New Panchayats Added',
//                                   hint: '+1 from yesterday',
//                                   color: Color(0xFFF1EBFF))),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       const PlaceholderChart(
//                           height: 150,
//                           label: 'Project Completion Trend (BDO Reports)'),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 flex: 1,
//                 child: InfoCard(
//                   title: 'Visitor Insights',
//                   child: const VisitorInsightsChart(),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           // -------------------------------
//           // Row 2: Revenue / Satisfaction / Target
//           // -------------------------------
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: InfoCard(
//                   title: 'Funds Allocation & Utilization',
//                   child: Column(
//                     children: [
//                       const RevenueChart(),
//                       const SizedBox(height: 12),
//                       // Revenue by Taluka
//                       ...talukas.map(
//                             (taluka) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('$taluka Revenue:'),
//                               Text('₹${(100 + taluka.hashCode % 50)}L'),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: InfoCard(
//                   title: 'Citizen Satisfaction',
//                   child: Column(
//                     children: [
//                       const CustomerSatisfactionChart(),
//                       const SizedBox(height: 12),
//                       ...talukas.map(
//                             (taluka) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 2),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('$taluka Avg Satisfaction:'),
//                               Text('${80 + taluka.hashCode % 15}%'),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: InfoCard(
//                   title: 'Target vs Actual Projects',
//                   child: Column(
//                     children: [
//                       const PlaceholderChart(
//                         height: 180,
//                         label: 'Planned vs Completed Projects',
//                       ),
//                       const SizedBox(height: 12),
//                       ...talukas.map(
//                             (taluka) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 2),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('$taluka Projects Completed:'),
//                               Text(
//                                   '${30 + taluka.hashCode % 20}/${35 + taluka.hashCode % 25}'),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           // -------------------------------
//           // Row 3: Top Panchayats / Region / Service Level
//           // -------------------------------
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: InfoCard(
//                   title: 'Top Performing Panchayats',
//                   child: Column(
//                     children: const [
//                       SizedBox(height: 8),
//                       TopProductsList(),
//                       SizedBox(height: 8),
//                       StatCard(
//                         title: 'Avg. 92%',
//                         subtitle: 'Project Completion Rate',
//                         hint: 'Across top 5 Panchayats',
//                         color: Color(0xFFEAFDF0),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: InfoCard(
//                   title: 'Projects by Region',
//                   child: Column(
//                     children: const [
//                       PlaceholderChart(
//                         height: 180,
//                         label: 'Region-wise Project Count',
//                       ),
//                       SizedBox(height: 8),
//                       StatCard(
//                         title: 'North: 15 | South: 12 | East: 10 | West: 8',
//                         subtitle: 'Projects Distribution',
//                         hint: 'By Gram Vikas Adhikari Reports',
//                         color: Color(0xFFF1EBFF),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: InfoCard(
//                   title: 'Volume vs Service Level',
//                   child: Column(
//                     children: [
//                       const PlaceholderChart(
//                         height: 180,
//                         label: 'Service Level vs Project Volume',
//                       ),
//                       const SizedBox(height: 8),
//                       ...talukas.map(
//                             (taluka) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 2),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('$taluka Service Level:'),
//                               Text('${90 + taluka.hashCode % 10}%'),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 36),
//
//           // -------------------------------
//           // Row 4: Block-wise detailed data
//           // -------------------------------
//           InfoCard(
//             title: 'Block-wise Detailed Data',
//             child: Column(
//               children: talukas.map((taluka) {
//                 return ExpansionTile(
//                   title: Text('$taluka Taluka'),
//                   children: departments.map((dept) {
//                     return ExpansionTile(
//                       title: Text(dept),
//                       children: List.generate(10, (bdoIndex) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 2, horizontal: 16),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('BDO ${bdoIndex + 1}:'),
//                               Text(
//                                   '${_generateKpi(taluka, dept, bdoIndex)} Projects'),
//                             ],
//                           ),
//                         );
//                       }),
//                     );
//                   }).toList(),
//                 );
//               }).toList(),
//             ),
//           ),
//           const SizedBox(height: 36),
//         ],
//       ),
//     );
//   }
// }
