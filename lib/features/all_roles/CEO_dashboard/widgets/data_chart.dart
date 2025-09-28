// import 'package:flutter/material.dart';
//
// class DataChart extends StatelessWidget {
//   final String department;
//   final String block; // block name or "TOTAL"
//   final Map<String, List<Map<String, dynamic>>> departmentData;
//   final double height;
//
//   const DataChart({
//     super.key,
//     required this.department,
//     required this.block,
//     required this.departmentData,
//     this.height = 150,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final deptItems = departmentData[department] ?? [];
//     final blockData = deptItems.firstWhere((d) => d['block'] == block, orElse: () => {});
//     if (blockData.isEmpty) {
//       return _buildBox(const Text("No data available"));
//     }
//
//
//     // Example: show key metrics inside the chart box
//     final entries = blockData.entries.where((e) => e.key != "block").toList();
//
//     return _buildBox(
//       Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("$department - $block", style: const TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           ...entries.map((e) => Text("${e.key}: ${e.value}")),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBox(Widget child) {
//     return Container(
//       height: height,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade100),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
//       ),
//       child: Center(child: child),
//     );
//   }
// }
