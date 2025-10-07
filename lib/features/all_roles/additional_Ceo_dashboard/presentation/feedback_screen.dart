import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/section_page.dart';

class AdditionalCeoFeedbackScreen extends StatelessWidget {
  const AdditionalCeoFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: "Public Feedback",
      icon: Icons.feedback_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Citizen feedback collected via mobile app and grievance forms.",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          _feedbackCard(
            name: "Ravi Patil",
            ward: "Atpadi",
            message: "Road repair near ZP School completed excellently. Thanks!",
            date: "05 Oct 2025",
            sentiment: "Positive",
            color: Colors.green.shade50,
          ),
          _feedbackCard(
            name: "Meena Shinde",
            ward: "Kavathemahankal",
            message:
            "Street lights not functioning properly in main market area.",
            date: "04 Oct 2025",
            sentiment: "Concern",
            color: Colors.orange.shade50,
          ),
          _feedbackCard(
            name: "Suresh Jadhav",
            ward: "Palus",
            message:
            "Anganwadi centre staff are very cooperative and punctual. Great service.",
            date: "03 Oct 2025",
            sentiment: "Positive",
            color: Colors.blue.shade50,
          ),
        ],
      ),
    );
  }

  Widget _feedbackCard({
    required String name,
    required String ward,
    required String message,
    required String date,
    required String sentiment,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: color,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade100,
          child: const Icon(Icons.person, color: Colors.indigo),
        ),
        title: Text(
          name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ward: $ward",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              sentiment,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: sentiment == "Positive"
                    ? Colors.green
                    : sentiment == "Concern"
                    ? Colors.orange
                    : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
