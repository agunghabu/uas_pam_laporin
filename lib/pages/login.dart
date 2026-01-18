import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_pam_laporin/pages/admin_dashboard.dart';
import 'package:uas_pam_laporin/pages/user_dashboard.dart';
import 'package:uas_pam_laporin/utils/helpers.dart';
import 'package:uas_pam_laporin/utils/widgets.dart';

import '../provider/provider_login.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  void _handleLogin(BuildContext context) async {
    final provider = context.read<ProviderLogin>();
    final success = await provider.login();

    if (success && context.mounted) {
      final role = provider.userData?['role'];
      if (role == 'admin') {
        pushReplace(context, AdminDashboard());
      } else {
        pushReplace(context, UserDashboard());
      }
    } else if (context.mounted && provider.errorMessage != null) {
      showDialog(
        context: context,
        builder: (context) => LAlertDialog(
          icon: Icons.error_outline,
          title: 'Login Failed',
          content: LText.bodyMedium(context, provider.errorMessage!, textAlign: TextAlign.center),
        ),
      );
    }
  }

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
            FilledButton(
              onPressed: context.read<ProviderLogin>().isLoading ? null : () => _handleLogin(context),
              child: context.watch<ProviderLogin>().isLoading
                  ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
