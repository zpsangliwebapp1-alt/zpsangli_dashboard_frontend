import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../core/di/injection.dart' as di;
import '../providers/auth_provider.dart';

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
    return authProv.isAuthenticated
        ? const LoginPage()
        : const LoginPage();
  }
}

