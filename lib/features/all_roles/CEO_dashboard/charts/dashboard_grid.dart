import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../controller/ceo_dashboard_controller.dart';
import '../models/json_data_model.dart';
import 'baar_chart.dart';
import 'kpi_list.dart';
import 'line_chart.dart';


/// =======================
/// GRID VIEW
/// =======================
class DashboardGrid extends StatelessWidget {
  final bool mobile;
  const DashboardGrid({required this.mobile});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<CeoDashboardController>();
    final items = ctrl.filteredItems;

    return MasonryGridView.count(
      crossAxisCount: mobile ? 1 : 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: 3,
      itemBuilder: (_, i) {
        switch (i) {
          case 0:
            return _card(
              "Achievement Overview",
              BarChartWidget(groups: ctrl.barGroups),
            );
          case 1:
            return _card(
              "Financial Progress",
              LineChartWidget(spots: ctrl.lineSpots),
            );
          case 2:
            return _card("KPI List", KpiList(items: items));
        // case 2:
        //   return _card("Department Financial Distribution",C
        //       _PieChart(items: items));
          case 3:
            return _card("KPI List", KpiList(items: items));
          default:
            return const SizedBox();
        }
      },
    );
  }

  Widget _card(String title, Widget child) => Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          SizedBox(height: 240, child: child),
        ],
      ),
    ),
  );
}