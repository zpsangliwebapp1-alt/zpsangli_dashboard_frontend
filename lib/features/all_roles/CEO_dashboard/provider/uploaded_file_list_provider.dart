// provider/uploaded_file_provider.dart
import 'package:flutter/material.dart';
import '../models/uploaded_file_list_model.dart';
import '../repository/uploaded_file_list_repository.dart';

class UploadedFileProvider extends ChangeNotifier {
  final UploadedFileRepository repository;

  UploadedFileProvider({required this.repository});

  bool _isLoading = false;
  List<UploadedFile> _files = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<UploadedFile> get files => _files;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUploadedFiles({
    required int departmentId,
    required int bdoId,
    required int month,
    required int year,
    required int uploadedByUserId,
    required String token,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _files = await repository.getUploadedFiles(
        departmentId: departmentId,
        bdoId: bdoId,
        month: month,
        year: year,
        uploadedByUserId: uploadedByUserId,
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
