import 'dart:convert';

class CeoDashboardModel {
  final String blockName;
  final String departmentName;
  final double achieved;
  final double target;
  final double percentage;

  CeoDashboardModel({
    required this.blockName,
    required this.departmentName,
    required this.achieved,
    required this.target,
    required this.percentage,
  });

  /// ✅ Factory to create object from API JSON
  factory CeoDashboardModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return CeoDashboardModel(
      blockName: json['blockName']?.toString() ?? '',
      departmentName: json['departmentName']?.toString() ?? '',
      achieved: parseDouble(json['achieved']),
      target: parseDouble(json['target']),
      percentage: parseDouble(json['percentage']),
    );
  }

  /// ✅ Optional: convert back to JSON if needed later
  Map<String, dynamic> toJson() => {
    'blockName': blockName,
    'departmentName': departmentName,
    'achieved': achieved,
    'target': target,
    'percentage': percentage,
  };
}


class CeoJsonDataModel {
  final String blockName;
  final String departmentName;
  final double achieved;
  final double target;

  CeoJsonDataModel({
    required this.blockName,
    required this.departmentName,
    required this.achieved,
    required this.target,
  });

  factory CeoJsonDataModel.fromJson(Map<String, dynamic> json) {
    return CeoJsonDataModel(
      blockName: json['blockName']?.toString() ?? '',
      departmentName: json['departmentName']?.toString() ?? '',
      achieved: (json['achieved'] ?? 0).toDouble(),
      target: (json['target'] ?? 0).toDouble(),
    );
  }
}


class CeoJsonData {
  final String srNo;
  final String item;
  final double purpose;
  final double achieved;
  final double percentage;

  CeoJsonData({
    required this.srNo,
    required this.item,
    required this.purpose,
    required this.achieved,
    required this.percentage,
  });

  factory CeoJsonData.fromMap(Map<String, dynamic> map) {
    double parseDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0;
      return 0;
    }

    return CeoJsonData(
      srNo: map['SrNo']?.toString() ?? '',
      item: map['Item']?.toString() ?? '',
      purpose: parseDouble(map['Purpose']),
      achieved: parseDouble(map['Achieved']),
      percentage: parseDouble(map['Percentage']),
    );
  }
}
