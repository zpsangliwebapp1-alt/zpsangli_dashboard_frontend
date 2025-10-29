import 'package:flutter/foundation.dart';
import '../repository/create_bdo_repository.dart';

class CreateBdoProvider extends ChangeNotifier {
  final CreateBdoRepository repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _bdoResponse;
  Map<String, dynamic>? get bdoResponse => _bdoResponse;

  CreateBdoProvider({required this.repository});

  Future<void> createBdo(String name, int ceoUserId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await repository.createBdo(name: name, ceoUserId: ceoUserId);
      _bdoResponse = data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _errorMessage = null;
    _bdoResponse = null;
    notifyListeners();
  }
}
