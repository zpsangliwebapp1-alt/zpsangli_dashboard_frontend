import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/widgets/ceoSidebar.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/widgets/ceo_dashboard_content.dart';
import '../../../../core/widgets/breakpoint.dart';
import '../../../../core/widgets/dashboard_content.dart';
import '../../../../core/widgets/sidebar.dart';
import '../../../../core/widgets/topbar.dart';
import '../../../../main.dart';
import '../../BDO_dashboard/widgets/Bdo_dashboard_content.dart';
import '../../ceo_dashboard/widgets/ceo_topbar.dart';

/// Top-level dashboard scaffold (entry point)
class CeoDashboardPage extends StatefulWidget {
  const CeoDashboardPage({super.key});

  @override
  State<CeoDashboardPage> createState() => _CeoDashboardPageState();
}

class _CeoDashboardPageState extends State<CeoDashboardPage> {
  int _selectedIndex = 0;

  void _onItemSelected(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final double sidebarWidth = width < 600 ? 80 : (width < 1024 ? 100 : 260);

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: sidebarWidth,
              child: CeoSidebar(
                selectedIndex: _selectedIndex,
                onItemSelected: _onItemSelected,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const CeoTopBar(),
                  Expanded(
                    child: _getSelectedContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSelectedContent() {
    switch (_selectedIndex) {
      case 0:
        return CeoDashboardContent();
      case 1:
        return const Center(child: Text("Reports Screen"));
      case 2:
        return const Center(child: Text("Analytics Screen"));
      default:
        return const Center(child: Text("Coming Soon..."));
    }
  }
}


/////////////// DESKTOP LAYOUT ///////////////
class CeoDashboardDesktopDashboard extends StatefulWidget {
  const CeoDashboardDesktopDashboard({super.key});

  @override
  State<CeoDashboardDesktopDashboard> createState() => _CeoDashboardDesktopDashboardState();
}

class _CeoDashboardDesktopDashboardState extends State<CeoDashboardDesktopDashboard> {
  int _selectedIndex = 0;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 260,
              child: CeoSidebar(
                selectedIndex: _selectedIndex, // 🔹 pass current index
                onItemSelected: _onItemSelected,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const CeoTopBar(),
                  Expanded(
                    child: _getSelectedContent(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getSelectedContent() {
    switch (_selectedIndex) {
      case 0:
        return  CeoDashboardContent(); // 👉 default dashboard
      case 1:
        return const Center(child: Text("Reports Screen"));
      case 2:
        return const Center(child: Text("Analytics Screen"));
      default:
        return const Center(child: Text("Coming Soon..."));
    }
  }}

/////////////// TABLET LAYOUT ///////////////
class CeoDashboardTabletDashboard extends StatelessWidget {
  const CeoDashboardTabletDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CeoTopBar(),
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: 88, child: CeoSidebar(onItemSelected: (int value) {  },)),
                   Expanded(child: CeoDashboardContent()),
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
class CeoDashboardMobileDashboard extends StatelessWidget {
  const CeoDashboardMobileDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // For mobile we show a top nav + single-column scrollable content
    return Scaffold(
      appBar: AppBar(
        title: const Text('CEO'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.score)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
      ),
      drawer: Drawer(child: CeoSidebar(onItemSelected: (int value) {  },)), // collapsible drawer on mobile
      body: const SafeArea(child: SingleChildScrollView(child: DashboardContent())),
    );
  }
}