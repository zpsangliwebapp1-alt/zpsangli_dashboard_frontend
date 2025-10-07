import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/dashboard_content.dart';
import '../../../../core/widgets/sidebar.dart';

import '../widgets/sidebar.dart';
import '../widgets/topbar.dart';
import 'additional_ceo_dashboard_content.dart';
import 'schemes_screen.dart';
import 'progress_reports_screen.dart';
import 'departments_screen.dart';
import 'finance_screen.dart';
import 'feedback_screen.dart';
import 'complaints_screen.dart';
import 'staff_directory_screen.dart';
import 'settings_screen.dart';

class AdditionalCeoHomeLayout extends StatefulWidget {
  const AdditionalCeoHomeLayout({super.key});

  @override
  State<AdditionalCeoHomeLayout> createState() => _AdditionalCeoHomeLayoutState();
}

class _AdditionalCeoHomeLayoutState extends State<AdditionalCeoHomeLayout> {
  String _activeRoute = 'dashboard';

  Widget _getScreen() {
    switch (_activeRoute) {
      case 'schemes':
        return const AdditionalCeoSchemesScreen();
      case 'progress':
        return const AdditionalCeoProgressReportsScreen();
      case 'departments':
        return const Additional_ceo_DepartmentsScreen();
      case 'finance':
        return const AdditionalCeoFinanceScreen();
      case 'feedback':
        return const AdditionalCeoFeedbackScreen();
      case 'complaints':
        return const AdditionalCeoComplaintsScreen();
      case 'staff':
        return const AdditinalCeoStaffDirectoryScreen();
      case 'settings':
        return const AdditionalScreenSettingsScreen();
      default:
        return const AdditionalCeoDashboardContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AdditionalCeoSidebar(
            activeRoute: _activeRoute,
            onItemSelected: (route) {
              setState(() => _activeRoute = route);
            },
          ),
          // Main content with topbar
          Expanded(
            child: Column(
              children: [
                // 🔹 Additional Ceo TopBar
                const AdditionalCeoTopBar(),

                // 🔹 Main screen content
                Expanded(
                  child: Container(
                    color: const Color(0xFFF8F9FB),
                    padding: const EdgeInsets.all(20),
                    child: _getScreen(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
