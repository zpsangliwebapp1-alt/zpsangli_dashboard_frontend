import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/section_page.dart';

class AdditionalCeoFinanceScreen extends StatelessWidget {
  const AdditionalCeoFinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: "Finance Overview",
      icon: Icons.account_balance_wallet_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Budget allocation and expenditure details for Zilla Parishad schemes.",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),

          /// 🔹 Finance Cards
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              FinanceCard(
                title: "₹ 12,50,000",
                subtitle: "Total Budget 2025-26",
                color: Color(0xFFDDF6FF),
              ),
              FinanceCard(
                title: "₹ 9,30,000",
                subtitle: "Expenditure Till Date",
                color: Color(0xFFFFE7E7),
              ),
              FinanceCard(
                title: "₹ 3,20,000",
                subtitle: "Remaining Funds",
                color: Color(0xFFE8F8EE),
              ),
              FinanceCard(
                title: "₹ 1,50,000",
                subtitle: "Pending Approvals",
                color: Color(0xFFFDF1E8),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// 🔹 Detailed Finance Table
          Text(
            "Scheme-wise Budget Allocation",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          _financeTable(),
        ],
      ),
    );
  }

  /// Finance Table
  Widget _financeTable() {
    final schemes = [
      {"name": "Anganwadi Nutrition", "budget": "₹ 5,00,000", "spent": "₹ 3,80,000"},
      {"name": "Water Supply", "budget": "₹ 3,00,000", "spent": "₹ 2,50,000"},
      {"name": "Rural Roads Repair", "budget": "₹ 2,00,000", "spent": "₹ 1,40,000"},
      {"name": "School Development", "budget": "₹ 2,50,000", "spent": "₹ 1,60,000"},
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: DataTable(
        columns: const [
          DataColumn(label: Text("Scheme")),
          DataColumn(label: Text("Budget")),
          DataColumn(label: Text("Expenditure")),
          DataColumn(label: Text("Balance")),
        ],
        rows: schemes.map((scheme) {
          final budget = int.parse(scheme["budget"]!.replaceAll("₹ ", "").replaceAll(",", ""));
          final spent = int.parse(scheme["spent"]!.replaceAll("₹ ", "").replaceAll(",", ""));
          final balance = budget - spent;

          return DataRow(cells: [
            DataCell(Text(scheme["name"]!)),
            DataCell(Text(scheme["budget"]!)),
            DataCell(Text(scheme["spent"]!)),
            DataCell(Text("₹ ${balance.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => "${m[1]},")}")),
          ]);
        }).toList(),
      ),
    );
  }
}

/// Finance Card Widget
class FinanceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const FinanceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                )),
            const SizedBox(height: 6),
            Text(subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[700],
                )),
          ],
        ),
      ),
    );
  }
}
