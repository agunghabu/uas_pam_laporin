import 'package:flutter/material.dart';

class ProviderAppTheme with ChangeNotifier {
  bool _darkMode = true;

  bool get darkMode => _darkMode;

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }
}
