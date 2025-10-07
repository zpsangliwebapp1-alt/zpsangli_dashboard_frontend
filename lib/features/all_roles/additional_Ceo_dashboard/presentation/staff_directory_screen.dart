import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/section_page.dart';

class AdditinalCeoStaffDirectoryScreen extends StatelessWidget {
  const AdditinalCeoStaffDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: "Staff Directory",
      icon: Icons.people_alt_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text("Mr. A. Patil"),
            subtitle: Text("BDO - Atpadi"),
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text("Mrs. D. Joshi"),
            subtitle: Text("Engineer - RDD"),
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text("Mr. R. Kale"),
            subtitle: Text("Accountant"),
          ),
        ],
      ),
    );
  }
}
