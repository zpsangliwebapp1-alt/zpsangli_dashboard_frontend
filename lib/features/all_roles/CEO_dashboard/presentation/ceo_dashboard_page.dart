import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/BDO_dashboard/presentation/schemes_screen.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/presentation/complaint_form_screen.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/presentation/notification_ceo.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/presentation/scheme_form_screen.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/presentation/uploaded_file_list_screen.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/widgets/ceoSidebar.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/widgets/excel_upload_button.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/additional_Ceo_dashboard/presentation/additional_ceo_screen.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/widgets/dashboard_content.dart';
import '../../../auth/presentation/pages/registration_screen.dart';
import '../../ceo_dashboard/controller/ceo_dashboard_controller.dart';
import '../../ceo_dashboard/presentation/create_user.dart';
import '../../ceo_dashboard/widgets/ceo_topbar.dart';
import '../provider/create_bdo_provider.dart';
import '../repository/create_bdo_repository.dart';
import 'broadcast_screen.dart';
import 'ceo_dashboard_content.dart';
import 'complaint_list_screen.dart';
/// Top-level dashboard scaffold (entry point)
class CeoDashboardPage extends StatefulWidget {
  const CeoDashboardPage({super.key});

  @override
  State<CeoDashboardPage> createState() => _CeoDashboardPageState();
}

class _CeoDashboardPageState extends State<CeoDashboardPage> {
  int _selectedIndex = 0;

  void _onItemSelected(int index) => setState(() => _selectedIndex = index);

  // @override
  // void initState() {
  //   super.initState();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<CeoDashboardController>().init();
  //     });
  // }


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
        return const UploadedFileListScreen();
      case 2:
        return const AnnouncementDashboardScreen();
      case 3:
        return  CreateAccountScreen();
      case 4:
        return ComplaintScreen();
      case 5:
        return SchemeFormScreen();
      case 6:
        return NotificationScreen();
      default:
        return const Center(child: ExcelUploadButton());
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
        return Container();
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


