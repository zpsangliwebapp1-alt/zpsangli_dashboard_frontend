import 'package:flutter/material.dart';

class TopProductsList extends StatefulWidget {
  final String department;
  final Map<String, List<Map<String, dynamic>>> departmentData;

  const TopProductsList({
    super.key,
    required this.department,
    required this.departmentData,
  });

  @override
  State<TopProductsList> createState() => _TopProductsListState();
}

class _TopProductsListState extends State<TopProductsList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final deptMonths = widget.departmentData[widget.department] ?? [];

    // Flatten all month+block items into a single list
    final items = <Map<String, dynamic>>[];

    for (final monthData in deptMonths) {
      final blockName = monthData['block'] ?? "TOTAL";
      final month = monthData['month'] ?? "";
      final List<dynamic> products = monthData['items'] ?? [];

      for (final product in products) {
        final target = (product['target'] as num?) ?? 0;
        final achievement = (product['achievement'] as num?) ?? 0;

        // Calculate percentage safely
        final percent = target > 0 ? (achievement / target) * 100 : 0.0;

        items.add({
          "name": "${product['name']} ($blockName - $month)",
          "percent": percent.clamp(0, 100),
        });
      }
    }

    // Show only 5 if not expanded
    final visibleItems = _expanded ? items : items.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...visibleItems.asMap().entries.map((entry) {
          final index = entry.key;
          final it = entry.value;
          final value = it['percent'] as double;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text(
                  '${index + 1}'.padLeft(2, '0'),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    it['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(
                    value: value / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${value.toStringAsFixed(0)}%',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }),
        if (items.length > 5)
          Center(
            child: TextButton.icon(
              onPressed: () => setState(() => _expanded = !_expanded),
              icon: AnimatedRotation(
                turns: _expanded ? 0.5 : 0.0, // rotates arrow 180°
                duration: const Duration(milliseconds: 250),
                child: const Icon(Icons.keyboard_arrow_down, size: 20),
              ),
              label: Text(
                _expanded ? "Show Less" : "Show More",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueGrey,
              ),
            ),
          ),
      ],
    );
  }
}
