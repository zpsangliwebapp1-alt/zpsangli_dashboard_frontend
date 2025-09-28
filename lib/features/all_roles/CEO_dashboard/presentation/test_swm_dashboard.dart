// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../models/SwmRecordModel.dart';
// import '../repository/swm_repository.dart';
//
//
// class TestSwmDashboard extends StatefulWidget {
//   const TestSwmDashboard({super.key});
//
//   @override
//   State<TestSwmDashboard> createState() => _TestSwmDashboardState();
// }
//
// class _TestSwmDashboardState extends State<TestSwmDashboard> {
//   List<SwmRecord> data = [];
//   bool loading = true;
//
//   String selectedMonth = "OCT 2024";
//   final List<String> months = ["OCT 2024", "NOV 2024", "JAN 2025"];
//
//   @override
//   void initState() {
//     super.initState();
//     _load(selectedMonth);
//   }
//
//   Future<void> _load(String month) async {
//     setState(() => loading = true);
//     final result = await SwmRepository.loadData(month);
//     setState(() {
//       data = result;
//       loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("SWM Test Dashboard")),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           // 🔹 Dropdown to select month
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: DropdownButtonFormField<String>(
//               value: selectedMonth,
//               items: months
//                   .map((m) =>
//                   DropdownMenuItem(value: m, child: Text(m)))
//                   .toList(),
//               onChanged: (val) {
//                 if (val != null) {
//                   setState(() => selectedMonth = val);
//                   _load(val);
//                 }
//               },
//               decoration: const InputDecoration(
//                 labelText: "Select Month",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: BarChart(
//                 BarChartData(
//                   gridData: FlGridData(show: true),
//                   borderData: FlBorderData(show: false),
//                   titlesData: FlTitlesData(
//                     leftTitles: AxisTitles(
//                       sideTitles:
//                       SideTitles(showTitles: true, interval: 500),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (val, meta) {
//                           if (val.toInt() < data.length) {
//                             return Transform.rotate(
//                               angle: -0.7,
//                               child: Text(
//                                 data[val.toInt()].block,
//                                 style: const TextStyle(fontSize: 10),
//                               ),
//                             );
//                           }
//                           return const SizedBox.shrink();
//                         },
//                       ),
//                     ),
//                   ),
//                   barGroups: [
//                     for (int i = 0; i < data.length; i++)
//                       BarChartGroupData(
//                         x: i,
//                         barRods: [
//                           BarChartRodData(
//                             toY: data[i].achievement.toDouble(),
//                             color: Colors.teal,
//                             width: 14,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
