// lib/ui/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/section_page.dart'; // adjust path if needed

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: "Settings",
      icon: Icons.settings_rounded,
      subtitle: "App preferences, notifications & user settings",
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 1,
            child: ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: Text("Theme", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text("Light / Dark / System", style: GoogleFonts.poppins(fontSize: 13)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 1,
            child: ListTile(
              leading: const Icon(Icons.notifications_active_outlined),
              title: Text("Notifications", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text("Manage notifications & alerts", style: GoogleFonts.poppins(fontSize: 13)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 1,
            child: ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text("Privacy & Security", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text("Access control, data policy", style: GoogleFonts.poppins(fontSize: 13)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 22),
          Text("Account", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 1,
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text("Sign out", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              onTap: () {
                // call logout from provider or navigator logic
              },
            ),
          ),
        ],
      ),
    );
  }
}
