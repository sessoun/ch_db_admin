
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

  //directly sends email without opening any external application
  Future<void> sendRequestEmail(String userEmail) async {
    setState(() {
      isRequesting = true;
    });
    //configuring smtp server
    final smtpServer = SmtpServer(
      'smtp.gmail.com',
      port: 465,
      username: email,
      password: appPassword,
      ssl: true,
    );

    //constructing message
    final message = Message()
      ..from = Address(email, 'Shepherd System') // Use YOUR email as sender
      ..recipients.add(email) // Sending to yourself/admin
      ..subject = 'New User Requesting Shepherd Credentials'
      ..text = '''
A new user has requested credentials for Shepherd.

Requesting User's Email: $userEmail

Please process their credentials using the email address above.

- Shepherd System''';

    try {
      await send(message, smtpServer).then((_) => setState(() {
            isRequesting = false;
          }));

      NotificationUtil.showSuccess(context,
          'Request sent successfully! Admin will process your credentials.');
    } catch (e) {
      NotificationUtil.showError(context, 'Failed to send request: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Credentials'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please enter your prefered email address to recieve your credential.\nNote that same address will be used as part of your credentials.',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                  controller: emailController,
                  labelText: 'Email address',
                  hintText: ''),
              const SizedBox(height: 10),
              TextButton(
                onPressed: isRequesting
                    ? DoNothingAction.new
                    : () {
                        if (formKey.currentState!.validate()) {
                          sendRequestEmail(emailController.text)
                              .then((_) => Navigator.of(context).pop());
                        }
                      },
                child: Text(
                  isRequesting ? 'Hold on! Sending request' : 'Send request',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
