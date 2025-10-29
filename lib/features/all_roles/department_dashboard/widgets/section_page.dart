// lib/ui/widgets/section_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final String? subtitle;
  final EdgeInsetsGeometry padding;

  const SectionPage({
    Key? key,
    required this.title,
    required this.icon,
    required this.child,
    this.subtitle,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
    );

    final subtitleStyle = GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.grey.shade700,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
                const SizedBox(width: 10),
                Text(title, style: titleStyle),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!, style: subtitleStyle),
            ],
            const SizedBox(height: 16),
            // Provide the page content area - the child should handle its own sizing
            child,
          ],
        ),
      ),
    );
  }
}
