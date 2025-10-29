import 'package:flutter/foundation.dart';
import '../data/models/role_model.dart';

class RoleProvider extends ChangeNotifier {
  List<RoleModel> _roles = [];
  List<RoleModel> get roles => _roles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Example: fetch roles from backend or define locally
  Future<void> fetchRoles() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Option 1: Fetch from backend
      // final response = await roleRepository.getRoles();
      // _roles = response;

      // Option 2: Static local roles
      _roles = [
        RoleModel(id: 1, name: 'CEO'),
        RoleModel(id: 2, name: 'BDO'),
        RoleModel(id: 3, name: 'Department'),
        RoleModel(id: 4, name: 'Department User'),
        RoleModel(id: 5, name: 'Additional CEO'),
        RoleModel(id: 6, name: 'Public User'),
      ];
    } catch (e) {
      debugPrint('Failed to fetch roles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
