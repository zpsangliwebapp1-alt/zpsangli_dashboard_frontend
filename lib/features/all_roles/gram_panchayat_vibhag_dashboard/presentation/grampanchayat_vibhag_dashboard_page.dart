import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/breakpoint.dart';
import '../../../../core/widgets/dashboard_content.dart';
import '../../../../core/widgets/sidebar.dart';
import '../../../../core/widgets/topbar.dart';
import '../../../../main.dart';

/// Top-level dashboard scaffold (entry point)
class GramPanchayatVibhagDashboardPage extends StatelessWidget {
  const GramPanchayatVibhagDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;

      if (width >= Breakpoints.desktop) {
        return const GramPanchayatVibhagDesktopDashboard();
      } else if (width >= Breakpoints.tablet) {
        return const GramPanchayatVibhagTabletDashboard();
      } else {
        return const GramPanchayatVibhagMobileDashboard();
      }
    });
  }
}

/////////////// DESKTOP LAYOUT ///////////////
class GramPanchayatVibhagDesktopDashboard extends StatelessWidget {
  const GramPanchayatVibhagDesktopDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We keep the page background subtle like the screenshot
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar - fixed width
            const SizedBox(width: 260, child: Sidebar()),
            // Main content
            Expanded(
              child: Column(
                children: const [
                  TopBar(),
                  Expanded(child: DashboardContent()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/////////////// TABLET LAYOUT ///////////////
class GramPanchayatVibhagTabletDashboard extends StatelessWidget {
  const GramPanchayatVibhagTabletDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            TopBar(),
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: 88, child: Sidebar(minimal: true)),
                  Expanded(child: DashboardContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/////////////// MOBILE LAYOUT ///////////////
class GramPanchayatVibhagMobileDashboard extends StatelessWidget {
  const GramPanchayatVibhagMobileDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // For mobile we show a top nav + single-column scrollable content
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dabang'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
      ),
      drawer: const Drawer(child: Sidebar()), // collapsible drawer on mobile
      body: const SafeArea(child: SingleChildScrollView(child: DashboardContent(mobile: true))),
    );
  }
}