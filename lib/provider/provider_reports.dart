import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProviderReports with ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _userReports = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get userReports => _userReports;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserReports(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.get('reports/user_reports.php?user_id=$userId');

      _isLoading = false;

      if (response['success'] == true) {
        _userReports = List<Map<String, dynamic>>.from(response['data'] ?? []);
      } else {
        _errorMessage = response['message'];
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void clearReports() {
    _userReports = [];
    notifyListeners();
  }
}
