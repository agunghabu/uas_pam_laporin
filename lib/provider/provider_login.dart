import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProviderLogin with ChangeNotifier {
  final TextEditingController _idCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;

  TextEditingController get idCtrl => _idCtrl;
  TextEditingController get passCtrl => _passCtrl;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;

  Future<bool> login() async {
    if (_idCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      _errorMessage = "Please fill in all fields";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.post('auth/login.php', {'user_id': _idCtrl.text, 'password': _passCtrl.text});

      _isLoading = false;

      if (response['success'] == true) {
        _userData = response['data'];
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _userData = null;
    _idCtrl.clear();
    _passCtrl.clear();
    notifyListeners();
  }
}
