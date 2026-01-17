import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProviderReports with ChangeNotifier {
  bool _isLoading = false;
  bool _isLoadingAdmin = false;
  List<Map<String, dynamic>> _userReports = [];
  List<Map<String, dynamic>> _pendingReports = [];
  List<Map<String, dynamic>> _activeReports = [];
  List<Map<String, dynamic>> _completedReports = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoadingAdmin => _isLoadingAdmin;
  List<Map<String, dynamic>> get userReports => _userReports;
  List<Map<String, dynamic>> get pendingReports => _pendingReports;
  List<Map<String, dynamic>> get activeReports => _activeReports;
  List<Map<String, dynamic>> get completedReports => _completedReports;
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

  Future<void> fetchReportsByStatus(String status) async {
    _isLoadingAdmin = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.get('reports/all_reports.php?status=$status');

      _isLoadingAdmin = false;

      if (response['success'] == true) {
        final reports = List<Map<String, dynamic>>.from(response['data'] ?? []);
        switch (status) {
          case 'pending':
            _pendingReports = reports;
            break;
          case 'active':
            _activeReports = reports;
            break;
          case 'completed':
            _completedReports = reports;
            break;
        }
      } else {
        _errorMessage = response['message'];
      }
      notifyListeners();
    } catch (e) {
      _isLoadingAdmin = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void clearReports() {
    _userReports = [];
    notifyListeners();
  }

  void clearAdminReports() {
    _pendingReports = [];
    _activeReports = [];
    _completedReports = [];
    notifyListeners();
  }

  Future<bool> updateReportStatus(int reportId, String newStatus) async {
    try {
      final response = await ApiService.post('reports/update_status.php', {'id': reportId, 'status': newStatus});

      if (response['success'] == true) {
        await fetchReportsByStatus('pending');
        await fetchReportsByStatus('active');
        await fetchReportsByStatus('completed');
        return true;
      } else {
        _errorMessage = response['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
