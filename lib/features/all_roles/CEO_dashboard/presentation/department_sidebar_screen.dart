// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:excel/excel.dart';
// import 'package:flutter/services.dart' show rootBundle, ByteData;
// import 'package:provider/provider.dart';
//
// import '../../../auth/provider/auth_provider.dart';
// import '../../../blocks/provider/block_provider.dart';
// import '../../../departments/providers/department_provider.dart';
// import '../widgets/ceo_dashboard_content.dart';
//
// class DepartmentSheetsSidebarScreen extends StatefulWidget {
//   const DepartmentSheetsSidebarScreen({super.key});
//
//   @override
//   State<DepartmentSheetsSidebarScreen> createState() =>
//       _DepartmentSheetsSidebarScreenState();
// }
//
// class _DepartmentSheetsSidebarScreenState
//     extends State<DepartmentSheetsSidebarScreen> {
//   List<List<dynamic>> _tableData = [];
//   String selectedTime = "";
//
//   bool isLoadingBlocks = false;
//   String selectedBlock = BlockConstants.blocks.first;
//   List<Map<String, dynamic>> blocks = [];
//
//   String selectedDepartment = DepartmentConstants.departments.first;
//
//   List<String> get availableMonths {
//     final deptData = departmentData[selectedDepartment] ?? [];
//     return deptData.map((e) => e["month"] as String).toSet().toList();
//   }
//   @override
//   void initState() {
//     super.initState();
//     _loadExcel();
//
//     final bdoProvider = Provider.of<BdoProvider>(context, listen: false);
//
//     // ✅ Load departments dynamically using token from AuthProvider
//     Future.microtask(() {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final deptProvider = Provider.of<DepartmentProvider>(context, listen: false);
//
//       final token = authProvider.token;
//       if (token != null && token.isNotEmpty) {
//         deptProvider.loadDepartments(context);
//       }
//     });
//     fetchBlocks().then((_) {
//       setState(() {
//         selectedBlock = (bdoProvider.blocks.isNotEmpty ? bdoProvider.blocks.first : null)!;
//       });
//     });
//     fetchBlocks(); // 🔥 call API on init
//
//   }
//
//   final Map<String, List<Map<String, dynamic>>> departmentData = {
//     "कृषी विभाग": [
//       {
//         "month": "Oct-24",
//         "block": "TOTAL",
//         "items": [
//           {"name": "नवीन विहीर", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "जुनी विहीर दुरुस्ती", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "शेततळे प्लास्टिक अस्तरीकरण", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "इनवेल बोरिंग", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "वीजजोडणी आकार", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "ठिबक सिंचन संच", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "तुषार सिंचन संच", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "पंप संच", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "सोलार पंप", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "पाईप", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "परसबाग", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "यंत्रसामुग्री", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "अभिकरण शूल्क", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "आकस्मिक खर्च", "target": 0, "achievement": 0, "financial": 0}
//         ],
//         "total": {"target": 0, "achievement": 0, "financial": 0}
//       },
//       {
//         "month": "Nov-24",
//         "block": "TOTAL",
//         "items": [
//           {"name": "नवीन विहीर", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "जुनी विहीर दुरुस्ती", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "शेततळे प्लास्टिक अस्तरीकरण", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "इनवेल बोरिंग", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "वीजजोडणी आकार", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "ठिबक सिंचन संच", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "तुषार सिंचन संच", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "पंप संच", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "सोलार पंप", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "पाईप", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "परसबाग", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "यंत्रसामुग्री", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "अभिकरण शूल्क", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "आकस्मिक खर्च", "target": 0, "achievement": 0, "financial": 0}
//         ],
//         "total": {"target": 0, "achievement": 0, "financial": 0}
//       },
//
//
//     ],
//     "ग्रामीण पाणी पुरवठा विभाग": [
//       {
//         "month": "Oct-24",
//         "block": "Atpadi",
//         "items": [
//           {"name": "No. of schemes", "target": 54, "achievement": 0, "financial": 0},
//           {"name": "Estimated Cost (Cr.)", "target": 50.00, "achievement": 0, "financial": 0},
//           {"name": "Expenditure (Cr.)", "target": 31.40, "achievement": 0, "financial": 0},
//           {"name": "Progress (0-25%)", "target": 30, "achievement": 0, "financial": 0},
//           {"name": "Progress (25-50%)", "target": 0, "achievement": 0, "financial": 0},
//           {"name": "Progress (50-75%)", "target": 10, "achievement": 0, "financial": 0},
//           {"name": "Progress (75-99%)", "target": 20, "achievement": 0, "financial": 0},
//           {"name": "Physically Completed 100%", "target": 20, "achievement": 0, "financial": 0},
//           {"name": "Completed (Phy & Fin)", "target": 4, "achievement": 0, "financial": 0},
//           {"name": "Total Completed", "target": 24, "achievement": 0, "financial": 0},
//           {"name": "Handed Over Schemes", "target": 16, "achievement": 0, "financial": 0}
//         ],
//         "total": {"target": 54, "achievement": 24, "financial": 31.40}
//       },
//
//     ],
//   };
//
//
//
//   Future<void> _loadExcel() async {
//     try {
//       final ByteData data =
//       await rootBundle.load("assets/data/agree_data.xlsx");
//       final List<int> bytes = data.buffer.asUint8List();
//       final excel = Excel.decodeBytes(bytes);
//
//       List<List<dynamic>> rows = [];
//       for (var table in excel.tables.keys) {
//         for (var row in excel.tables[table]!.rows) {
//           rows.add(row.map((cell) => cell?.value ?? "").toList());
//         }
//       }
//
//       setState(() {
//         _tableData = rows;
//       });
//     } catch (e) {
//       print("❌ Error loading Excel: $e");
//     }
//   }
//
//   Future<void> fetchBlocks() async {
//     setState(() => isLoadingBlocks = true);
//
//     const url = "https://rdprgovapi.atyoureye.com/api/Org/bdos";
//     const token =
//         "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidW5pcXVlX25hbWUiOiJjZW9fYWRtaW4iLCJqdGkiOiJhMTQyYTU0OC04YTEyLTQ1ZDUtOWE2ZS01NjhlYTIxZjA4NzEiLCJyb2xlIjoiQ0VPIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQ0VPIiwicm9sZV9pZCI6IjEiLCJiZG9faWQiOiIiLCJkZXBhcnRtZW50X2lkIjoiIiwicGFyZW50X2Nlb19pZCI6IjEiLCJleHAiOjE3NTkyMTU3NTcsImlzcyI6IlJEUFJHb3ZBUEkiLCJhdWQiOiJSRFBSR292QVBJLk1vYmlsZSJ9.MMkTIZLODRoaqm3ExsUGgq_Z40DiBqSpU7UROKmn-yk";
//
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {"Authorization": "Bearer $token"},
//       );
//
//       if (response.statusCode == 200) {
//         final List data = json.decode(response.body);
//         setState(() {
//           blocks = data.map((e) => {"id": e["id"], "name": e["name"]}).toList();
//           if (blocks.isNotEmpty) {
//             selectedBlock = blocks.first["name"]; // default selection
//           }
//         });
//       } else {
//         throw Exception("Failed to load blocks");
//       }
//     } catch (e) {
//       debugPrint("Error fetching blocks: $e");
//     } finally {
//       setState(() => isLoadingBlocks = false);
//     }
//   }
//
//   InputDecoration _dropdownDecoration(String label, BuildContext context) {
//     return InputDecoration(
//       labelText: label,
//       filled: true,
//       fillColor: Colors.grey.shade50,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
//       ),
//     );
//   }
// // Dynamic header text
//   String get tableHeader {
//     String block = selectedBlock ?? "All Blocks";
//     String department = selectedDepartment ?? "All Departments";
//     return "$department - $block Data";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_tableData.isEmpty) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     final headers = _tableData.first;
//     final rows = _tableData.skip(1).toList();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Excel Data Table",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.indigo.shade700,
//         elevation: 2,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Dropdown Filters
//             Row(
//               children: [
//                 // Block Dropdown
//                 Expanded(
//                   child: isLoadingBlocks
//                       ? const Center(child: CircularProgressIndicator())
//                       : DropdownButtonFormField<String>(
//                     value: selectedBlock,
//                     decoration: _dropdownDecoration("Select Block", context),
//                     items: blocks
//                         .map((block) => DropdownMenuItem<String>(
//                       value: block["name"],
//                       child: Text(block["name"]),
//                     ))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedBlock = value!;
//                       });
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(width: 16),
//
//                 // Department Dropdown
//                 Expanded(
//                   child: Consumer<DepartmentProvider>(
//                     builder: (context, deptProvider, _) {
//                       if (deptProvider.loading) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       if (deptProvider.error != null) {
//                         return Text(
//                           "Error: ${deptProvider.error}",
//                           style: const TextStyle(color: Colors.red),
//                         );
//                       }
//
//                       final uniqueDepartments = deptProvider.departments
//                           .map((e) => e.name.trim())
//                           .toSet()
//                           .toList();
//
//                       return DropdownButtonFormField<String>(
//                         value: uniqueDepartments.contains(selectedDepartment)
//                             ? selectedDepartment
//                             : null,
//                         decoration: _dropdownDecoration("Select Department", context),
//                         items: uniqueDepartments
//                             .map((deptName) => DropdownMenuItem(
//                           value: deptName,
//                           child: Text(deptName),
//                         ))
//                             .toList(),
//                         onChanged: (val) {
//                           setState(() {
//                             selectedDepartment = val ?? selectedDepartment;
//                           });
//                         },
//                       );
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(width: 16),
//
//                 // Month Dropdown
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     value: selectedTime.isNotEmpty ? selectedTime : null,
//                     decoration: _dropdownDecoration("Select Month", context),
//                     items: availableMonths
//                         .map((m) => DropdownMenuItem(
//                       value: m,
//                       child: Text(
//                         m,
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ))
//                         .toList(),
//                     onChanged: (val) {
//                       setState(() {
//                         selectedTime = val ?? selectedTime;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 24),
//
//             // Data Table
//             Expanded(
//               child: SingleChildScrollView(
//                 child: PaginatedDataTable(
//                   header: Text(
//                     tableHeader,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   rowsPerPage: 10,
//                   columnSpacing: 20,
//                   horizontalMargin: 10,
//                   showCheckboxColumn: false,
//                   columns: headers
//                       .map(
//                         (h) => DataColumn(
//                       label: Text(
//                         h.toString(),
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                           color: Colors.indigo,
//                         ),
//                       ),
//                     ),
//                   )
//                       .toList(),
//                   source: _ExcelDataSource(rows),
//                   headingRowHeight: 56,
//                   dataRowHeight: 48,
//                   dividerThickness: 1,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
//
// class _ExcelDataSource extends DataTableSource {
//   final List<List<dynamic>> rows;
//   _ExcelDataSource(this.rows);
//
//   @override
//   DataRow? getRow(int index) {
//     if (index >= rows.length) return null;
//     final row = rows[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: row
//           .map(
//             (cell) => DataCell(
//           ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 200),
//             child: Text(
//               cell.toString(),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ),
//       )
//           .toList(),
//     );
//   }
//
//   @override
//   bool get isRowCountApproximate => false;
//   @override
//   int get rowCount => rows.length;
//   @override
//   int get selectedRowCount => 0;
// }
