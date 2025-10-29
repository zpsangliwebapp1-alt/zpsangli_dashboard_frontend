import 'package:flutter/foundation.dart';

import '../models/additional_ceo_list_model.dart';
import '../repository/additional_ceo_list_repository.dart';

class AdditionalCeoListProvider extends ChangeNotifier {
  final AdditionalCeoListRepository _repository;
  AdditionalCeoListProvider(this._repository);

  List<AdditionalCeoListModel> _ceoList = [];
  bool _isLoading = false;
  String? _error;

  List<AdditionalCeoListModel> get ceoList => _ceoList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAdditionalCeoList() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getAdditionalCeoList();
      _ceoList = result;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
