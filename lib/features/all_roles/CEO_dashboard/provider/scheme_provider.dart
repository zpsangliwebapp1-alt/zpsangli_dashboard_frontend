import 'package:flutter/material.dart';
import '../../../auth/provider/auth_provider.dart';
import '../repository/scheme_repository.dart';

enum SchemeStatus { idle, loading, success, error }

class SchemeProvider extends ChangeNotifier {
  final SchemeRepository repository;
  final AuthProvider authProvider;

  SchemeProvider({
    required this.repository,
    required this.authProvider,
  });

  SchemeStatus status = SchemeStatus.idle;
  String message = '';
  List<Map<String, dynamic>> schemeList = [];

  // 🟢 To prevent notifyListeners after dispose
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  /// 🟩 Submit a new scheme
  Future<void> submitScheme({
    required String applicantName,
    required String fatherOrHusbandName,
    required String mobileNumber,
    required String email,
    required String aadhaarNumber,
    required String address,
    required String villageName,
    required String taluka,
    required String district,
    required int age,
    required String gender,
    required String caste,
    required int annualIncome,
    required String schemeName,
    required String purpose,
    required List<String> requiredDocuments,
    required String bankAccountNumber,
    required String ifscCode,
    required bool consentAccepted,
  }) async {
    status = SchemeStatus.loading;
    _safeNotify();

    try {
      final token = authProvider.token;
      if (token == null || token.isEmpty) throw Exception("User not authenticated");

      repository.dioClient.setToken(token);
      await repository.submitSchemeApplication(
        applicantName: applicantName,
        fatherOrHusbandName: fatherOrHusbandName,
        mobileNumber: mobileNumber,
        email: email,
        aadhaarNumber: aadhaarNumber,
        address: address,
        villageName: villageName,
        taluka: taluka,
        district: district,
        age: age,
        gender: gender,
        caste: caste,
        annualIncome: annualIncome,
        schemeName: schemeName,
        purpose: purpose,
        requiredDocuments: requiredDocuments,
        bankAccountNumber: bankAccountNumber,
        ifscCode: ifscCode,
        consentAccepted: consentAccepted,
      );

      message = 'Application submitted successfully';
      status = SchemeStatus.success;
    } catch (e) {
      message = e.toString();
      status = SchemeStatus.error;
    }
    _safeNotify();
  }

  /// 🟦 Fetch all submitted schemes
  Future<void> fetchSchemes() async {
    status = SchemeStatus.loading;
    _safeNotify();

    try {
      final token = authProvider.token;
      if (token == null || token.isEmpty) throw Exception("User not authenticated");

      repository.dioClient.setToken(token);
      final data = await repository.getAllSchemes();
      schemeList = data;

      message = 'Fetched successfully';
      status = SchemeStatus.success;
    } catch (e) {
      message = e.toString();
      status = SchemeStatus.error;
    }
    _safeNotify();
  }
}
