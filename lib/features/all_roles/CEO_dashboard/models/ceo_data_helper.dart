import '../../ceo_dashboard/models/json_data_model.dart';

/// Prepare Department 7 data for UI
Map<String, dynamic> prepareDepartment7Data(List<ApiItem> apiItems, String department) {
  final Map<String, Map<String, double>> monthlyTotals = {};
  final Map<String, List<Map<String, dynamic>>> departmentData = {};

  for (var item in apiItems) {
    final monthName = _monthName(item.month);
    monthlyTotals[monthName] = {
      "target": item.target,
      "achievement": item.achievement,
      "financial": item.financial,
      "estimatedCost": 0.0,
    };
  }

  departmentData[department] = [
    {
      "items": apiItems.map((e) {
        return {
          "name": e.name,
          "financial": e.financial,
          "achievement": e.achievement,
        };
      }).toList()
    }
  ];

  return {
    "monthlyTotals": monthlyTotals,
    "departmentData": departmentData,
  };
}

/// Convert month number to name
String _monthName(int month) {
  const names = [
    "", // index 0 unused
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  return (month >= 1 && month <= 12) ? names[month] : "Unknown";
}
