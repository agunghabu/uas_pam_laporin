import 'package:flutter/material.dart';
import 'package:uas_pam_laporin/pages/login.dart';

void main() {
  runApp(const Laporin());
}

class Laporin extends StatelessWidget {
  const Laporin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laporin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.redAccent,
        ),
      ),
      home: const Login(),
    );
  }
}
