import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/section_page.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: "aGovernment Schemes",
      icon: Icons.account_tree_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Track all schemes under various departments (e.g., Rural Dev., Health, Education).",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),

          /// 🔹 Scheme Cards
          _schemeCard("PM Awas Yojana", "1,200 houses completed"),
          _schemeCard("Swachh Bharat Mission", "85% target achieved"),
          _schemeCard("MGNREGA", "₹ 2.3 Cr disbursed this month"),
          _schemeCard("National Health Mission", "80% immunization coverage"),
          _schemeCard("Sarva Shiksha Abhiyan", "95% school enrollment"),
        ],
      ),
    );
  }

  Widget _schemeCard(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.assignment_turned_in, color: Colors.indigo),
        title: Text(title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // TODO: Navigate to scheme detail page
        },
      ),
    );
  }
}
