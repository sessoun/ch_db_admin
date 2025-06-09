// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/shared/utils/custom_print.dart';
import 'package:ch_db_admin/shared/utils/extensions.dart';
import 'package:ch_db_admin/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';

class RequestCredentialsView extends StatefulWidget {
  const RequestCredentialsView({super.key});

  @override
  State<RequestCredentialsView> createState() => _RequestCredentialsViewState();
}

class _RequestCredentialsViewState extends State<RequestCredentialsView> {
  bool isRequesting = false;
  late TextEditingController emailController;
  final formKey = GlobalKey<FormState>();

  final email = dotenv.env['EMAIL_ADDRESS'];
  final appPassword = dotenv.env['GOOGLE_APP_PASSWORD'];
  final apiKey = dotenv.env['EMAIL_VALIDATOR'];
  bool isLoading = false;

  /// ✅ Function to check if an email exists using ZeroBounce
  Future<dynamic> verifyEmail() async {
    setState(() {
      isLoading = true;
    });
    final url =
        "https://api.zerobounce.net/v2/validate?api_key=$apiKey&email=${emailController.text}";

    try {
      final response = await http.get(Uri.parse(url));
      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        miPrint(
            "Email Status: ${data['status']}"); // Returns "valid" or "invalid"
        if (data['status'] == 'valid') {
          // await sendRequestEmail(emailController.text);
          await sm();
          // NotificationUtil.showSuccess(context,
          //     'Request sent successfully! Admin will process your credentials.');
        } else if (data['status'] == 'invalid') {
          NotificationUtil.showError(
              context, 'Email address is invalid. Please try again.');
        } else if (data['status'] == 'catch-all') {
          NotificationUtil.showError(
              context, 'Email address is catch-all. Please try again.');
        } else if (data['status'] == 'unknown') {
          NotificationUtil.showError(
              context, 'Email address status is unknown. Please try again.');
        } else {
          NotificationUtil.showError(
              context, 'Please use a valid email address.');
        }
        return data['status'];
      } else {
        miPrint("❌ API Request Failed: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      miPrint("❌ Error: $e");
      if (e.toString().toLowerCase().contains('socketexception')) {
        NotificationUtil.showError(
            context, "Network issues.Check and try again, please.");
      } else {
        NotificationUtil.showError(
            context, "Something went wrong. Try again, please.");
      }
    }
  }

  Future<void> sendRequestEmail(String userEmail) async {
    setState(() => isRequesting = true);

    final smtpServer = SmtpServer(
      'smtp.gmail.com',
      port: 465,
      username: email,
      password: appPassword,
      ssl: true,
    );

    final message = Message()
      ..from = Address(email!, 'Shepherd System')
      ..recipients.add(email)
      ..subject = 'New User Requesting Shepherd Credentials'
      ..text = 'A new user has requested credentials for Shepherd.\n\n'
          'Requesting User\'s Email: $userEmail\n\n'
          'Please process their credentials using the email address above.\n\n'
          '- Shepherd System';

    try {
      await send(message, smtpServer);
      NotificationUtil.showSuccess(context,
          'Request sent successfully! Admin will process your credentials.');
    } catch (e) {
      NotificationUtil.showError(context, 'Failed to send request: $e');
    } finally {
      setState(() => isRequesting = false);
    }
  }

  Future<void> sm() async {
    try {
      miPrint('Sending email... ${emailController.text.trim()}');
      final callable =
          FirebaseFunctions.instance.httpsCallable('sendCredentialEmail');

      final result =
          await callable.call({'email': emailController.text.trim()});

      if (result.data['success'] == true) {
        miPrint('Email sent successfully');
        NotificationUtil.showSuccess(
          context,
          'Request sent successfully! Admin will process your credentials.\nYou will receive an email with your credentials shortly.',
        );
        Navigator.of(context).pop();
      } else {
        miPrint('Failed to send email: ${result.data}');
        NotificationUtil.showError(
          context,
          result.data['message'] ?? 'Failed to send request. Please try again.',
        );
      }
    } on FirebaseFunctionsException catch (e) {
      miPrint('FirebaseFunctionsException: ${e.message}');
      NotificationUtil.showError(
        context,
        e.message ?? 'A server error occurred. Please try again.',
      );
    } catch (e) {
      miPrint('Unexpected error: $e');
      NotificationUtil.showError(
        context,
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    emailController = TextEditingController();
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Credentials'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enter your email to receive your credentials. The same email will be used as part of your credentials.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: CustomTextFormField(
                controller: emailController,
                labelText: 'Email Address',
                hintText: 'Enter your email',
                validator: (p0) => p0 == null || p0.isEmpty
                    ? 'Enter a valid email address'
                    : null,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isRequesting
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          verifyEmail().then((status) {
                            if (status == 'valid' && mounted) {
                              // Navigator.of(context).pop();
                            }
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('Send Request'),
              ).loadingIndicator(context, isLoading),
            ),
          ],
        ),
      ),
    );
  }
}
