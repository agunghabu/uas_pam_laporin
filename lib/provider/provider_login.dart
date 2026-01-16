import 'package:flutter/material.dart';

class ProviderLogin with ChangeNotifier {
  final TextEditingController _nimCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  TextEditingController get nimCtrl => _nimCtrl;
  TextEditingController get passCtrl => _passCtrl;
}
