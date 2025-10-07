import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/ekatmik_balvikas_yojna_dashboard/widgets/ekatmik_balvikas_yojna_sidebar.dart';

import '../../../../core/widgets/breakpoint.dart';
import '../../../../core/widgets/dashboard_content.dart';
import '../../../../core/widgets/sidebar.dart';
import '../../../../core/widgets/topbar.dart';
import '../widgets/public_dashboard_content.dart';
import '../widgets/public_sidebar.dart';
import '../widgets/public_topbar.dart';

/// ---------------------------------------------------------------------------
/// Main Dashboard Page
/// Detects screen size and shows Desktop/Tablet/Mobile layout accordingly
/// ---------------------------------------------------------------------------
class PublicDashboardPage extends StatelessWidget {
  const PublicDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= Breakpoints.desktop) {
          return const PublicDesktopDashboard();
        } else if (width >= Breakpoints.tablet) {
          return const PublicTabletDashboard();
        } else {
          return const PublicMobileDashboard();
        }
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// DESKTOP LAYOUT
/// Sidebar (expanded) + TopBar + DashboardContent
/// ---------------------------------------------------------------------------
class PublicDesktopDashboard extends StatefulWidget {
  const PublicDesktopDashboard({super.key});

  @override
  State<PublicDesktopDashboard> createState() =>
      _PublicDesktopDashboardState();
}

class _PublicDesktopDashboardState
    extends State<PublicDesktopDashboard> {
  String selectedMenu = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Row(
          children: [
            /// Sidebar (fixed width)
            SizedBox(
              width: 260,
              child: PublicSidebar(
                selected: selectedMenu,
                onItemSelected: (item) {
                  setState(() => selectedMenu = item);
                },
              ),
            ),

            /// Main content area
            Expanded(
              child: Column(
                children: [
                  const PublicTopBar(),
                  Expanded(
                    child: PublicDashboardContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Switch content based on menu selection
  Widget _buildContent(String selected) {
    switch (selected) {
      case "Reports":
        return const PublicDashboardContent();
      case "Beneficiaries":
        return const PublicDashboardContent();
      case "Alerts":
        return const Center(child: Text("⚠️ Alerts Page"));
      case "Settings":
        return const Center(child: Text("⚙️ Settings Page"));
      default:
        return const PublicDashboardContent();
    }
  }
}

/// ---------------------------------------------------------------------------
/// TABLET LAYOUT
/// Sidebar (minimal) + TopBar + DashboardContent
/// ---------------------------------------------------------------------------
class PublicTabletDashboard extends StatefulWidget {
  const PublicTabletDashboard({super.key});

  @override
  State<PublicTabletDashboard> createState() =>
      _PublicTabletDashboardState();
}

class _PublicTabletDashboardState
    extends State<PublicTabletDashboard> {
  String selectedMenu = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            const PublicTopBar(),
            Expanded(
              child: Row(
                children: [
                  /// Sidebar (minimal width)
                  SizedBox(
                    width: 88,
                    child: PublicSidebar(
                      minimal: true,
                      selected: selectedMenu,
                      onItemSelected: (item) {
                        setState(() => selectedMenu = item);
                      },
                    ),
                  ),

                  /// Content
                  Expanded(
                    child: PublicDashboardContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(String selected) {
    switch (selected) {
      case "Reports":
        return const Center(child: Text("📑 Reports Page (Tablet)"));
      case "Beneficiaries":
        return const Center(child: Text("👥 Beneficiaries Page (Tablet)"));
      case "Alerts":
        return const Center(child: Text("⚠️ Alerts Page (Tablet)"));
      case "Settings":
        return const Center(child: Text("⚙️ Settings Page (Tablet)"));
      default:
        return const PublicDashboardContent();
    }
  }
}

/// ---------------------------------------------------------------------------
/// MOBILE LAYOUT
/// AppBar + Drawer + Scrollable DashboardContent
/// ---------------------------------------------------------------------------
class PublicMobileDashboard extends StatefulWidget {
  const PublicMobileDashboard({super.key});

  @override
  State<PublicMobileDashboard> createState() =>
      _PublicMobileDashboardState();
}

class _PublicMobileDashboardState
    extends State<PublicMobileDashboard> {
  String selectedMenu = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      /// Mobile-friendly top AppBar
      appBar: AppBar(
        title: const Text('Public Dashboard'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),

      /// Drawer for Sidebar
      drawer: Drawer(
        child: PublicSidebar(
          minimal: false,
          selected: selectedMenu,
          onItemSelected: (item) {
            setState(() => selectedMenu = item);
            Navigator.pop(context); // close drawer
          },
        ),
      ),

      /// Body (scrollable content)
      body: SafeArea(
        child: SingleChildScrollView(
          child: _buildContent(selectedMenu, mobile: true),
        ),
      ),
    );
  }

  Widget _buildContent(String selected, {bool mobile = false}) {
    switch (selected) {
      case "Reports":
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("📑 Reports Page (Mobile)"),
        );
      case "Beneficiaries":
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("👥 Beneficiaries Page (Mobile)"),
        );
      case "Alerts":
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("⚠️ Alerts Page (Mobile)"),
        );
      case "Settings":
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("⚙️ Settings Page (Mobile)"),
        );
      default:
        return PublicDashboardContent(mobile: mobile);
    }
  }
}
