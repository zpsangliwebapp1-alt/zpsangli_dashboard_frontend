import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 📦 Dashboards
import 'package:zp_sangali_dashboard_flutter/features/all_roles/additional_Ceo_dashboard/presentation/additional_dashboard_page.dart';
import '../../../all_roles/BDO_dashboard/presentation/bdo_dashboard_page.dart';
import '../../../all_roles/CEO_dashboard/presentation/ceo_dashboard_page.dart';
import '../../../all_roles/department_User_dashboard/presentation/bdo_dashboard_screen.dart';
import '../../../all_roles/department_dashboard/presentation/bdo_dashboard_screen.dart';
import '../../../all_roles/ekatmik_balvikas_yojna_dashboard/presentation/ekatmik_balvikas_yojna_dashboard_page.dart';
import '../../../all_roles/public_dashboard/presentation/public_dashboard_page.dart';

// 📦 Core + Auth
import '../../../../core/constants/role_ids.dart';
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
    Future.microtask(initAuth); // ✅ avoid build-blocking
  }

  Future<void> initAuth() async {
    final authProv = context.read<AuthProvider>();
    await authProv.tryAutoLogin();
    if (!mounted) return;
    setState(() => _checking = false);
  }

  // 🔹 Define role-based routes in one map
  final Map<int, Widget> roleRoutes = {
    RoleIds.ceo: const CeoDashboardPage(),
    RoleIds.bdo: const BdoHomeLayout(),
    RoleIds.department: const DepartmentDashboardScreen(),
    RoleIds.departmentUser: const DepartmentUserDashboardScreen(),
    RoleIds.additionalCeo: const CeoDashboardPage(),
    RoleIds.publicUser: const PublicDashboardPage(),
  };

  /// ✅ Returns dashboard based on roleId using map-based lookup
  Widget _buildPageForRole(AuthProvider authProv) {
    if (!authProv.isAuthenticated) {
      return const LoginPage();
    }

    return roleRoutes[authProv.roleId] ?? const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    // 🌀 Show loader while checking auth state
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final authProv = context.watch<AuthProvider>();
    return _buildPageForRole(authProv);
  }
}
