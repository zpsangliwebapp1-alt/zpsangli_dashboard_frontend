import 'package:flutter/material.dart';


class CeoTopProductsList extends StatelessWidget {
  const CeoTopProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    // Simple list that imitates the top products block in the screenshot
    final items = [
      {'name': 'Home Decor Range', 'percent': 45},
      {'name': 'Disney Princess Pink Bag 1B', 'percent': 29},
      {'name': 'Bathroom Essentials', 'percent': 18},
      {'name': 'Apple Smartwatches', 'percent': 25},
    ];

    return Column(
      children: items.map((it) {
        final value = it['percent'] as int;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text('${items.indexOf(it) + 1}'.padLeft(2, '0'), style: const TextStyle(color: Colors.grey)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(it['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: LinearProgressIndicator(value: value / 100, minHeight: 8),
              ),
              const SizedBox(width: 12),
              Text('$value%', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
