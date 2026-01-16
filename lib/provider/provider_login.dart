import 'package:flutter/material.dart';

class ProviderLogin with ChangeNotifier {
  final TextEditingController _idCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  TextEditingController get idCtrl => _idCtrl;
  TextEditingController get passCtrl => _passCtrl;
}
