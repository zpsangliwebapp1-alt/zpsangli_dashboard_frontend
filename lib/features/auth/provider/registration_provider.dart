import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../data/models/registration_request.dart';
import '../data/models/registration_response.dart';
import '../data/repositories/registration_repository.dart';

class RegistrationProvider extends ChangeNotifier {
  final RegistrationRepository repository;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RegistrationResponse? _registrationResponse;
  RegistrationResponse? get registrationResponse => _registrationResponse;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  RegistrationProvider({required this.repository});

  Future<void> registerUser({
    required RegistrationRequest request,
    required String token,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _registrationResponse = await repository.registerUser(
        request: request,
        token: token,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
