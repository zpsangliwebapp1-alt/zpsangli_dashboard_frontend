import 'dart:convert';
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>> parseJsonInBackground(String rawJson) async {
  return await compute(_parseJson, rawJson);
}

Map<String, dynamic> _parseJson(String rawJson) {
  return json.decode(rawJson);
}
