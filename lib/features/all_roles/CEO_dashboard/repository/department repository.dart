import 'dart:convert';
import 'package:flutter/services.dart';

class DepartmentRepository {
  static Future<Map<String, List<Map<String, dynamic>>>> loadData() async {
    final jsonStr = await rootBundle.loadString("assets/data/department_data.json");
    final Map<String, dynamic> raw = jsonDecode(jsonStr);

    return raw.map((dept, records) =>
        MapEntry(dept, List<Map<String, dynamic>>.from(records)));
  }
}
