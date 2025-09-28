class SwmRecord {
  final String block;
  final String department;
  final String period; // e.g. 2023, Last 6 Months, etc.
  final Map<String, dynamic> metrics;

  SwmRecord({
    required this.block,
    required this.department,
    required this.period,
    required this.metrics,
  });

  factory SwmRecord.fromJson(Map<String, dynamic> json) {
    final metrics = Map<String, dynamic>.from(json)..remove('block')..remove('department')..remove('period');
    return SwmRecord(
      block: json['block'],
      department: json['department'],
      period: json['period'],
      metrics: metrics,
    );
  }
}
