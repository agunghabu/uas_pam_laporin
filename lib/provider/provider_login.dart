import 'package:flutter/material.dart';

class ProviderLogin with ChangeNotifier {
  final TextEditingController nimCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  TextEditingController getNimCtrl() => nimCtrl;
  TextEditingController getPassCtrl() => passCtrl;
}
