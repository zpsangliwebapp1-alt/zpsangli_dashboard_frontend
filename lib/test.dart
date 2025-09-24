// import 'package:flutter/material.dart';
// import '../../../../core/widgets/top_products.dart';
// import 'ceo_info_card.dart';
// import 'ceo_customer_satisfaction_chart.dart';
// import 'package:zp_sangali_dashboard_flutter/core/widgets/stat_card.dart';
//
// class CeoDashboardContent extends StatelessWidget {
//   final bool mobile;
//   const CeoDashboardContent({super.key, this.mobile = false});
//
//   // Dummy Departments List
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
//     'A',
//     'B',
//     'C',
//     'D',
//   ];
//
//   // Blocks
//   final List<String> blocks = const [
//     'Atpadi',
//     'Jath',
//     'Kadegaon',
//     'Kavathe Mahankal',
//     'Khanapur',
//     'Miraj',
//     'Palus',
//     'Shirala',
//     'Tasgaon',
//     'Walwa',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         children: [
//           /// Row 1: KPI Overview
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
//                       Wrap(
//                         spacing: 12,
//                         runSpacing: 12,
//                         children: const [
//                           StatCard(
//                             title: '48',
//                             subtitle: 'Active Projects',
//                             hint: '+3 from yesterday',
//                             color: Color(0xFFFFF3DB),
//                           ),
//                           StatCard(
//                             title: '14',
//                             subtitle: 'Pending Approvals',
//                             hint: '+2 from yesterday',
//                             color: Color(0xFFFFE7E7),
//                           ),
//                           StatCard(
//                             title: '335',
//                             subtitle: 'Beneficiary Visits',
//                             hint: '+5% from last week',
//                             color: Color(0xFFEAFDF0),
//                           ),
//                           StatCard(
//                             title: '10',
//                             subtitle: 'New Panchayats Added',
//                             hint: '+2 from yesterday',
//                             color: Color(0xFFF1EBFF),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Project Completion Trend (BDO Reports)',
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                       const SizedBox(height: 8),
//                       // Simple trend example
//                       SizedBox(
//                         height: 120,
//                         child: ListView(
//                           scrollDirection: Axis.horizontal,
//                           children: const [
//                             _TrendBox(month: 'Jan', value: '5 Projects'),
//                             _TrendBox(month: 'Feb', value: '8 Projects'),
//                             _TrendBox(month: 'Mar', value: '12 Projects'),
//                             _TrendBox(month: 'Apr', value: '15 Projects'),
//                             _TrendBox(month: 'May', value: '10 Projects'),
//                             _TrendBox(month: 'Jun', value: '8 Projects'),
//                             _TrendBox(month: 'Jul', value: '12 Projects'),
//                             _TrendBox(month: 'Aug', value: '18 Projects'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 flex: 1,
//                 child: InfoCard(
//                   title: 'Citizen Visits & Interactions',
//                   child: Column(
//                     children: const [
//                       CeoCustomerSatisfactionChart(),
//                       SizedBox(height: 12),
//                       StatCard(
//                         title: '320',
//                         subtitle: 'Unique Visitors Today',
//                         hint: '+6% from yesterday',
//                         color: Color(0xFFE0F7FA),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           /// Row 2: Department-wise Block Overview
//           InfoCard(
//             title: 'Department-wise Block KPIs',
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Each department’s performance across blocks',
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 const SizedBox(height: 12),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: DataTable(
//                     columnSpacing: 12,
//                     columns: [
//                       const DataColumn(label: Text('Department')),
//                       ...blocks.map((b) => DataColumn(label: Text(b))).toList(),
//                     ],
//                     rows: departments.map((dept) {
//                       return DataRow(
//                         cells: [
//                           DataCell(Text(dept)),
//                           ...blocks.map((b) {
//                             // Dummy values for each block
//                             final randomValue = (5 + (dept.hashCode + b.hashCode) % 15);
//                             return DataCell(Text('$randomValue Projects'));
//                           }).toList(),
//                         ],
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//
//           /// Row 3: Top Panchayats
//           InfoCard(
//             title: 'Top Performing Panchayats',
//             child: Column(
//               children: const [
//                 TopProductsList(),
//                 SizedBox(height: 12),
//                 StatCard(
//                   title: 'Avg. 92%',
//                   subtitle: 'Project Completion Rate',
//                   hint: 'Across top 5 Panchayats',
//                   color: Color(0xFFEAFDF0),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//
//           /// Row 4: Regional Project Distribution
//           InfoCard(
//             title: 'Projects by Region',
//             child: Column(
//               children: const [
//                 Text('North: 15 | South: 12 | East: 10 | West: 8'),
//                 SizedBox(height: 8),
//                 StatCard(
//                   title: '45 Projects',
//                   subtitle: 'Total Active Projects',
//                   hint: 'By Gram Vikas Adhikari Reports',
//                   color: Color(0xFFF1EBFF),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//
//           /// Row 5: Service Level vs Volume
//           InfoCard(
//             title: 'Volume vs Service Level',
//             child: Column(
//               children: const [
//                 Text('Projects Completed: 42 | Service Level: 95%'),
//                 SizedBox(height: 8),
//                 StatCard(
//                   title: 'SL 95%',
//                   subtitle: 'Service Level Achieved',
//                   hint: 'Target: 90%',
//                   color: Color(0xFFFFE7E7),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 36),
//         ],
//       ),
//     );
//   }
// }
//
// /// Small Trend Box Widget
// class _TrendBox extends StatelessWidget {
//   final String month;
//   final String value;
//   const _TrendBox({required this.month, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       margin: const EdgeInsets.only(right: 8),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.blue.shade200),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(month, style: const TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           Text(value, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }
