import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/section_page.dart';

class ProgressReportsScreen extends StatelessWidget {
  const ProgressReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: "Project Progress Reports",
      icon: Icons.insights_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _progressTile("Rural Road Construction", 0.78),
          _progressTile("Health Center Renovation", 0.92),
          _progressTile("Anganwadi Modernization", 0.65),
          _progressTile("Water Supply Project", 0.85),
          _progressTile("School Renovation Program", 0.70),
        ],
      ),
    );
  }

  Widget _progressTile(String title, double value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[200],
              color: Colors.indigo,
              minHeight: 8,
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${(value * 100).toStringAsFixed(1)}%",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
