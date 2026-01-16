import 'package:flutter/material.dart';

class ProviderChangePass with ChangeNotifier {
  final TextEditingController _currPassCtrl = TextEditingController();
  final TextEditingController _newPassCtrl = TextEditingController();
  final TextEditingController _confNewPassCtrl = TextEditingController();

  TextEditingController get currPassCtrl => _currPassCtrl;
  TextEditingController get newPassCtrl => _newPassCtrl;
  TextEditingController get confNewPassCtrl => _confNewPassCtrl;
}
