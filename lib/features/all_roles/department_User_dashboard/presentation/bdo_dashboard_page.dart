import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/dashboard_content.dart';
import '../../../../core/widgets/sidebar.dart';
import '../../CEO_dashboard/presentation/uploaded_file_list_screen.dart';
import '../widgets/bdo_topbar.dart'; // import your topbar

import 'schemes_screen.dart';
import 'progress_reports_screen.dart';
import 'departments_screen.dart';
import 'finance_screen.dart';
import 'feedback_screen.dart';
import 'complaints_screen.dart';
import 'staff_directory_screen.dart';
import 'settings_screen.dart';

class BdoHomeLayout extends StatefulWidget {
  const BdoHomeLayout({super.key});

  @override
  State<BdoHomeLayout> createState() => _BdoHomeLayoutState();
}

class _BdoHomeLayoutState extends State<BdoHomeLayout> {
  String _activeRoute = 'dashboard';

  Widget _getScreen() {
    switch (_activeRoute) {
      case 'schemes':
        return const UploadedFileListScreen();
      case 'progress':
        return const ProgressReportsScreen();
      case 'departments':
        return const DepartmentsScreen();
      case 'finance':
        return const FinanceScreen();
      case 'feedback':
        return const FeedbackScreen();
      case 'complaints':
        return const ComplaintsScreen();
      case 'staff':
        return const StaffDirectoryScreen();
      case 'settings':
        return const SettingsScreen();
      default:
        return const DashboardContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          BdoSidebar(
            activeRoute: _activeRoute,
            onItemSelected: (route) {
              setState(() => _activeRoute = route);
            },
          ),
          // Main content with topbar
          Expanded(
            child: Column(
              children: [
                // 🔹 BDO TopBar
                const BdoTopBar(),

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
