import 'dart:convert';

class ApiItem {
  final int id;
  final int departmentId;
  final String name;
  final String department;
  final String block;
  final int month;
  final int year;
  final double target;
  final double achievement;
  final double financial;
  final String? remark;

  ApiItem({
    required this.id,
    required this.departmentId,
    required this.name,
    required this.department,
    required this.block,
    required this.month,
    required this.year,
    required this.target,
    required this.achievement,
    required this.financial,
    this.remark,
  });

  /// Safely parse any numeric value to double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    final str = value.toString().replaceAll(',', '').trim();
    return double.tryParse(str) ?? 0.0;
  }

  /// -------------------------------
  /// FACTORY – Parse JSON by Department
  /// -------------------------------
  factory ApiItem.fromJson(
      Map<String, dynamic> e, {
        required String department,
        required String block,
        required int month,
        required int year,
        required int departmentId,
      }) {
    try {
      switch (departmentId) {
      // 🔹 Department 1: Rural Water Supply
        case 1:
          return ApiItem(
            id: 0,
            departmentId: departmentId,
            name: e['Item']?.toString() ?? '',
            department: department,
            block: block,
            month: month,
            year: year,
            target: _parseDouble(e['Target']?['Physical']),
            achievement: _parseDouble(e['Achieved']?['Physical']),
            financial: _parseDouble(e['Achieved']?['Financial']),
            remark: e['Remark']?.toString(),
          );


      // 🔹 Department 2: Gramin Pani Puravatha (New)
        case 2:
        // Example fields based on your sample JSON:
        // NoOfSchemes, EstimatedCost, Expenses, ProgressOfScheme
        // ProgressOfSchemePercentage → Map { P0_25, P25_50, ... }
          final progressMap = e['ProgressOfSchemePercentage'] ?? {};
          final remarkParts = [
            if (progressMap is Map)
              "P0-25: ${progressMap['P0_25'] ?? 0}, P25-50: ${progressMap['P25_50'] ?? 0}, "
                  "P50-75: ${progressMap['P50_75'] ?? 0}, P75-99: ${progressMap['P75_99'] ?? 0}, "
                  "P100: ${progressMap['P100'] ?? 0}",
            if (e['CompletedInAllRespect'] != null)
              "Completed: ${e['CompletedInAllRespect']}",
            if (e['Total100Completed'] != null)
              "Total 100% Completed: ${e['Total100Completed']}",
            if (e['HandedoverSchemes'] != null)
              "Handed Over: ${e['HandedoverSchemes']}",
          ];

          return ApiItem(
            id: 0,
            departmentId: departmentId,
            name: e['Block']?.toString() ?? '',
            department: department,
            block: e['Block']?.toString() ?? block,
            month: month,
            year: year,
            target: _parseDouble(e['NoOfSchemes']),
            achievement: _parseDouble(e['ProgressOfScheme']),
            financial: _parseDouble(e['Expenses']),
            remark: remarkParts.where((p) => p.isNotEmpty).join(', '),
          );


      // 🔹 Department 4: Animal Husbandry
        case 4:
          return ApiItem(
            id: 0,
            departmentId: departmentId,
            name: e['Item']?.toString() ?? '',
            department: department,
            block: block,
            month: month,
            year: year,
            target: _parseDouble(e['Purpose']),
            achievement: _parseDouble(e['Achieved']),
            financial: _parseDouble(e['Percentage']),
            remark: e['Remark']?.toString(),
          );
      // 🔹 Department 5: ZP Work in Progress / IHHL
        case 5:
          return ApiItem(
            id: 0,
            departmentId: departmentId,
            name: e['Block']?.toString() ?? '',
            department: department,
            block: e['Block']?.toString() ?? block,
            month: month,
            year: year,
            target: _parseDouble(e['IHHLTarget']),
            achievement: _parseDouble(e['IHHLAchievement']),
            financial: _parseDouble(e['Percentile']),
            remark: "Remaining: ${e['RemainingTarget'] ?? '0'}",
          );

      // ✅ 🔹 Department 6: Bandhkam Vibhag (Works)
        case 6:
          final physical = e['Physical'] ?? {};
          final financial = e['Financial'] ?? {};

          final remarkText = e['remark']?.toString() ?? '';
          final totalWorks = _parseDouble(physical['WorkApproved']);
          final completed = _parseDouble(physical['WorkCompleted']);
          final inProgress = _parseDouble(physical['WorkInprogress']);

          return ApiItem(
            id: 0,
            departmentId: departmentId,
            name: e['Block']?.toString() ?? 'Unknown Block',
            department: department,
            block: e['Block']?.toString() ?? block,
            month: month,
            year: year,
            // Using WorkApproved as target, Completed as achievement, and ReceivedAmount as financial
            target: totalWorks,
            achievement: completed + inProgress,
            financial: _parseDouble(financial['RecievedAmount']),
            remark:
            "Approved Cost: ₹${financial['ApprovedCost'] ?? '0'}, "
                "Required: ₹${financial['RequiredAmount'] ?? '0'}, "
                "${remarkText.isNotEmpty ? 'Remark: $remarkText' : ''}",
          );

      // 🔹 Department 7: ICDS / Child Development
        case 7:
          return ApiItem(
            id: 0,
            departmentId: departmentId,
            name: (e['Block']?.toString().isNotEmpty ?? false)
                ? e['Block'].toString()
                : (e['Project']?.toString() ?? ''),
            department: department,
            block: block,
            month: month,
            year: year,
            target: _parseDouble(e['AgeGroup0_5']),
            achievement: _parseDouble(e['Weighed']),
            financial:  _parseDouble(e['Weighed']),
            remark: [
              if (e['SAM'] != null) "SAM: ${e['SAM']}",
              if (e['MAM'] != null) "MAM: ${e['MAM']}",
              if (e['PercentileWithTotal'] != null)
                "Percentile: ${e['PercentileWithTotal']}",
            ].join(', '),
          );

        case 8:
          return ApiItem(
            id: 0,
            departmentId: departmentId,
            name: e['NameOfScheme']?.toString() ?? '',
            department: department,
            block: e['Department']?.toString() ?? block,
            month: month,
            year: year,
            target: _parseDouble(e['BudgetAllocatedFund']),
            achievement: _parseDouble(e['ReceivedAmountColumn8']),
            financial: _parseDouble(e['ExpenditurePercentile']),
            remark: [
              if (e['SchemeIndex'] != null)
                "Index: ${e['SchemeIndex']}",
              if (e['OutstandingAmount'] != null)
                "Outstanding: ₹${e['OutstandingAmount']}",
              if (e['ReceivedFund'] != null)
                "Received Fund: ₹${e['ReceivedFund']}",
              if (e['NoOfWorkApproved'] != null)
                "Works: ${e['NoOfWorkApproved']}",
            ].join(', '),
          );

        case 9:
          return ApiItem(
            id: 0,
            departmentId: departmentId,
            name: e['NameOfScheme']?.toString() ?? e['Title']?.toString() ?? '',
            department: department,
            block: block,
            month: month,
            year: year,
            target: _parseDouble(e['ApprovedAmount']),
            achievement: _parseDouble(e['TotalExpenditure']),
            financial: _parseDouble(e['CurrentBalanceAmount']),
            remark: [
              if (e['PreviousBalanceAmount'] != null)
                "Prev Balance: ₹${e['PreviousBalanceAmount']}",
              if (e['ReceivedAmount'] != null)
                "Received: ₹${e['ReceivedAmount']}",
              if (e['InRupee'] != null)
                "In Rupee: ${e['InRupee']}",
            ].join(', '),
          );

      // 🔹 Default (Generic Structure)
        default:
          final hasNestedTarget = e['Target'] is Map;
          final hasPurpose = e.containsKey('Purpose');

          if (hasNestedTarget) {
            return ApiItem(
              id: 0,
              departmentId: departmentId,
              name: e['Item']?.toString() ?? '',
              department: department,
              block: block,
              month: month,
              year: year,
              target: _parseDouble(e['Target']?['Physical']),
              achievement: _parseDouble(e['Achieved']?['Physical']),
              financial: _parseDouble(e['Achieved']?['Financial']),
              remark: e['Remark']?.toString(),
            );
          } else if (hasPurpose) {
            return ApiItem(
              id: 0,
              departmentId: departmentId,
              name: e['Item']?.toString() ?? '',
              department: department,
              block: block,
              month: month,
              year: year,
              target: _parseDouble(e['Purpose']),
              achievement: _parseDouble(e['Achieved']),
              financial: _parseDouble(e['Percentage']),
              remark: e['Remark']?.toString(),
            );
          } else {
            return ApiItem(
              id: 0,
              departmentId: departmentId,
              name: e['Item']?.toString() ?? '',
              department: department,
              block: block,
              month: month,
              year: year,
              target: 0,
              achievement: 0,
              financial: 0,
              remark: e['Remark']?.toString(),
            );
          }
      }
    } catch (error, stack) {
      print('❌ Error parsing ApiItem for department $departmentId: $error');
      print(stack);

      // Return safe fallback object to avoid crash
      return ApiItem(
        id: 0,
        departmentId: departmentId,
        name: e['Item']?.toString() ?? 'Unknown',
        department: department,
        block: block,
        month: month,
        year: year,
        target: 0,
        achievement: 0,
        financial: 0,
        remark: '⚠ Error parsing data: $error',
      );
    }
  }



  /// -------------------------------
  /// STATIC – Convert raw JSON string → List<ApiItem>
  /// -------------------------------
  static List<ApiItem> listFromRawJson(
      String rawJson, {
        required String department,
        required String block,
        required int month,
        required int year,
        required int departmentId,
      }) {
    try {
      final decoded = json.decode(rawJson);
      final items = (decoded['Items'] as List?) ?? [];
      return items
          .map((e) => ApiItem.fromJson(
        e,
        department: department,
        block: block,
        month: month,
        year: year,
        departmentId: departmentId,
      ))
          .toList();
    } catch (error, stack) {
      print('❌ Error decoding JSON for department $departmentId: $error');
      print(stack);
      return [];
    }
  }
}

/// -------------------------------
/// Extension – Human-friendly field labels
/// -------------------------------
extension ApiItemLabels on ApiItem {
  Map<String, String> get fieldLabels => fromDepartment(departmentId);

  static Map<String, String> fromDepartment(int departmentId) {
    switch (departmentId) {
      case 1:
        return {
          'targetLabel': 'Target (Physical)',
          'achievementLabel': 'Achieved (Physical)',
          'financialLabel': 'Financial (₹ Lakhs)',
          'unit': '₹',
        };
      case 2:
        return {
          'targetLabel': 'No. of Schemes',
          'achievementLabel': 'Progress of Scheme (%)',
          'financialLabel': 'Expenses (₹ Lakhs)',
          'unit': '₹',
        };
      case 4:
        return {
          'targetLabel': 'Purpose',
          'achievementLabel': 'Achieved',
          'financialLabel': 'Percentage (%)',
          'unit': '%',
        };
      case 5:
        return {
          'targetLabel': 'IHHL Target',
          'achievementLabel': 'IHHL Achievement',
          'financialLabel': 'Percentile (%)',
          'unit': '%',
        };
      case 6:
        return {
          'targetLabel': 'Works Approved',
          'achievementLabel': 'Works Completed/In Progress',
          'financialLabel': 'Received Amount (₹ Lakhs)',
          'unit': '₹',
        };

      case 7:
        return {
          'targetLabel': 'Age Group 0-5',
          'achievementLabel': 'Weighed',
          'financialLabel': 'Out-of Percentile (%)',
          'unit': '%',
        };

      case 8:
        return {
          'targetLabel': 'Budget Allocated (₹ Lakh)',
          'achievementLabel': 'Expenditure (₹ Lakh)',
          'financialLabel': 'Expenditure % ',
          'unit': '%',
        };

      case 9:
        return {
          'targetLabel': 'Approved Amount (₹)',
          'achievementLabel': 'Total Expenditure (₹)',
          'financialLabel': 'Current Balance (₹)',
          'unit': '₹',
        };
      default:
        return {
          'targetLabel': 'Target',
          'achievementLabel': 'Achieved',
          'financialLabel': 'Financial',
          'unit': '',
        };
    }
  }
}
