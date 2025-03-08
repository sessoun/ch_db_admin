import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class RequestCredentialsView extends StatefulWidget {
  const RequestCredentialsView({super.key});

  @override
  State<RequestCredentialsView> createState() => _RequestCredentialsViewState();
}

class _RequestCredentialsViewState extends State<RequestCredentialsView> {
  bool isRequesting = false;
  late TextEditingController emailController;
  final formKey = GlobalKey<FormState>();

  final email = dotenv.env['EMAIL_ADDRESS'] ?? 'Not set';
  final appPassword = dotenv.env['GOOGLE_APP_PASSWORD'] ?? 'Not set';

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
      ..from = Address(email, 'Shepherd System')
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
                          sendRequestEmail(emailController.text).then((_) {
                            Navigator.of(context).pop();
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: isRequesting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Send Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
