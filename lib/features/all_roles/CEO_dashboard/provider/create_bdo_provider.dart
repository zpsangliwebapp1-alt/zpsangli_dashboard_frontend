import 'package:flutter/foundation.dart';
import '../models/bdo_model.dart';
import '../repository/create_bdo_repository.dart';

class CreateBdoProvider extends ChangeNotifier {
  final BdoRepository repository;

  CreateBdoProvider({required this.repository});

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Bdo? _createdBdo;
  Bdo? get createdBdo => _createdBdo;

  Future<void> createBdo(String name, String token) async {
    _loading = true;
    _error = null;
    _createdBdo = null;
    notifyListeners();

    try {
      final bdo = await repository.createBdo(name: name, token: token);
      _createdBdo = bdo;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
