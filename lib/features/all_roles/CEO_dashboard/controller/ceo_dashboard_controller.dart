import 'dart:async';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/provider/auth_provider.dart';
import '../../../departments/providers/department_provider.dart';
import '../models/json_data_model.dart';
import '../../../../core/utils/json_parser.dart';
import '../models/zp_work_progress_model.dart';
import '../provider/create_bdo_provider.dart';

class CeoDashboardController extends ChangeNotifier {
  final AuthProvider authProvider;
  final DepartmentProvider departmentProvider;
  // final CreateBdoProvider bdoProvider;


  CeoDashboardController({
    required this.authProvider,
    required this.departmentProvider,
    // required this.bdoProvider,

  });

  /// =======================
  /// STATE VARIABLES
  /// =======================
  String selectedDepartment = '';
  String selectedBlock = 'All Blocks';
  String selectedMonth = '';
  String selectedYear = '';

  Map<String, List<ApiItem>> departmentItems = {}; // Holds items for each department

  Future<void> loadDashboardDataForMultipleDepartments() async {
    if (selectedDepartments.isEmpty) return;
    departmentItems.clear();

    for (var dept in selectedDepartments) {
      selectedDepartment = dept; // temporary
      await loadDashboardData(); // re-use existing logic

      // Store a copy for this department
      departmentItems[dept] = List.from(items);
    }

    // Merge all items for metrics if needed
    items = departmentItems.values.expand((x) => x).toList();
    await _computeMetrics();
    notifyListeners();
  }

  int? selectedDepartmentId;


  Map<String, Map<String, double>> getMergedDepartmentData(String department) {
    final allEntries = departmentDataByName[department] ?? [];
    final merged = <String, Map<String, double>>{};

    for (var entry in allEntries) {
      final items = (entry["items"] as List?)?.cast<Map<String, dynamic>>() ?? [];
      for (var item in items) {
        final name = item["name"]?.toString() ?? "Unknown";
        final financial = (item["financial"] as num?)?.toDouble() ?? 0.0;
        final achievement = (item["achievement"] as num?)?.toDouble() ?? 0.0;
        final target = (item["target"] as num?)?.toDouble() ?? 0.0;

        if (!merged.containsKey(name)) {
          merged[name] = {
            "financial": 0.0,
            "achievement": 0.0,
            "target": 0.0,
          };
        }

        merged[name]!["financial"] = merged[name]!["financial"]! + financial;
        merged[name]!["achievement"] = merged[name]!["achievement"]! + achievement;
        merged[name]!["target"] = merged[name]!["target"]! + target;
      }
    }

    return merged;
  }



  String secondaryDepartment = '';
  Future<void> updateSecondaryDepartment(String dept) async {
    secondaryDepartment = dept;
    _debouncedLoad(loadDashboardData); // re-use same data loading logic
  }

  Map<String, Map<String, double>> calculateMonthlyTotals(String department) {
    final filteredItems = items.where((i) => i.department == department).toList();
    final totals = <String, Map<String, double>>{};
    for (var i in filteredItems) {
      totals[i.name] = {
        "target": i.target,
        "achievement": i.achievement,
        "financial": i.financial,
        "estimatedCost": 0, // optional
      };
    }
    return totals;
  }

  Map<String, List<Map<String, dynamic>>> get groupedDepartmentData {
    final Map<String, List<Map<String, dynamic>>> result = {};

    for (var item in items) {
      if (!result.containsKey(item.department)) {
        result[item.department] = [];
      }
      print(item.department);
      print(item.financial);



      result[item.department]!.add({
        'name': item.name,
        'target': item.target,
        'achievement': item.achievement,
        'financial': item.financial,
        'month': item.month,
        'year': item.year,
        'block': item.block,
      });
    }
    print("&&&&&&&&&&&&&&&&&");
    return result;
  }



  Future<void> fetchZpWorkData() async {
    try {
      final response = await http.get(Uri.parse("YOUR_API_URL"));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final zpModel = ZpWorkProgressModel.fromJson(jsonData);

        // ✅ Store cleanly here
        departmentDataByName['ZP Work Progress'] = zpModel;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading ZP Work Progress data: $e");
    }
  }




  Map<String, double> calculateSatisfaction(String department) {
    final filteredItems = items.where((i) => i.department == department).toList();
    final result = <String, double>{};
    for (var i in filteredItems) {
      result[i.name] = i.financial; // or some other metric
    }
    return result;
  }

  // List<Map<String, dynamic>> blocks = [
  // {'id': 0, 'name': 'All Blocks'},
  // {'id': 1, 'name': 'Miraj'},
  // {'id': 2, 'name': 'Kavathe Mahankal'},
  // {'id': 3, 'name': 'Tasgaon'},
  // {'id': 4, 'name': 'Jat'},
  // {'id': 5, 'name': 'Walwa'},
  // ];

  List<Map<String, dynamic>> blocks = [];
  List<ApiItem> items = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double totalTarget = 0.0;
  double totalAchieved = 0.0;
  double avgPercent = 0.0;

  List<FlSpot> lineSpots = [];
  List<BarChartGroupData> barGroups = [];

  Timer? _debounce;

  final List<String> apiMonths = List.generate(12, (i) => '${i + 1}');
  final List<String> apiYears = List.generate(6, (i) => '${2020 + i}');

  /// =======================
  /// INIT LOGIC
  /// =======================
  bool isInitialized = false;
  Future<void> init() async {
    if (isInitialized) return;
    isInitialized = true;

    await Future.wait([
      loadSavedFilters(), // ⬅️ load saved filters first
      _loadDepartments(),
      loadBlocks(),
    ]);

    // If nothing saved, set defaults (Dept 1, Block 1, Month Jan, latest Year)
    if (selectedDepartment.isEmpty && departmentProvider.departments.isNotEmpty) {
      selectedDepartment = departmentProvider.departments.first.name;
    }
    if (selectedBlock.isEmpty && blocks.isNotEmpty) {
      selectedBlock = blocks.first["name"].toString();
    }
    if (selectedMonth.isEmpty) {
      selectedMonth = "1"; // January
    }
    if (selectedYear.isEmpty) {
      selectedYear = DateTime.now().year.toString();
    }

    await loadDashboardData();
    notifyListeners();
  }


  // =======================
// 🔹 Save filters locally
// =======================
  Future<void> saveSelectedFilters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedDepartment', selectedDepartment);
    await prefs.setString('selectedBlock', selectedBlock);
    await prefs.setString('selectedMonth', selectedMonth);
    await prefs.setString('selectedYear', selectedYear);
    debugPrint("💾 Saved filters → Dept: $selectedDepartment, Block: $selectedBlock, Month: $selectedMonth, Year: $selectedYear");
  }

// =======================
// 🔹 Load saved filters
// =======================
  Future<void> loadSavedFilters() async {
    final prefs = await SharedPreferences.getInstance();
    selectedDepartment = prefs.getString('selectedDepartment') ?? '';
    selectedBlock = prefs.getString('selectedBlock') ?? 'All Blocks';
    selectedMonth = prefs.getString('selectedMonth') ?? '';
    selectedYear = prefs.getString('selectedYear') ?? '';
    debugPrint("📦 Loaded filters → Dept: $selectedDepartment, Block: $selectedBlock, Month: $selectedMonth, Year: $selectedYear");
  }







  // Future<void> init() async {
  //   if (isInitialized) return;
  //   isInitialized = true;
  //   await _loadDepartments();
  //   await loadBlocks();
  //   await loadDashboardData();
  //   notifyListeners();
  //
  // }

  Future<void> _loadDepartments() async {
    // 🔸 Refresh token if needed
    if (authProvider.token == null || authProvider.token!.isEmpty) {
      final refreshed = await authProvider.refreshTokenIfNeeded();
      if (!refreshed) return;
    }

    await departmentProvider.loadDepartments();

    if (departmentProvider.departments.isNotEmpty) {
      selectedDepartment = departmentProvider.departments.first.name;
      // await loadBlocks();
      // await loadDashboardData();
    }
  }

  /// =======================
  /// LOAD BLOCKS
  /// =======================
  ///
  bool _blocksLoaded = false;

  Future<void> loadBlocks() async {
    // ✅ Stop if blocks already loaded once
    if (_blocksLoaded && blocks.isNotEmpty) {
      debugPrint("🟢 Blocks already loaded — skipping API call");
      return;
    }
    _setLoading(true);

    try {
      // 🔹 Step 1: Ensure token is valid before calling API
      if (authProvider.token == null || authProvider.token!.isEmpty) {
        debugPrint("⚠️ No token found — attempting refresh...");
        final refreshed = await authProvider.refreshTokenIfNeeded();
        if (!refreshed) {
          debugPrint("❌ Token refresh failed — cannot fetch blocks");
          _setLoading(false);
          return;
        }
      }

      final token = authProvider.token ?? '';
      final parentCeoId = authProvider.userId ?? 2;

      debugPrint('🔑 TOKEN: $token');
      debugPrint('👤 USER ID: $parentCeoId');

      final url =
          'https://rdprgovapi.atyoureye.com/api/Org/bdos?parent_ceo_id=$parentCeoId';

      debugPrint('📡 Fetching blocks for CEO ID: $parentCeoId');

      // 🔹 Step 2: Make API call safely
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('📨 STATUS: ${response.statusCode}');
      debugPrint('📥 BODY: ${response.body}');

      // 🔹 Step 3: Handle 401 unauthorized (token expired)
      if (response.statusCode == 401) {
        debugPrint("⚠️ Token expired — refreshing...");
        final refreshed = await authProvider.refreshTokenIfNeeded();
        if (refreshed) {
          // 🔁 retry once
          return await loadBlocks();
        } else {
          debugPrint("❌ Token refresh failed on retry");
          _setLoading(false);
          return;
        }
      }

      // 🔹 Step 4: Handle success
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded is List ? decoded : decoded['data'] ?? [];

        if (data.isNotEmpty) {
          blocks = [
            {'id': 0, 'name': 'All Blocks'},
            ...data.map((e) => {
              'id': e['id'] ?? 0,
              'name': e['name']?.toString() ?? 'Unnamed Block',
            }),
          ];
          debugPrint('✅ Loaded ${blocks.length} blocks');
        } else {
          debugPrint('⚠️ No blocks found for CEO ID: $parentCeoId');
          blocks = [{'id': 0, 'name': 'All Blocks'}];
        }
      } else {
        debugPrint('❌ Failed to load blocks: ${response.body}');
        blocks = [{'id': 0, 'name': 'All Blocks'}];
      }
    } catch (e, st) {
      debugPrint('❌ Exception while loading blocks: $e\n$st');
      blocks = [{'id': 0, 'name': 'All Blocks'}];
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }



  static List<Map<String, dynamic>> _parseBlocks(String responseBody) {
    final List<dynamic> data = json.decode(responseBody);
    return data
        .map((e) => {'id': e['id'], 'name': e['name']?.toString() ?? ''})
        .toList();
  }


  /// =======================
  /// LOAD DASHBOARD DATA
  /// =======================
  Future<void> loadDashboardData() async {
    final token = authProvider.token ?? '';
    if (token.isEmpty) return;

    _setLoading(true);
    try {
      final departmentId = departmentProvider.departments
          .firstWhere((d) => d.name == selectedDepartment)
          .id;

      final blockId = blocks.firstWhere((b) => b['name'] == selectedBlock)['id'];
      final month = int.tryParse(selectedMonth) ?? DateTime.now().month;
      final year = int.tryParse(selectedYear) ?? DateTime.now().year;

      final url = Uri.parse(
        'https://rdprgovapi.atyoureye.com/api/files/GetJsonData'
            '?month=$month&year=$year'
            '&departmentId=$departmentId'
            '&bdoId=$blockId'
            '&uploadedByUserId=2'
            '&page=1&pageSize=1',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('📡 DASHBOARD API URL: $url');
      debugPrint('📨 STATUS: ${response.statusCode}');
      debugPrint('📥 RESPONSE:\n${response.body}');

      if (response.statusCode != 200) {
        items = [];
        await _computeMetrics();
        _setLoading(false);
        return;
      }

      final List<dynamic> data = json.decode(response.body);
      if (data.isEmpty) {
        items = [];
        await _computeMetrics();
        _setLoading(false);
        return;
      }

      final rawJson = data.first['jsonData'];
      final decoded = rawJson is String
          ? await compute(parseJsonInBackground, rawJson)
          : (rawJson ?? {});
      final List apiItems = decoded['Items'] ?? [];

      items = await compute(_parseApiItemsInBackground, {
        'items': apiItems,
        'department': selectedDepartment,
        'block': selectedBlock,
        'month': month,
        'year': year,
        'departmentId': departmentId, // ✅ pass it here
      });


      await _computeMetrics();
    } catch (e, st) {
      debugPrint('❌ Error fetching dashboard data: $e\n$st');
    } finally {
      _setLoading(false);
    }
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    final str = value.toString().replaceAll(',', '');
    return double.tryParse(str) ?? 0.0;
  }


// Background isolate parser for heavy API responses
  static List<ApiItem> _parseApiItemsInBackground(Map<String, dynamic> args) {
    final List items = args['items'] ?? [];
    final String department = args['department'] ?? '';
    final String block = args['block'] ?? '';
    final int month = args['month'] ?? 0;
    final int year = args['year'] ?? 0;
    final int departmentId = args['departmentId'] ?? 0;

    return items.map<ApiItem>((item) {
      return ApiItem.fromJson(
        item as Map<String, dynamic>,
        department: department,
        block: block,
        month: month,
        year: year,
        departmentId: departmentId,
      );
    }).toList();
  }

  /// =======================
  /// COMPUTE METRICS
  /// =======================
  Future<void> _computeMetrics() async {
    final result = await compute(_computeMetricsInBackground, {
      'items': items,
      'selectedBlock': selectedBlock,
    });

    totalTarget = result['totalTarget'] ?? 0.0;
    totalAchieved = result['totalAchieved'] ?? 0.0;
    avgPercent = result['avgPercent'] ?? 0.0;

    barGroups = List.generate(items.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: items[i].achievement,
            width: 12,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });

    lineSpots = List.generate(
      items.length,
          (i) => FlSpot(i.toDouble(), items[i].financial),
    );

    notifyListeners();
  }

  static Map<String, double> _computeMetricsInBackground(Map<String, dynamic> args) {
    final List<ApiItem> items = args['items'];
    final String selectedBlock = args['selectedBlock'];

    final filtered = selectedBlock == 'All Blocks'
        ? items
        : items.where((it) => it.block == selectedBlock).toList();

    final totalTarget =
    filtered.fold<double>(0.0, (sum, it) => sum + it.target);
    final totalAchieved =
    filtered.fold<double>(0.0, (sum, it) => sum + it.achievement);
    final avgPercent = filtered.isEmpty
        ? 0.0
        : filtered.fold<double>(
      0.0,
          (sum, it) =>
      sum + (it.target == 0 ? 0.0 : (it.achievement / it.target * 100)),
    ) /
        filtered.length;

    return {
      'totalTarget': totalTarget,
      'totalAchieved': totalAchieved,
      'avgPercent': avgPercent,
    };
  }



  /// =======================
  /// UPDATE FILTERS (DEBOUNCED)
  /// =======================
  void _debouncedLoad(VoidCallback fn) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), fn);
  }

  Future<void> updateDepartment(String dept) async {
    selectedDepartment = dept;
    await saveSelectedFilters();
    _debouncedLoad(loadDashboardData);
  }

  Future<void> updateBlock(String block) async {
    selectedBlock = block;
    await saveSelectedFilters();
    _debouncedLoad(() async => await _computeMetrics());
  }

  Future<void> updateMonth(String month) async {
    selectedMonth = month;
    await saveSelectedFilters();
    _debouncedLoad(loadDashboardData);
  }

  Future<void> updateYear(String year) async {
    selectedYear = year;
    await saveSelectedFilters();
    _debouncedLoad(loadDashboardData);
  } 

  Future<void> updateDepartments() async {
    _debouncedLoad(loadDashboardDataForMultipleDepartments);
  }





  /// =======================
  /// UTILITIES
  /// =======================
  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }


  List<ApiItem> get filteredItems {
    if (selectedBlock == 'All Blocks') return items;
    return items.where((it) => it.block == selectedBlock).toList();
  }

  List<String> selectedDepartments = [];

// ✅ Add this field near top of your controller
  final Map<String, dynamic> departmentDataByName = {};

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}