import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class ProviderSubmitReport with ChangeNotifier {
  File? _imageFile;
  int _selectedArea = -1;
  int _selectedUnit = -1;
  bool _isLoading = false;
  String? _errorMessage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _unitCtrl = TextEditingController();

  File? get imageFile => _imageFile;
  int get selectedArea => _selectedArea;
  int get selectedUnit => _selectedUnit;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
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

  Future<bool> submitReport(String userId) async {
    if (!validateInputs()) {
      _errorMessage = "Please make sure to attach a photo, fill in the title, and select both area and unit.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.postWithFile(
        'reports/submit.php',
        {
          'user_id': userId,
          'title': _titleCtrl.text,
          'description': _descCtrl.text,
          'area': _selectedArea.toString(),
          'unit': _selectedUnit.toString(),
        },
        'image',
        _imageFile!.path,
      );

      _isLoading = false;

      if (response['success'] == true) {
        clearForm();
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clearForm() {
    _imageFile = null;
    _selectedArea = -1;
    _selectedUnit = -1;
    _titleCtrl.clear();
    _descCtrl.clear();
    _unitCtrl.clear();
  }
}
