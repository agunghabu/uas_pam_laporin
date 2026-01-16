import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProviderSubmitReport with ChangeNotifier {
  File? _imageFile;
  int _selectedArea = -1;
  int _selectedUnit = -1;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _unitCtrl = TextEditingController();

  File? get imageFile => _imageFile;
  int get selectedArea => _selectedArea;
  int get selectedUnit => _selectedUnit;
  ImagePicker get picker => _picker;
  TextEditingController get titleCtrl => _titleCtrl;
  TextEditingController get descCtrl => _descCtrl;
  TextEditingController get unitCtrl => _unitCtrl;

  void setImageFile(File? file) {
    _imageFile = file;
    notifyListeners();
  }

  void setSelectedArea(int area) {
    _selectedArea = area;
    notifyListeners();
  }

  void setSelectedUnit(int unit) {
    _selectedUnit = unit;
    notifyListeners();
  }

  bool validateInputs() {
    return _imageFile != null && _selectedArea != -1 && _selectedUnit != -1 && _titleCtrl.text.isNotEmpty;
  }
}
