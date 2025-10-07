import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/section_page.dart';

class Additional_ceo_DepartmentsScreen extends StatelessWidget {
  const Additional_ceo_DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: "Departments Overview",
      icon: Icons.apartment_rounded,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 800
              ? 4
              : constraints.maxWidth > 500
              ? 3
              : 2;

          return GridView.count(
            shrinkWrap: true,
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _deptCard("Education", Icons.school, Colors.deepPurple.shade100),
              _deptCard("Health", Icons.local_hospital, Colors.red.shade100),
              _deptCard("Agriculture", Icons.agriculture, Colors.green.shade100),
              _deptCard("Water Supply", Icons.water_drop, Colors.blue.shade100),
              _deptCard("Rural Development", Icons.home_work, Colors.orange.shade100),
              _deptCard("Women & Child Dev.", Icons.family_restroom, Colors.pink.shade100),
              _deptCard("Finance & Audit", Icons.account_balance_wallet, Colors.teal.shade100),
              _deptCard("Panchayat Raj", Icons.account_balance, Colors.indigo.shade100),
            ],
          );
        },
      ),
    );
  }

  Widget _deptCard(String name, IconData icon, Color bgColor) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: bgColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // You can navigate to department detail page here
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: Colors.indigo.shade700),
              const SizedBox(height: 10),
              Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
