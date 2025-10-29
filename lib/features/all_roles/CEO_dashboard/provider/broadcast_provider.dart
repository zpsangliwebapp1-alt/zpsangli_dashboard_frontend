import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/broadcast_model.dart';
import '../models/brodcaste_model.dart';
import '../repository/broadcaste_repository.dart';

class BroadcastProvider extends ChangeNotifier {
  final BroadcastRepository repository;

  BroadcastProvider({required this.repository});

  List<BroadcastModel> _broadcasts = [];
  bool _loading = false;
  bool get loading => _loading;
  List<BroadcastModel> get broadcasts => _broadcasts; // ✅ <-- Add this getter


  String? _error;
  String? get error => _error;

  Broadcast? _broadcast;
  Broadcast? get broadcast => _broadcast;

  Future<void> sendBroadcast({
    Uint8List? imageBytes,
    String? imageName,
    File? imageFile,
    required String messageText,
    required String expiresAt,
    // required String category, // ✅
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
        // category: category, // ✅
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

  Future<void> sendLink({
    required String messageText,
    required String linkUrl,
    required String expiresAt,
    // required String category, // ✅
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
        // category: category, // ✅
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





  // /// Text + Link
  // Future<void> sendLink({
  //   required String messageText,
  //   required String linkUrl,
  //   required String expiresAt,
  //   required String token,
  // }) async {
  //   _loading = true;
  //   _error = null;
  //   _broadcast = null;
  //   notifyListeners();
  //
  //   try {
  //     final result = await repository.sendTextLink(
  //       messageText: messageText,
  //       linkUrl: linkUrl,
  //       expiresAt: expiresAt,
  //       token: token,
  //     );
  //     _broadcast = result;
  //   } catch (e) {
  //     _error = e.toString();
  //   } finally {
  //     _loading = false;
  //     notifyListeners();
  //   }
  // }

  List<BroadcastModel> filterByCategory(String category) {
    return _broadcasts.where((b) => b.messageText == category).toList();
  }


  Future<void> loadBroadcasts() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _broadcasts = await repository.fetchActiveBroadcasts();

      // 🔹 Print full data for debugging
      for (var b in _broadcasts) {
        debugPrint(jsonEncode({
          'id': b.id,
          'type': b.type,
          'messageText': b.messageText,
          'imageUrl': b.imageUrl,
          'imageOriginalFileName': b.imageOriginalFileName,
          'imageContentType': b.imageContentType,
          'imageSizeBytes': b.imageSizeBytes,
          'linkUrl': b.linkUrl,
          'createdBy': b.createdBy,
          'expiresAt': b.expiresAt?.toIso8601String(),
          'createdAt': b.createdAt.toIso8601String(),
          'isApproved': b.isApproved,
        }));
      }

    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
