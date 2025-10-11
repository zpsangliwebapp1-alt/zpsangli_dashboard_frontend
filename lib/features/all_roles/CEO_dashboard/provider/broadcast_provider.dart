import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/brodcaste_model.dart';
import '../repository/broadcaste_repository.dart';

class BroadcastProvider extends ChangeNotifier {
  final BroadcastRepository repository;

  BroadcastProvider({required this.repository});

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Broadcast? _broadcast;
  Broadcast? get broadcast => _broadcast;

  /// Text + Image
  Future<void> sendBroadcast({
    Uint8List? imageBytes,
    String? imageName,
    File? imageFile,
    required String messageText,
    required String expiresAt,
    required String token,
  }) async {
    _loading = true;
    _error = null;
    _broadcast = null;
    notifyListeners();

    try {
      final result = await repository.sendTextImage(
        imageBytes: imageBytes,
        imageName: imageName,
        imageFile: imageFile,
        messageText: messageText,
        expiresAt: expiresAt,
        token: token,
      );
      _broadcast = result;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Text + Link
  Future<void> sendLink({
    required String messageText,
    required String linkUrl,
    required String expiresAt,
    required String token,
  }) async {
    _loading = true;
    _error = null;
    _broadcast = null;
    notifyListeners();

    try {
      final result = await repository.sendTextLink(
        messageText: messageText,
        linkUrl: linkUrl,
        expiresAt: expiresAt,
        token: token,
      );
      _broadcast = result;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
