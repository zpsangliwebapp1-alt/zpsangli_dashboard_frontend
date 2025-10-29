import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DepartmentDashboardScreen extends StatelessWidget {
  const DepartmentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPage(
      title: "Block Overview Dashboard",
      icon: Icons.dashboard_rounded,
      content: const Text("Visual summary of key metrics, targets & performance."),
    );
  }
}

Widget _buildPage({required String title, required IconData icon, required Widget content}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, color: Colors.indigo, size: 28),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      const SizedBox(height: 16),
      content,
    ],
  );
}
