// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:fl_chart/fl_chart.dart';
//
// class BlockBarChartScreen extends StatefulWidget {
//   const BlockBarChartScreen({super.key});
//
//   @override
//   State<BlockBarChartScreen> createState() => _BlockBarChartScreenState();
// }
//
// class _BlockBarChartScreenState extends State<BlockBarChartScreen> {
//   List<String> blocks = [];
//   List<double> purposes = [];
//   List<double> achieved = [];
//   bool isLoading = true;
//   String? error;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAndProcessData();
//   }
//
//   Future<void> fetchAndProcessData() async {
//     const apiUrl =
//         "https://rdprgovapi.atyoureye.com/api/files/GetJsonData?month=7&year=2025&departmentId=4&bdoId=1&uploadedByUserId=1&page=1&pageSize=1";
//     const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidW5pcXVlX25hbWUiOiJjZW9fYWRtaW4iLCJqdGkiOiI4OTg1NTZhOS0zM2Y2LTRmNjAtYmIyYi0yNjkwMmRmMjNjZjUiLCJyb2xlIjoiQ0VPIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQ0VPIiwicm9sZV9pZCI6IjEiLCJiZG9faWQiOiIiLCJkZXBhcnRtZW50X2lkIjoiIiwicGFyZW50X2Nlb19pZCI6IjEiLCJleHAiOjE3NTk3MzgxNzQsImlzcyI6IlJEUFJHb3ZBUEkiLCJhdWQiOiJSRFBSR292QVBJLk1vYmlsZSJ9.p7dORUBYOg9i_eUXzjbkPMBeOGAd2OFuYMQu-2YC6yk"; // <-- Replace with your actual token
//
//     try {
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           "accept": "*/*",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> apiList = json.decode(response.body);
//         if (apiList.isEmpty) {
//           setState(() {
//             error = "No data returned from API";
//             isLoading = false;
//           });
//           return;
//         }
//         final Map<String, dynamic> jsonData =
//         json.decode(apiList[0]['jsonData']);
//         final List<dynamic> items = jsonData['Items'] ?? [];
//
//         // Filter: Only rows with int SrNo and non-empty Item
//         final List<dynamic> dataRows = items.where((item) {
//           final srNo = item['SrNo'] ?? '';
//           final block = item['Item'] ?? '';
//           return int.tryParse(srNo.toString()) != null && block.toString().isNotEmpty;
//         }).toList();
//
//         setState(() {
//           blocks = dataRows.map((e) => e['Item'].toString()).toList();
//           purposes = dataRows
//               .map((e) => double.tryParse(e['Purpose'].toString()) ?? 0)
//               .toList();
//           achieved = dataRows
//               .map((e) => double.tryParse(e['Achieved'].toString()) ?? 0)
//               .toList();
//           isLoading = false;
//           error = null;
//         });
//       } else {
//         setState(() {
//           error = "API error: ${response.statusCode} ${response.body}";
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = "Exception: $e";
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget chartWidget;
//     if (isLoading) {
//       chartWidget = const Center(child: CircularProgressIndicator());
//     } else if (error != null) {
//       chartWidget = Center(child: Text(error!, style: const TextStyle(color: Colors.red)));
//     } else if (blocks.isEmpty) {
//       chartWidget = const Center(child: Text("No data to display"));
//     } else {
//       chartWidget = Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BarChart(
//           BarChartData(
//             maxY: [
//               ...purposes,
//               ...achieved,
//             ].fold<double>(0, (prev, el) => el > prev ? el : prev) + 20,
//             barGroups: List.generate(blocks.length, (i) {
//               return BarChartGroupData(
//                 x: i,
//                 barRods: [
//                   BarChartRodData(
//                     toY: purposes[i],
//                     color: Colors.blue,
//                     width: 10,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   BarChartRodData(
//                     toY: achieved[i],
//                     color: Colors.green,
//                     width: 10,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ],
//                 barsSpace: 4,
//               );
//             }),
//             titlesData: FlTitlesData(
//               leftTitles: AxisTitles(
//                 sideTitles: SideTitles(showTitles: true),
//               ),
//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget: (double value, TitleMeta meta) {
//                     if (value.toInt() < 0 || value.toInt() >= blocks.length) {
//                       return const SizedBox.shrink();
//                     }
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Text(
//                         blocks[value.toInt()],
//                         style: const TextStyle(fontSize: 10),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     );
//                   },
//                   reservedSize: 28,
//                   interval: 1,
//                 ),
//               ),
//               rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//               topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             ),
//             gridData: FlGridData(show: true),
//             borderData: FlBorderData(
//               show: true,
//               border: const Border(
//                 left: BorderSide(),
//                 bottom: BorderSide(),
//               ),
//             ),
//             groupsSpace: 26,
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Block Purpose vs Achieved Bar Chart')),
//       body: chartWidget,
//     );
//   }
// }
