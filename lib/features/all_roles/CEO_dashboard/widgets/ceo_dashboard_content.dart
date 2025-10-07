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
import '../charts/baar_chart.dart';
import '../charts/dashboard_grid.dart';
import '../charts/kpi_list.dart';
import '../charts/line_chart.dart';
import '../controller/ceo_dashboard_controller.dart';
import '../models/json_data_model.dart';
import '../../../../core/utils/json_parser.dart';
import 'CeoKpiSummaryCards.dart';
import 'filter_row.dart';

/// =======================
/// MAIN DASHBOARD WIDGET
/// =======================
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

/// =======================
/// DASHBOARD VIEW
/// =======================
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

/// =======================
/// DASHBOARD BODY
/// =======================
class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<CeoDashboardController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FilterRow(ctrl: ctrl),
          const SizedBox(height: 16),

          CeoKpiSummaryCards(
            financialData: {for (var it in ctrl.items) it.name: it.financial},
            satisfactionData: const {},
            targetData: {for (var it in ctrl.items) it.name: it.target},
            achievementData: {for (var it in ctrl.items) it.name: it.achievement},
            selectedBlock: ctrl.selectedBlock,
            selectedDepartment: ctrl.selectedDepartment,
            selectedMonth: ctrl.selectedMonth,
            selectedYear: ctrl.selectedYear,
          ),
          const SizedBox(height: 24),
          Expanded(child: DashboardGrid(mobile: false)),
        ],
      ),
    );
  }
}




