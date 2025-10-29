import 'package:flutter/material.dart';
import '../models/broadcast_model.dart';
import '../repository/broadcaste_repository.dart';

class PublicBroadcastProvider with ChangeNotifier {
  final PublicBroadcastRepository repository;

  PublicBroadcastProvider({required this.repository});

  bool _isLoading = false;
  List<PublicBroadcastModel> _broadcasts = [];

  bool get isLoading => _isLoading;
  List<PublicBroadcastModel> get broadcasts => _broadcasts;

  Future<void> getBroadcasts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _broadcasts = await repository.fetchActiveBroadcasts();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
