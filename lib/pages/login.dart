import 'package:flutter/material.dart';
import 'package:uas_pam_laporin/pages/user_dashboard.dart';
import 'package:uas_pam_laporin/utils/helpers.dart';
import 'package:uas_pam_laporin/utils/widgets.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nimCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LText.headlineMedium(context, 'Login to proceed', textAlign: TextAlign.center),
            SizedBox(height: 32),
            LTextField(controller: nimCtrl, icon: Icons.person_outline, labelText: "NIM", hintText: "0000000000"),
            SizedBox(height: 16),
            LTextField(
              icon: Icons.key,
              obscureText: true,
              controller: passCtrl,
              hintText: '********',
              labelText: 'Password',
            ),
            SizedBox(height: 16),
            FilledButton(onPressed: () => pushReplace(context, UserDashboard()), child: Text('Login')),
          ],
        ),
      ),
    );
  }
}
