import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../models/upload_file_model.dart';
import '../repository/upload_file_repository.dart';

class UploadFileProvider extends ChangeNotifier {
  final UploadFileRepository repository;

  UploadFileProvider({required this.repository});

  bool _isLoading = false;
  UploadFileResponse? _uploadResponse;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  UploadFileResponse? get uploadResponse => _uploadResponse;
  String? get errorMessage => _errorMessage;

  Future<void> uploadFile({
    required Uint8List fileBytes,
    required String fileName,
    required int departmentId,
    required int bdoId,
    required int month,
    required int year,
    required String token,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.uploadExcelFile(
        fileBytes: fileBytes,
        fileName: fileName,
        departmentId: departmentId,
        bdoId: bdoId,
        month: month,
        year: year,
        token: token,
      );
      _uploadResponse = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
