import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

String? validateID(String value) {
  if (value.isEmpty) {
    return 'ID cannot be empty';
  } else if (value.length != 10) {
    return 'ID must be exactly 10 digits';
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'ID must contain only numbers';
  } else {
    return null;
  }
}

String? validatePassword(String value) {
  if (value.isEmpty) {
    return 'Password cannot be empty';
  } else if (value.length < 6) {
    return 'Password must be at least 6 characters';
  } else {
    return null;
  }
}

String? validateAN(String value, {int minLength = 6}) {
  if (value.isEmpty) {
    return 'This field cannot be empty';
  } else if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
    return 'Only letters and numbers are allowed';
  } else if (value.length < minLength) {
    return 'Must be at least $minLength characters';
  } else {
    return null;
  }
}

String? validateDesc(String value) {
  if (value.isEmpty) {
    return null;
  } else if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
    return 'Only letters and numbers are allowed';
  } else {
    return null;
  }
}

Future<Map<String, dynamic>> validateImage(File file) async {
  final int imageSize = 10 * 1024 * 1024;
  final List<String> imageExt = ['jpg', 'jpeg', 'png'];

  final fileSize = await file.length();
  final extension = file.path.split('.').last.toLowerCase();

  if (!imageExt.contains(extension)) {
    return {'valid': false, 'message': 'Only PNG/JPG images are allowed'};
  } else if (fileSize > imageSize) {
    return {'valid': false, 'message': 'Image size must be less than 10MB'};
  } else {
    return {'valid': true, 'message': null};
  }
}

const List<String> areaNames = ['Campus A', 'Campus B', 'Campus C'];

const Map<int, List<String>> unitNames = {
  0: ['A1', 'A2', 'A3'],
  1: ['B1', 'B2'],
  2: ['C1'],
};

String getAreaName(int index) {
  if (index >= 0 && index < areaNames.length) {
    return areaNames[index];
  }
  return 'Unknown';
}

String getUnitName(int areaIndex, int unitIndex) {
  if (unitNames.containsKey(areaIndex) && unitIndex >= 0 && unitIndex < unitNames[areaIndex]!.length) {
    return unitNames[areaIndex]![unitIndex];
  }
  return 'Unknown';
}

List<DropdownMenuEntry<int>> getBuildingEntries(int selectedArea) {
  if (selectedArea == 0) {
    return [
      DropdownMenuEntry(value: 0, label: 'A1'),
      DropdownMenuEntry(value: 1, label: 'A2'),
      DropdownMenuEntry(value: 2, label: 'A3'),
    ];
  } else if (selectedArea == 1) {
    return [DropdownMenuEntry(value: 0, label: 'B1'), DropdownMenuEntry(value: 1, label: 'B2')];
  } else if (selectedArea == 2) {
    return [DropdownMenuEntry(value: 0, label: 'C1')];
  } else {
    return [
      DropdownMenuEntry(value: 0, enabled: false, label: 'Select an area first', leadingIcon: Icon(Icons.info_outline)),
    ];
  }
}

Future<Map<String, dynamic>> takePhoto(ImagePicker picker) async {
  try {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final file = File(photo.path);
      final validation = await validateImage(file);
      if (validation['valid'] == true) {
        return {'success': true, 'file': file, 'message': null};
      } else {
        return {'success': false, 'file': null, 'message': validation['message']};
      }
    } else {
      return {'success': false, 'file': null, 'message': null};
    }
  } catch (e) {
    return {'success': false, 'file': null, 'message': e.toString()};
  }
}

pushPage(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

pushReplace(BuildContext context, Widget page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}
