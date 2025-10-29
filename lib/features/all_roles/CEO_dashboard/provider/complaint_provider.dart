import 'package:flutter/material.dart';
import '../models/complaint_request_model.dart';
import '../models/complaint_response_model.dart';
import '../repository/complaint_repository.dart';

class ComplaintProvider extends ChangeNotifier {
  final ComplaintRepository repository;

  bool _isSubmitting = false;
  bool _isFetching = false;
  ComplaintResponseModel? _response;
  String? _error;
  List<dynamic> _complaints = [];

  ComplaintProvider({required this.repository});

  bool get isSubmitting => _isSubmitting;
  bool get isFetching => _isFetching;
  ComplaintResponseModel? get response => _response;
  String? get error => _error;
  List<dynamic> get complaints => _complaints;

  // Submit complaint
  Future<void> submitComplaint(ComplaintRequestModel request) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      _response = await repository.postComplaint(request);
    } catch (e) {
      _response = null;
      _error = e.toString();
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // Fetch complaints
  Future<void> fetchComplaints() async {
    _isFetching = true;
    _error = null;
    notifyListeners();

    try {
      final response = await repository.getComplaints();
      _complaints = response;
    } catch (e) {
      _error = e.toString();
      _complaints = [];
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }
}
