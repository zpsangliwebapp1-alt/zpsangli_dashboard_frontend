import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../auth/provider/auth_provider.dart';
import '../../../departments/providers/department_provider.dart';
import '../../ceo_dashboard/presentation/department_overview_card.dart';
import '../controller/ceo_dashboard_controller.dart';
import '../presentation/department_overview_card.dart' hide DepartmentOverviewCard;
import '../widgets/filter_row.dart';

class CeoDashboardContent extends StatelessWidget {
  final bool mobile;
  const CeoDashboardContent({super.key, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CeoDashboardController(
        authProvider: context.read<AuthProvider>(),
        departmentProvider: context.read<DepartmentProvider>(),
      )..init(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Selector<CeoDashboardController, bool>(
      selector: (_, c) => c.isLoading,
      builder: (_, isLoading, __) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return const _DashboardBody();
      },
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<CeoDashboardController>();

    final block = ctrl.selectedBlock;
    final department = ctrl.selectedDepartment;



    // Build monthlyTotals for charts
    final monthlyTotals = {
      for (var item in ctrl.items)
        item.name: {
          "financial": item.financial ?? 0.0,
          "achievement": item.achievement ?? 0.0,
          "target": item.target ?? 0.0,
        }
    };

    // Build satisfactionData as Map<String, double>
    // Example: { "Jan": 80, "Feb": 90, ... }
    final satisfactionData = {
      for (var item in ctrl.items)
        item.name: item.achievement ?? 0.0, // <-- Use your actual satisfaction field here!
    };


    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FilterRow(ctrl: ctrl),
            const SizedBox(height: 16),

            DepartmentOverviewCard(
              block: block,
              department: department,
              monthlyTotals: monthlyTotals,
              lastUpdated: DateTime.now(),
              selectedMonth: ctrl.selectedMonth,
              selectedYear: ctrl.selectedYear,
              satisfactionData: satisfactionData,
              departmentId: ctrl.selectedDepartmentId ?? 0, // departmentId from selected
            ),

            const SizedBox(height: 24),
            // DashboardGrid(mobile: false)
          ],
        ),
      ),
    );
  }
}