import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/ekatmik_balvikas_yojna_dashboard/widgets/ekatmik_balvikas_yojna_sidebar.dart';

import '../../../../core/widgets/breakpoint.dart';
import '../../../../core/widgets/dashboard_content.dart';
import '../../../../core/widgets/sidebar.dart';
import '../../../../core/widgets/topbar.dart';
import '../../CEO_dashboard/widgets/ceo_topbar.dart';
import '../widgets/ekatmik_balvikas_dashboard_content.dart';
import '../widgets/topbar.dart';

/// ---------------------------------------------------------------------------
/// Main Dashboard Page
/// Detects screen size and shows Desktop/Tablet/Mobile layout accordingly
/// ---------------------------------------------------------------------------
class EkatmikBalvikasYojnaDashboardPage extends StatelessWidget {
  const EkatmikBalvikasYojnaDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= Breakpoints.desktop) {
          return const EkatmikBalvikasYojnaDesktopDashboard();
        } else if (width >= Breakpoints.tablet) {
          return const EkatmikBalvikasYojnaTabletDashboard();
        } else {
          return const EkatmikBalvikasYojnaMobileDashboard();
        }
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// DESKTOP LAYOUT
/// Sidebar (expanded) + TopBar + DashboardContent
/// ---------------------------------------------------------------------------
class EkatmikBalvikasYojnaDesktopDashboard extends StatefulWidget {
  const EkatmikBalvikasYojnaDesktopDashboard({super.key});

  @override
  State<EkatmikBalvikasYojnaDesktopDashboard> createState() =>
      _EkatmikBalvikasYojnaDesktopDashboardState();
}

class _EkatmikBalvikasYojnaDesktopDashboardState
    extends State<EkatmikBalvikasYojnaDesktopDashboard> {
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
              child: EkatmikBalvikasYojnaSidebar(
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
                  const CeoTopBar(),
                  Expanded(
                    child: _buildContent(selectedMenu),
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
        return const Center(child: Text("📑 Reports Page"));
      case "Beneficiaries":
        return const Center(child: Text("👥 Beneficiaries Page"));
      case "Alerts":
        return const Center(child: Text("⚠️ Alerts Page"));
      case "Settings":
        return const Center(child: Text("⚙️ Settings Page"));
      default:
        return const EkatmikBalvikasDashboardContent();
    }
  }
}

/// ---------------------------------------------------------------------------
/// TABLET LAYOUT
/// Sidebar (minimal) + TopBar + DashboardContent
/// ---------------------------------------------------------------------------
class EkatmikBalvikasYojnaTabletDashboard extends StatefulWidget {
  const EkatmikBalvikasYojnaTabletDashboard({super.key});

  @override
  State<EkatmikBalvikasYojnaTabletDashboard> createState() =>
      _EkatmikBalvikasYojnaTabletDashboardState();
}

class _EkatmikBalvikasYojnaTabletDashboardState
    extends State<EkatmikBalvikasYojnaTabletDashboard> {
  String selectedMenu = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            const CeoTopBar(),
            Expanded(
              child: Row(
                children: [
                  /// Sidebar (minimal width)
                  SizedBox(
                    width: 88,
                    child: EkatmikBalvikasYojnaSidebar(
                      minimal: true,
                      selected: selectedMenu,
                      onItemSelected: (item) {
                        setState(() => selectedMenu = item);
                      },
                    ),
                  ),

                  /// Content
                  Expanded(
                    child: _buildContent(selectedMenu),
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
        return const EkatmikBalvikasDashboardContent();
    }
  }
}

/// ---------------------------------------------------------------------------
/// MOBILE LAYOUT
/// AppBar + Drawer + Scrollable DashboardContent
/// ---------------------------------------------------------------------------
class EkatmikBalvikasYojnaMobileDashboard extends StatefulWidget {
  const EkatmikBalvikasYojnaMobileDashboard({super.key});

  @override
  State<EkatmikBalvikasYojnaMobileDashboard> createState() =>
      _EkatmikBalvikasYojnaMobileDashboardState();
}

class _EkatmikBalvikasYojnaMobileDashboardState
    extends State<EkatmikBalvikasYojnaMobileDashboard> {
  String selectedMenu = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      /// Mobile-friendly top AppBar
      appBar: AppBar(
        title: const Text('Ekatmik Balvikas Yojna'),
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
        child: EkatmikBalvikasYojnaSidebar(
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
        return EkatmikBalvikasDashboardContent(mobile: mobile);
    }
  }
}
