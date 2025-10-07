
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../controller/ceo_dashboard_controller.dart';
import '../models/json_data_model.dart';

/// =======================
/// FILTER ROW
/// =======================

class FilterRow extends StatelessWidget {
  final CeoDashboardController ctrl;
  const FilterRow({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Wrap(
        spacing: 18,
        runSpacing: 18,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _dropdown(
            "Department",
            ctrl.selectedDepartment,
            ctrl.departmentProvider.departments.map((e) => e.name).toList(),
                (v) => ctrl.updateDepartment(v ?? ""),
          ),
          _dropdown(
            "Block",
            ctrl.selectedBlock,
            ctrl.blocks.map((b) => b["name"].toString()).toList(),
                (v) => ctrl.updateBlock(v ?? ""),
          ),
          _dropdown(
            "Month",
            ctrl.selectedMonth,
            ctrl.apiMonths,
                (v) => ctrl.updateMonth(v ?? ""),
          ),
          _dropdown(
            "Year",
            ctrl.selectedYear,
            ctrl.apiYears,
                (v) => ctrl.updateYear(v ?? ""),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
      String label,
      String value,
      List<String> items,
      ValueChanged<String?> onChanged,
      ) {
    return SizedBox(
      width: 310,
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          prefixIcon: const Icon(Icons.filter_alt_rounded, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.3),
          ),
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.blueAccent,
        ),
        dropdownColor: Colors.white,
        items: items
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}