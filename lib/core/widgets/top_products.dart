import 'package:flutter/material.dart';

class TopProductsList extends StatelessWidget {
  final String department;
  final Map<String, List<Map<String, dynamic>>> departmentData;

  const TopProductsList({
    super.key,
    required this.department,
    required this.departmentData,
  });

  @override
  Widget build(BuildContext context) {
    final deptItems = departmentData[department] ?? [];

    // Flatten all block rows into progress items
    final items = <Map<String, dynamic>>[];

    for (final blockData in deptItems) {
      final blockName = blockData['block'];
      for (final entry in blockData.entries) {
        if (entry.key == "block") continue;
        items.add({
          "name": "$blockName - ${entry.key}", // e.g. "Atpadi - Target"
          "percent": _normalizeToPercent(entry.value),
        });
      }
    }

    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final it = entry.value;
        final value = it['percent'] as double;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text('${index + 1}'.padLeft(2, '0'),
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(it['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: LinearProgressIndicator(
                  value: value / 100,
                  minHeight: 8,
                ),
              ),
              const SizedBox(width: 12),
              Text('${value.toStringAsFixed(0)}%',
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }).toList(),
    );
  }

  double _normalizeToPercent(dynamic raw) {
    if (raw is num) {
      return raw > 100 ? 100 : raw.toDouble();
    }
    return 0;
  }
}
