import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

takePhoto(ImagePicker picker) async {
  try {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      return File(photo.path);
    }
    return null;
  } catch (e) {
    print(e);
  }
}

pushPage(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

pushReplace(BuildContext context, Widget page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}
