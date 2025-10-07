import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../auth/provider/auth_provider.dart';
import '../../../departments/providers/department_provider.dart';
import '../models/json_data_model.dart';
import '../../../../core/utils/json_parser.dart';
import '../widgets/ceo_dashboard_content.dart';

/// =======================
/// CONTROLLER
/// =======================
class CeoDashboardController extends ChangeNotifier {
  final AuthProvider authProvider;
  final DepartmentProvider departmentProvider;

  CeoDashboardController({
    required this.authProvider,
    required this.departmentProvider,
  });

  // Filters
  String selectedDepartment = "";
  String selectedBlock = "All Blocks";
  String selectedMonth = "";
  String selectedYear = "";

  List<Map<String, dynamic>> blocks = [];
  List<ApiItem> items = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Metrics
  double totalTarget = 0;
  double totalAchieved = 0;
  double avgPercent = 0;

  // Chart data
  List<FlSpot> lineSpots = [];
  List<BarChartGroupData> barGroups = [];

  Timer? _debounce;

  final List<String> apiMonths =
  List.generate(12, (i) => "${i + 1}");
  final List<String> apiYears =
  List.generate(6, (i) => "${2020 + i}");

  /// Initialize dashboard
  Future<void> init() async {
    selectedMonth = apiMonths.last;
    selectedYear = apiYears.last;
    await _loadDepartments();
  }

  /// -------------------- LOAD DEPARTMENTS --------------------
  Future<void> _loadDepartments() async {
    if (authProvider.token == null || authProvider.token!.isEmpty) {
      final refreshed = await authProvider.refreshTokenIfNeeded();
      if (!refreshed) return;
    }

    await departmentProvider.loadDepartments();

    if (departmentProvider.departments.isNotEmpty) {
      selectedDepartment = departmentProvider.departments.first.name;
      await loadBlocks();
      await loadDashboardData();
    }
  }

  /// -------------------- LOAD BLOCKS --------------------
  Future<void> loadBlocks() async {
    _setLoading(true);
    final token = authProvider.token ?? "";
    const url = "https://rdprgovapi.atyoureye.com/api/Org/bdos";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        final data = await compute(parseBlocks, response.body);
        blocks = [{"id": 0, "name": "All Blocks"}, ...data];
        selectedBlock = "All Blocks";
      }
    } catch (e) {
      debugPrint("Error loading blocks: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// -------------------- LOAD DASHBOARD DATA --------------------
  Future<void> loadDashboardData() async {
    final token = authProvider.token ?? "";
    if (token.isEmpty) return;

    _setLoading(true);

    try {
      final departmentId = departmentProvider.departments
          .firstWhere((d) => d.name == selectedDepartment)
          .id;
      final blockId = blocks.firstWhere((b) => b["name"] == selectedBlock)["id"];
      final month = int.tryParse(selectedMonth) ?? 1;
      final year = int.tryParse(selectedYear) ?? DateTime.now().year;

      final url = Uri.parse(
          "https://rdprgovapi.atyoureye.com/api/files/GetJsonData?month=$month&year=$year&departmentId=$departmentId&bdoId=$blockId&uploadedByUserId=1&page=1&pageSize=1");

      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      if (response.statusCode != 200) return;

      final List<dynamic> data = json.decode(response.body);
      if (data.isEmpty) {
        items = [];
        await _computeMetrics();
        _setLoading(false);
        return;
      }

      final rawJson = data.first["jsonData"];
      final decoded = rawJson is String
          ? await compute(parseJsonInBackground, rawJson)
          : (rawJson ?? {});
      final List apiItems = decoded["Items"] ?? [];

      items = await compute(parseApiItemsInBackground, {
        "items": apiItems,
        "department": selectedDepartment,
        "block": selectedBlock,
        "month": month,
        "year": year,
      });

      await _computeMetrics();
    } catch (e, st) {
      debugPrint("Error fetching dashboard data: $e\n$st");
    } finally {
      _setLoading(false);
    }
  }

  /// -------------------- COMPUTE METRICS --------------------
  Future<void> _computeMetrics() async {
    final result = await compute(_computeMetricsInBackground, {
      "items": items,
      "selectedBlock": selectedBlock,
    });

    totalTarget = result["totalTarget"] ?? 0.0;
    totalAchieved = result["totalAchieved"] ?? 0.0;
    avgPercent = result["avgPercent"] ?? 0.0;

    // Chart data
    barGroups = List.generate(items.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: items[i].achievement,
            width: 12,
            borderRadius: BorderRadius.circular(4),
          )
        ],
      );
    });

    lineSpots = List.generate(
      items.length,
          (i) => FlSpot(i.toDouble(), items[i].financial),
    );

    notifyListeners();
  }

  /// -------------------- HELPERS --------------------
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<ApiItem> get filteredItems {
    if (selectedBlock == "All Blocks") return items;
    return items.where((it) => it.block == selectedBlock).toList();
  }

  /// =======================
  /// BACKGROUND HELPERS
  /// =======================
  List<Map<String, dynamic>> parseBlocks(String responseBody) {
    final List<dynamic> data = json.decode(responseBody);
    return data.map((e) => {"id": e["id"], "name": e["name"]}).toList();
  }

  List<ApiItem> parseApiItemsInBackground(Map<String, dynamic> args) {
    final List apiItems = args["items"];
    final String department = args["department"];
    final String block = args["block"];
    final int month = args["month"];
    final int year = args["year"];

    return apiItems.where((e) {
      final srNo = e["SrNo"]?.toString().trim();
      final name = e["Item"]?.toString().trim() ?? "";
      return name.isNotEmpty && srNo != "Total" && (srNo?.isNotEmpty ?? false);
    }).map((e) {
      return ApiItem(
        id: 0,
        name: e["Item"].toString(),
        department: department,
        block: block,
        month: month,
        year: year,
        target: double.tryParse(e["Purpose"].toString()) ?? 0.0,
        achievement: double.tryParse(e["Achieved"].toString()) ?? 0.0,
        financial: double.tryParse(e["Percentage"].toString()) ?? 0.0,
      );
    }).toList();
  }

  Map<String, double> _computeMetricsInBackground(Map<String, dynamic> args) {
    final List<ApiItem> items = args["items"];
    final String selectedBlock = args["selectedBlock"];

    final filtered = selectedBlock == "All Blocks"
        ? items
        : items.where((it) => it.block == selectedBlock).toList();

    final totalTarget = filtered.fold<double>(0.0, (sum, it) => sum + it.target);
    final totalAchieved =
    filtered.fold<double>(0.0, (sum, it) => sum + it.achievement);
    final avgPercent = filtered.isEmpty
        ? 0.0
        : filtered.fold<double>(
        0.0,
            (sum, it) => sum + (it.target == 0
            ? 0.0
            : (it.achievement / it.target * 100))) /
        filtered.length;

    return {
      "totalTarget": totalTarget,
      "totalAchieved": totalAchieved,
      "avgPercent": avgPercent,
    };
  }


  void _debouncedLoad(VoidCallback fn) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), fn);
  }

  Future<void> updateDepartment(String dept) async {
    selectedDepartment = dept;
    _debouncedLoad(loadDashboardData);
  }

  Future<void> updateBlock(String block) async {
    selectedBlock = block;
    _debouncedLoad(() async => await _computeMetrics());
  }

  Future<void> updateMonth(String month) async {
    selectedMonth = month;
    _debouncedLoad(loadDashboardData);
  }

  Future<void> updateYear(String year) async {
    selectedYear = year;
    _debouncedLoad(loadDashboardData);
  }
}