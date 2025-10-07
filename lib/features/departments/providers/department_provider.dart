import 'package:flutter/material.dart';
import '../../auth/provider/auth_provider.dart';
import '../model/departments_model.dart';
import '../repository/departments_repository.dart';

class DepartmentProvider extends ChangeNotifier {
  final DepartmentRepository repository;
  final AuthProvider authProvider; // inject auth provider

  DepartmentProvider({
    required this.repository,
    required this.authProvider,
  });

  List<Department> _departments = [];
  bool _loading = false;
  String? _error;

  List<Department> get departments => _departments;
  bool get loading => _loading;
  String? get error => _error;

  /// ---------------- LOAD DEPARTMENTS ----------------
  Future<void> loadDepartments() async {
    _loading = true;
    _error = null;
    notifyListeners();

    String? token = authProvider.token;

    if (token == null || token.isEmpty) {
      final refreshed = await authProvider.refreshTokenIfNeeded();
      if (!refreshed) {
        _error = "Authentication failed. Please login again.";
        _loading = false;
        notifyListeners();
        return;
      }
      token = authProvider.token;
    }

    try {
      _departments = await repository.fetchDepartments(token!);
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }
}
