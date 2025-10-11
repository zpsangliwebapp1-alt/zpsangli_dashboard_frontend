import 'package:flutter/material.dart';
import '../controller/ceo_dashboard_controller.dart';

class FilterRow extends StatelessWidget {
  final CeoDashboardController ctrl;
  const FilterRow({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Extract department list from provider
    final departments = ctrl.departmentProvider.departments;

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
          /// 🔹 Department Dropdown
          _dropdown(
            "Department",
            ctrl.selectedDepartment,
            departments.map((e) => e.name).toList(),
                (v) {
              if (v != null && v.isNotEmpty) {
                // Find the full department object
                final selectedDept = departments.firstWhere(
                      (d) => d.name == v,
                  orElse: () => departments.first,
                );

                ctrl.updateDepartment(v);

                // ✅ Print both ID and Name
                debugPrint(
                    "🏢 Selected Department → ID: ${selectedDept.id}, Name: ${selectedDept.name}");
              }
            },
          ),

          /// 🔹 Block Dropdown
          _dropdown(
            "Block",
            ctrl.selectedBlock,
            ctrl.blocks.map((b) => b["name"].toString()).toList(),
                (v) {
              if (v != null) {
                ctrl.updateBlock(v);
                debugPrint("🧱 Selected Block: $v");
              }
            },
          ),

          /// 🔹 Month Dropdown
          _dropdown(
            "Month",
            ctrl.selectedMonth,
            ctrl.apiMonths,
                (v) {
              if (v != null) {
                ctrl.updateMonth(v);
                debugPrint("📅 Selected Month: $v");
              }
            },
          ),

          /// 🔹 Year Dropdown
          _dropdown(
            "Year",
            ctrl.selectedYear,
            ctrl.apiYears,
                (v) {
              if (v != null) {
                ctrl.updateYear(v);
                debugPrint("🗓️ Selected Year: $v");
              }
            },
          ),
        ],
      ),
    );
  }

  /// Dropdown builder widget
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
            borderSide:
            const BorderSide(color: Colors.blueAccent, width: 1.3),
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
