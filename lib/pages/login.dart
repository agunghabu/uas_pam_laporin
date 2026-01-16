import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_pam_laporin/pages/user_dashboard.dart';
import 'package:uas_pam_laporin/utils/helpers.dart';
import 'package:uas_pam_laporin/utils/widgets.dart';

import '../provider/provider_login.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
            LTextField(
              controller: context.read<ProviderLogin>().idCtrl,
              icon: Icons.numbers_rounded,
              labelText: "ID",
              hintText: "0000000000",
            ),
            SizedBox(height: 16),
            LTextField(
              controller: context.read<ProviderLogin>().passCtrl,
              icon: Icons.key,
              obscureText: true,
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
