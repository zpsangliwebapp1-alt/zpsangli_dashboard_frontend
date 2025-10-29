// lib/ui/screens/ceo_dashboard.dart
import 'package:flutter/material.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/BDO_dashboard/presentation/complaints_screen.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/widgets/sidebat_items/panchayat_samiti_content.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/widgets/sidebat_items/reports_content.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/widgets/sidebat_items/setting_content.dart';
import '../../../../../core/widgets/dashboard_content.dart';
import '../../../BDO_dashboard/widgets/Bdo_dashboard_content.dart';
import '../../../additional_Ceo_dashboard/presentation/additional_ceo_screen.dart';
import '../../../ceo_dashboard/presentation/broadcast_screen.dart';
import '../../../ceo_dashboard/presentation/complaint_list_screen.dart';
import '../../../ceo_dashboard/presentation/create_user.dart';
import '../../../ceo_dashboard/widgets/ceoSidebar.dart';

import '../../../ceo_dashboard/widgets/ceo_topbar.dart';
import '../../presentation/ceo_dashboard_content.dart';
import '../../presentation/uploaded_file_list_screen.dart';
import '../excel_upload_button.dart';
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
        return CeoDashboardContent();
      case 1:
      // return  RegistrationScreen();
        return  CreateAccountScreen();
      case 2:
        return const AnnouncementScreen();

      case 3:
        return const UploadedFileListScreen();
      case 4:
        return  AdditionalCeoListScreen();
      case 5:
        return  ComplaintsScreen();
      default:
        return Center(child: const ExcelUploadButton());
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
