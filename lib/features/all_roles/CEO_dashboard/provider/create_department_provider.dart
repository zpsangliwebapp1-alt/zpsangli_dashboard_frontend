import 'package:flutter/foundation.dart';
import '../models/create_department.dart';
import '../repository/create_department_repository.dart';

class CreateDepartmentProvider extends ChangeNotifier {
  final CreateDepartmentRepository repository;

  CreateDepartmentProvider({required this.repository});

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  CreateDepartment? _createdDepartment;
  CreateDepartment? get createdDepartment => _createdDepartment;
  Future<void> createDepartment({
    required String name,
    required int bdoId,
    required int additionalCeoUserId,
    required String token,
  }) async {
    _loading = true;
    _error = null;
    _createdDepartment = null;
    notifyListeners();

    try {
      final department = await repository.createDepartment(
        name: name,
        bdoId: bdoId,
        additionalCeoUserId: additionalCeoUserId,
        token: token,
      );
      _createdDepartment = department;
    } catch (e) {
      _error = e.toString();
      // ✅ Print the error to console
      debugPrint('❌ Error creating department: $_error');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

}
