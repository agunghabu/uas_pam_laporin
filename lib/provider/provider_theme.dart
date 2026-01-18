import 'package:flutter/material.dart';

class ProviderAppTheme with ChangeNotifier {
  bool _darkMode = false;
  int _colorIndex = 7;
  final List<Color> _colors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.tealAccent,
    Colors.amberAccent,
    Colors.indigoAccent,
    Colors.pinkAccent,
    Colors.cyanAccent,
  ];
  final List<String> _colorNames = [
    'Red',
    'Blue',
    'Green',
    'Purple',
    'Orange',
    'Teal',
    'Amber',
    'Indigo',
    'Pink',
    'Cyan',
  ];

  bool get darkMode => _darkMode;
  List<Color> get colors => _colors;
  int get colorIndex => _colorIndex;

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void setColorIndex(int index) {
    if (index >= 0 && index < _colors.length) {
      _colorIndex = index;
      notifyListeners();
    }
  }

  List<DropdownMenuEntry<int>> get colorDropdownItems {
    return List<DropdownMenuEntry<int>>.generate(
      _colors.length,
      (index) => DropdownMenuEntry(
        value: index,
        label: _colorNames[index],
        labelWidget: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(shape: BoxShape.circle, color: _colors[index]),
            ),
            const SizedBox(width: 10),
            Text(_colorNames[index]),
          ],
        ),
      ),
    );
  }
}
