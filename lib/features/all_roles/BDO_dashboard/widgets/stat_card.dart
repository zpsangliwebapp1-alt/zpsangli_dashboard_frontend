// lib/ui/widgets/ceo_stat_card.dart
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;      // e.g. "$1k"
  final String subtitle;   // e.g. "Total Sales"
  final String hint;       // e.g. "+8% from yesterday"
  final Color color;       // background color

  const StatCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.hint,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          Text(
            hint,
            style: TextStyle(
              fontSize: 12,
              color: hint.startsWith('-') ? Colors.red : Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
