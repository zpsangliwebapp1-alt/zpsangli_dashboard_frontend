import 'package:flutter/material.dart';
import '../repository/bdo_list_repository.dart';

class BdoListProvider extends ChangeNotifier {
  final BdoListRepository repository;

  BdoListProvider({required this.repository});

  bool isLoading = false;
  String? errorMessage;
  List<Map<String, dynamic>> _bdoList = [];

  List<Map<String, dynamic>> get bdoList => _bdoList;

  Future<void> fetchBdos() async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await repository.fetchBdos();
      _bdoList = result;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      _bdoList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
