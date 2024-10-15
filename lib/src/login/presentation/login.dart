import 'package:ch_db_admin/src/login/data/data_source/remote_s.dart';
import 'package:ch_db_admin/src/login/data/models/user_login_credentials.dart';
import 'package:ch_db_admin/src/theme/apptheme.dart';
import 'package:ch_db_admin/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'images/lil.jpg',
              ),
              Center(
                child: Text(
                  'Church Admin',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: themeProvider
                        .theme.primaryColor, // Use primary color from theme
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Email Field
              CustomTextFormField(
                controller: emailController,
                labelText: 'Email',
                hintText: '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Password Field
              CustomTextFormField(
                controller: passwordController,
                labelText: 'Password',
                hintText: '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Login Button
              ElevatedButton(
                onPressed: () async {
                  // Add your login logic here
                 await LoginRemoteS().login(UserLoginCredentialsModel(email: emailController.text, password: passwordController.text));
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),

              // Forgot Password Link
              TextButton(
                onPressed: () {
                  // Navigate to Forgot Password screen
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: themeProvider.theme.primaryColor),
                ),
              ),
              const SizedBox(height: 24),

              // Sign Up Link
              TextButton(
                onPressed: () {
                  // Navigate to Sign Up screen
                },
                child: Text(
                  'Create an account',
                  style: TextStyle(color: themeProvider.theme.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
