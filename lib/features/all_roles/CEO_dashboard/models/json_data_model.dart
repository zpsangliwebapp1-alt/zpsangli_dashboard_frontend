import 'dart:convert';

class ApiItem {
  final int id;
  final String name;
  final String department;
  final String block;
  final int month;
  final int year;
  final double target;
  final double achievement;
  final double financial;

  ApiItem({
    required this.id,
    required this.name,
    required this.department,
    required this.block,
    required this.month,
    required this.year,
    required this.target,
    required this.achievement,
    required this.financial,
  });
}


class ApiResponse {
  final List<ApiItem> items;
  ApiResponse({required this.items});

  factory ApiResponse.fromJson(String rawJson) {
    final decoded = json.decode(rawJson);
    return ApiResponse(
      items: (decoded["Items"] as List).map((e) {
        return ApiItem(
          id: e["Id"] ?? 0,
          name: e["Item"] ?? "",
          department: e["Department"] ?? "",
          block: e["Block"] ?? "",
          month: int.tryParse(e["Month"].toString()) ?? 0,
          year: int.tryParse(e["Year"].toString()) ?? 0,
          target: double.tryParse(e["Purpose"].toString()) ?? 0,
          achievement: double.tryParse(e["Achieved"].toString()) ?? 0,
          financial: double.tryParse(e["Percentage"].toString()) ?? 0,
        );
      }).toList(),
    );
  }
}
