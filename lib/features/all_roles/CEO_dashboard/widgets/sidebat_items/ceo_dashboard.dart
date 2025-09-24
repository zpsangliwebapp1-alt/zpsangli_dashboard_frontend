// lib/ui/screens/ceo_dashboard.dart
import 'package:flutter/material.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/widgets/sidebat_items/panchayat_samiti_content.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/widgets/sidebat_items/reports_content.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/widgets/sidebat_items/setting_content.dart';
import '../../../../../core/widgets/dashboard_content.dart';
import '../../../BDO_dashboard/widgets/Bdo_dashboard_content.dart';
import '../../../ceo_dashboard/widgets/ceoSidebar.dart';

import '../../../ceo_dashboard/widgets/ceo_topbar.dart';
import '../ceo_dashboard_content.dart';
import 'ceo_dashboard_content.dart';
import 'finance_content.dart';
import 'gramvikas_adhikari_content.dart';
import 'logout_content.dart';
import 'notification_content.dart';

class CeoDashboard extends StatefulWidget {
  const CeoDashboard({super.key});

  @override
  State<CeoDashboard> createState() => _CeoDashboardState();
}

class _CeoDashboardState extends State<CeoDashboard> {
  int _selectedIndex = 0;

  Widget _getContent() {
    switch (_selectedIndex) {
      case 0:
        return const CeoDashboardContent();
      case 1:
        return const CeoDashboardContent();
      case 2:
        return const PanchayatSamitiContent();
      case 3:
        return const GramVikasAdhikariContent();
      case 4:
        return const ReportsContent();
      case 5:
        return const FinanceContent();
      case 6:
        return const NotificationsContent();
      case 7:
        return const SettingsContent();
      case 8:
        return const LogoutContent();
      default:
        return const CeoDashboardContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ✅ Sidebar (already handles onTap)
        CeoSidebar(onItemSelected: (int value) {  },),
        // ✅ Topbar stays same, only body changes
        Expanded(
          child: Column(
            children: [
              const CeoTopBar(),
              Expanded(child: _getContent()),
            ],
          ),
        ),
      ],
    );
  }
}
