// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/presentation/block_barchart_screen.dart';
//
// import '../presentation/department_overview_card.dart';
//
// /// -------------------- MAIN DASHBOARD --------------------
// class DepartmentDashboard extends StatelessWidget {
//   final String block;
//   final String department;
//   final Map<String, Map<String, double>> monthlyTotals;
//   final DateTime lastUpdated;
//   final Map<String, List<Map<String, dynamic>>>? departmentData;
//
//   const DepartmentDashboard({
//     super.key,
//     required this.block,
//     required this.department,
//     required this.monthlyTotals,
//     required this.lastUpdated,
//     this.departmentData,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff9f9f9),
//       appBar: AppBar(
//         title: Text(
//           "Dashboard - $department",
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//         elevation: 1,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             DepartmentOverviewCard(
//               block: block,
//               department: department,
//               monthlyTotals: monthlyTotals,
//               lastUpdated: lastUpdated,
//               departmentData: departmentData,
//               onRefresh: () => debugPrint("🔄 Data refreshed"), selectedMonth: "", selectedYear: "",
//             ),
//             const SizedBox(height: 24),
//             /// Analytics Section
//             const Text("Analytics Maturity",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 _analyticsCard("Retrospective", "Historical performance", 0.6,
//                     Colors.orange),
//                 const SizedBox(width: 12),
//                 _analyticsCard(
//                     "Inferential", "Correlations & insights", 0.8, Colors.blue),
//                 const SizedBox(width: 12),
//                 _analyticsCard("Predictive", "Forecasting trends", 0.5,
//                     Colors.green),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// 🔹 Analytics Card
//   static Widget _analyticsCard(
//       String title, String desc, double marks, Color color) {
//     return Expanded(
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Icon(Icons.analytics, size: 28, color: color),
//               const SizedBox(height: 10),
//               Text(title,
//                   style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: color)),
//               const SizedBox(height: 6),
//               Text(desc,
//                   style: const TextStyle(fontSize: 12, color: Colors.black87)),
//               const SizedBox(height: 12),
//               LinearProgressIndicator(
//                 value: marks,
//                 backgroundColor: Colors.grey[200],
//                 color: color,
//                 minHeight: 6,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               const SizedBox(height: 4),
//               Text("Score: ${(marks * 100).toInt()}%",
//                   style: const TextStyle(
//                       fontSize: 12, fontWeight: FontWeight.w600)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
