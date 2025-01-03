import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/shared/utils/extensions.dart';
import 'package:ch_db_admin/src/auth/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      NotificationUtil.showError(context, "Please enter your email");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate sending password reset email (replace with actual logic)
      await Future.delayed(const Duration(seconds: 2));

      NotificationUtil.showSuccess(
          context, "Password reset email sent successfully!");
      _emailController.clear();
    } catch (e) {
      NotificationUtil.showError(context, "Error: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter your registered email address, and we'll send you a link to reset your password.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "example@domain.com",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              child: const Text("Send Password Reset Email"),
            ).loadingIndicator(
                context, context.watch<AuthController>().isLoading),
          ],
        ),
      ),
    );
  }
}
