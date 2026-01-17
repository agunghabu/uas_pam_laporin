import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_pam_laporin/pages/login.dart';
import 'package:uas_pam_laporin/provider/provider_login.dart';
import 'package:uas_pam_laporin/provider/provider_reports.dart';
import 'package:uas_pam_laporin/provider/provider_submit_report.dart';
import 'package:uas_pam_laporin/provider/provider_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderLogin()),
        ChangeNotifierProvider(create: (_) => ProviderAppTheme()),
        ChangeNotifierProvider(create: (_) => ProviderSubmitReport()),
        ChangeNotifierProvider(create: (_) => ProviderReports()),
      ],
      child: const Laporin(),
    ),
  );
}

class Laporin extends StatelessWidget {
  const Laporin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laporin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: context.watch<ProviderAppTheme>().darkMode ? Brightness.dark : Brightness.light,
          seedColor: context.watch<ProviderAppTheme>().colors[context.watch<ProviderAppTheme>().colorIndex],
        ),
      ),
      home: const Login(),
    );
  }
}
