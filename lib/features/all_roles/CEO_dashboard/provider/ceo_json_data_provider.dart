// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../auth/provider/auth_provider.dart';
// import '../../../departments/providers/department_provider.dart';
// import '../models/json_data_model.dart';
//
// class CeoDashboardProvider extends ChangeNotifier {
//   List<ApiItem> _items = [];
//   bool _loading = false;
//
//   List<ApiItem> get items => _items;
//   bool get loading => _loading;
//
//   void clear() {
//     _items = [];
//     notifyListeners();
//   }
//
//   void setItems(List<ApiItem> newItems) {
//     _items = newItems;
//     notifyListeners();
//   }
//
//   Future<void> loadDashboardData({
//     required String department,
//     required String block,
//     required String month,
//     required String year,
//     required AuthProvider authProvider,
//     required DepartmentProvider departmentProvider,
//     required List<Map<String, dynamic>> blocks,
//   }) async {
//     _loading = true;
//     notifyListeners();
//
//     try {
//       final token = authProvider.token ?? "";
//       if (token.isEmpty) return;
//
//       final departmentId = departmentProvider.departments
//           .firstWhere((d) => d.name == department)
//           .id;
//
//       final blockId = blocks.firstWhere((b) => b["name"] == block)["id"];
//       final monthInt = int.tryParse(month) ?? 1;
//       final yearInt = int.tryParse(year) ?? DateTime.now().year;
//
//       final url = Uri.parse(
//           "https://rdprgovapi.atyoureye.com/api/files/GetJsonData?month=$monthInt&year=$yearInt&departmentId=$departmentId&bdoId=$blockId&uploadedByUserId=1&page=1&pageSize=1");
//
//       final response = await http.get(url, headers: {
//         "Authorization": "Bearer $token",
//         "Accept": "application/json",
//       });
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         if (data.isEmpty) {
//           clear();
//           return;
//         }
//
//         final rawJson = data.first["jsonData"];
//         final decoded = rawJson is String ? json.decode(rawJson) : (rawJson ?? {});
//         final List itemsData = decoded["Items"] ?? [];
//
//         final apiItems = itemsData
//             .where((e) {
//           final srNo = e["SrNo"]?.toString().trim();
//           final name = e["Item"]?.toString().trim() ?? "";
//           return name.isNotEmpty && srNo != "Total" && (srNo?.isNotEmpty ?? false);
//         })
//             .map((e) => ApiItem(
//           id: 0,
//           name: e["Item"].toString(),
//           department: department,
//           block: block,
//           month: monthInt,
//           year: yearInt,
//           target: double.tryParse(e["Purpose"].toString()) ?? 0,
//           achievement: double.tryParse(e["Achieved"].toString()) ?? 0,
//           financial: double.tryParse(e["Percentage"].toString()) ?? 0,
//         ))
//             .toList();
//
//         setItems(apiItems);
//       } else {
//         if (kDebugMode) {
//           print("Failed to load dashboard data: ${response.statusCode}");
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) print("Error fetching dashboard data: $e");
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }
// }
