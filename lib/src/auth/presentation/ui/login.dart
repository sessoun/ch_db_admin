import 'package:ch_db_admin/auth_state.dart';
import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/shared/utils/extensions.dart';
import 'package:ch_db_admin/src/auth/data/models/user_login_credentials.dart';
import 'package:ch_db_admin/src/auth/presentation/controller/auth_controller.dart';
import 'package:ch_db_admin/src/auth/presentation/ui/forget_password.dart';
import 'package:ch_db_admin/src/auth/presentation/ui/request_credentials.dart';
import 'package:ch_db_admin/theme/apptheme.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('images/lil.jpg'), context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'images/lil.jpg',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Center(
                  child: Text(
                    'Jesus is the Good Shepherd',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.theme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

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
                  obscureText: true,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Login Button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final result =
                          await context.read<AuthController>().signIn(
                                UserLoginCredentialsModel(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );

                      result.fold(
                        (failure) => NotificationUtil.showError(
                            context, failure.message),
                        (success) async {
                          triggerPasswordReset.setPassword(
                              passwordController.text.trim()); // Store password
                          NotificationUtil.showSuccess(
                              context, 'Signed in successfully');
                          // await checkOnOrgName(context);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const AuthState()),
                            (r) => false,
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Login'),
                ).loadingIndicator(
                    context, context.watch<AuthController>().isLoading),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RequestCredentialsView(),
                        ));
                      },
                      child: Text(
                        'Request for credentials.',
                        style:
                            TextStyle(color: themeProvider.theme.primaryColor),
                      ),
                    ),
                    // Forgot Password Link
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ForgotPasswordView(),
                        ));
                      },
                      child: Text(
                        'Forgot Password?',
                        style:
                            TextStyle(color: themeProvider.theme.primaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
