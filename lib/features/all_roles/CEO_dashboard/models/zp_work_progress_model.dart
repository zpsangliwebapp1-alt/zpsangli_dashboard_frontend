class ZpWorkProgressModel {
  final String header1;
  final String district;
  final List<ZpBlockItem> items;

  ZpWorkProgressModel({
    required this.header1,
    required this.district,
    required this.items,
  });

  factory ZpWorkProgressModel.fromJson(Map<String, dynamic> json) {
    final items = (json['Items'] as List)
        .map((e) => ZpBlockItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return ZpWorkProgressModel(
      header1: json['Header1'] ?? '',
      district: json['District'] ?? '',
      items: items,
    );
  }
}

class ZpBlockItem {
  final String block;
  final double estimatedCost;
  final double expenses;
  final int noOfSchemes;
  final int total100Completed;
  final Map<String, double> progressPercentage;

  ZpBlockItem({
    required this.block,
    required this.estimatedCost,
    required this.expenses,
    required this.noOfSchemes,
    required this.total100Completed,
    required this.progressPercentage,
  });

  factory ZpBlockItem.fromJson(Map<String, dynamic> json) {
    final perc = json['ProgressOfSchemePercentage'] ?? {};
    return ZpBlockItem(
      block: json['Block']?.toString() ?? 'Unknown',
      estimatedCost: double.tryParse(json['EstimatedCost'].toString()) ?? 0.0,
      expenses: double.tryParse(json['Expenses'].toString()) ?? 0.0,
      noOfSchemes: int.tryParse(json['NoOfSchemes'].toString()) ?? 0,
      total100Completed: int.tryParse(json['Total100Completed'].toString()) ?? 0,
      progressPercentage: {
        '0–25%': double.tryParse(perc['P0_25'].toString()) ?? 0,
        '25–50%': double.tryParse(perc['P25_50'].toString()) ?? 0,
        '50–75%': double.tryParse(perc['P50_75'].toString()) ?? 0,
        '75–99%': double.tryParse(perc['P75_99'].toString()) ?? 0,
        '100%': double.tryParse(perc['P100'].toString()) ?? 0,
      },
    );
  }
}
