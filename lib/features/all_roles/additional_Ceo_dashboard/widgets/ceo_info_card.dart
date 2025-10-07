// lib/ui/widgets/ceo_info_card.dart
import 'package:flutter/material.dart';

class AdditionalCeoInfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onDownload;

  const AdditionalCeoInfoCard({
    super.key,
    required this.title,
    required this.child,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row with optional action
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (onDownload != null)
                  IconButton(
                    onPressed: onDownload,
                    icon: const Icon(Icons.file_download_outlined),
                    tooltip: 'Download Data',
                  ),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
