import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestCredentialsView extends StatefulWidget {
  const RequestCredentialsView({super.key});

  @override
  State<RequestCredentialsView> createState() => _RequestCredentialsViewState();
}

class _RequestCredentialsViewState extends State<RequestCredentialsView> {
  late TextEditingController emailController;
  final formKey = GlobalKey<FormState>();

  Future<void> _sendRequestMail(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      NotificationUtil.showError(context, 'Could not launch $url');
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
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _sendRequestMail(Uri(
                        scheme: 'mailto',
                        path: 'essoun379@gmail.com',
                        queryParameters: {
                          'subject': 'Requesting_For_Shepherd_Credentials',
                          'body':
                              "Use_${emailController.text}_as_the_email_address_to_my_credentials."
                        })).then((_) {
                      emailController.clear();
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: const Text(
                  'Send request',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
