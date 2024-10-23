import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/src/login/data/data_source/remote_s.dart';
import 'package:ch_db_admin/src/login/data/models/user_login_credentials.dart';
import 'package:ch_db_admin/src/login/presentation/controller/auth_controller.dart';
import 'package:ch_db_admin/src/main_view/presentation/home.dart';
import 'package:ch_db_admin/theme/apptheme.dart';
import 'package:ch_db_admin/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Define preset colors
  final List<Color> presetColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.yellow,
    Colors.brown,
  ];

  Future<void> _checkPreferences(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // Check if theme preferences are already saved
    if (!prefs.containsKey('isDarkMode') ||
        !prefs.containsKey('primaryColor')) {
      // If not saved, show theme dialog to let the user choose
      _showThemeDialog(context);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
        (route) => false,
      );
    }
  }

  void _showThemeDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
              const SizedBox(height: 20),
              const Text('Choose Primary Color:'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10.0,
                children: presetColors.map((color) {
                  return GestureDetector(
                    onTap: () async {
                      themeProvider.setPrimaryColor(color);
                      // Save preferences after selecting the color and theme
                      await savePreferences(themeProvider.isDarkMode,
                          themeProvider.theme.primaryColor);

                      // Close the dialog after saving
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomeView(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: themeProvider.theme.primaryColor == color
                              ? Colors.black
                              : Colors.transparent,
                          width: 3.0,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

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
                  final result = await context.read<AuthController>().signIn(
                      UserLoginCredentialsModel(
                          email: emailController.text,
                          password: passwordController.text));
                  result.fold(
                      (failure) =>
                          NotificationUtil.showError(context, failure.message),
                      (success) async {
                    NotificationUtil.showSuccess(
                        context, 'Signed in successfully');
                    await _checkPreferences(context);
                  });
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
            ],
          ),
        ),
      ),
    );
  }
}
