import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/section_page.dart';

class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: "Complaints Management",
      icon: Icons.report_problem_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "View and resolve pending complaints from the public.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.warning_amber_rounded, color: Colors.orange),
            title: Text("Road damage near Atpadi Market"),
            subtitle: Text("Submitted by: Ramesh Jadhav"),
            trailing: Text("Pending", style: TextStyle(color: Colors.red)),
          ),
          ListTile(
            leading: Icon(Icons.warning_amber_rounded, color: Colors.orange),
            title: Text("Water supply issue - Khanapur block"),
            subtitle: Text("Submitted by: Sunita Pawar"),
            trailing: Text("Resolved", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
