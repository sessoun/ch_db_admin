import 'package:ch_db_admin/src/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
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
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: themeProvider.theme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Password Field
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: themeProvider.theme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  // Add your login logic here
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
