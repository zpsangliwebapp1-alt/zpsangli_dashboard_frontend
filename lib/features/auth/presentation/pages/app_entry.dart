import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/additional_Ceo_dashboard/presentation/additional_dashboard_page.dart';

import '../../../../core/constants/role_ids.dart';
import '../../../../core/di/injection.dart' as di;
import '../../../all_roles/BDO_dashboard/presentation/bdo_dashboard_page.dart';
import '../../../all_roles/CEO_dashboard/presentation/ceo_dashboard_page.dart';
import '../../../all_roles/ekatmik_balvikas_yojna_dashboard/presentation/ekatmik_balvikas_yojna_dashboard_page.dart';
import '../../../all_roles/public_dashboard/presentation/public_dashboard_page.dart';
import '../../provider/auth_provider.dart';

import 'login_page.dart';

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    initAuth();
  }

  Future<void> initAuth() async {
    final authProv = context.read<AuthProvider>();
    await authProv.tryAutoLogin();
    if (mounted) setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final authProv = context.watch<AuthProvider>();

    if (!authProv.isAuthenticated) {
      return const LoginPage();
    }

    // 🔹 Navigate by role if authenticated
    switch (authProv.roleId) {
      case RoleIds.ceo:
        return const CeoDashboardPage();
      case RoleIds.bdo:
        return const BdoHomeLayout();
      case RoleIds.department:
      case RoleIds.departmentUser:
      case RoleIds.additionalCeo:
      return const AdditionalCeoHomeLayout();
      case RoleIds.publicUser:
        return const PublicDashboardPage();
      default:
        return const LoginPage();
    }
  }

}