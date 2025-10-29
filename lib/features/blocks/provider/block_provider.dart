// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:provider/provider.dart';
//
// import '../../all_roles/CEO_dashboard/models/bdo_model.dart';
// import '../../auth/provider/auth_provider.dart';
//
// class BdoProvider extends ChangeNotifier {
//   final Dio dio;
//   BdoProvider({required this.dio});
//
//   List<String> _blocks = [];
//   List<String> get blocks => _blocks;
//
//   List<BdoModel> _bdoList = [];
//   bool _isLoading = false;
//   String? _error;
//
//   List<BdoModel> get bdoList => _bdoList;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   bool _loading = false;
//   bool get loading => _loading;
//
//   Future<void> loadBdos({required int parentCeoId}) async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       _bdoList = await repository.getBdos(parentCeoId);
//       _error = null;
//     } catch (e) {
//       _error = e.toString();
//       _bdoList = [];
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//
// // Future<void> fetchBlocks() async {
//   //   setState(() => isLoadingBlocks = true);
//   //
//   //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
//   //   final token = authProvider.token;
//   //
//   //   if (token == null || token.isEmpty) {
//   //     debugPrint("⚠️ Token is null or empty — cannot fetch blocks");
//   //     setState(() => isLoadingBlocks = false);
//   //     return;
//   //   }
//   //
//   //   const url = "https://rdprgovapi.atyoureye.com/api/Org/bdos";
//   //
//   //   try {
//   //     final response = await http.get(
//   //       Uri.parse(url),
//   //       headers: {
//   //         "Authorization": "Bearer $token",
//   //         "Accept": "application/json",
//   //       },
//   //     );
//   //
//   //     if (response.statusCode == 200) {
//   //       final List<dynamic> jsonList = json.decode(response.body);
//   //
//   //       setState(() {
//   //         blocks = jsonList
//   //             .map((e) => {
//   //           "id": e["id"],
//   //           "name": e["name"],
//   //         })
//   //             .toList();
//   //
//   //         // ✅ Set first block as selected by default
//   //         if (blocks.isNotEmpty) {
//   //           selectedBlock = blocks.first["name"];
//   //         }
//   //       });
//   //
//   //       debugPrint("✅ Blocks fetched successfully (${blocks.length})");
//   //     } else {
//   //       debugPrint("❌ Failed to fetch blocks: ${response.statusCode}");
//   //     }
//   //   } catch (e) {
//   //     debugPrint("❌ Error fetching blocks: $e");
//   //   } finally {
//   //     setState(() => isLoadingBlocks = false);
//   //   }
//   // }
// }
