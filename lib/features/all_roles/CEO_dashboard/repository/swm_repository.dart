import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/SwmRecordModel.dart';

class SwmRepository {
  static Future<List<SwmRecord>> loadData() async {
    final String response = await rootBundle.loadString('assets/data/department_data.json');
    final List<dynamic> data = json.decode(response);

    return data.map((json) => SwmRecord.fromJson(json)).toList();
  }
}
