import 'package:flutter/foundation.dart';
import '../repository/bdo_user_repository.dart';

class CreateUserProvider extends ChangeNotifier {
  final CreateUserRepository repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _userResponse;
  Map<String, dynamic>? get userResponse => _userResponse;

  CreateUserProvider({required this.repository});

  Future<void> createUser({
    required String username,
    required String password,
    required int bdoId,
    required int parentCeoId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await repository.createUser(
        username: username,
        password: password,
        bdoId: bdoId,
        parentCeoId: parentCeoId,
      );
      _userResponse = data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
