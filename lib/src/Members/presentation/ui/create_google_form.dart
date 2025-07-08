import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/shared/utils/request_form.dart';
import 'package:ch_db_admin/src/auth/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/forms/v1.dart' as form;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/utils/custom_print.dart';


//returns the formId for the user to have edit access
Future<String?> createOrganizationGoogleForm(
  BuildContext context,
  String orgName,
) async {
  try {
    miPrint("Requesting authentication...");
    final client = await getAuthenticatedClient(context);
    if (client == null) {
      if (context.mounted) {
        NotificationUtil.showError(context, "❌ Failed to authenticate.");
      }
      return null;
    }

    final formsApi = form.FormsApi(client);
    final createdForm = await _createGoogleForm(context, formsApi, orgName);
    if (createdForm == null) {
      if (context.mounted) {
        NotificationUtil.showError(context, "❌ Failed to create Google Form.");
      }
      return null;
    }

    await _addFormQuestions(formsApi, createdForm.formId!);
    return createdForm.formId;
  } catch (e) {
    miPrint("❌ Error creating Google Form: $e");
    if (context.mounted) {
      NotificationUtil.showError(context, "❌ Error creating Google Form: $e");
    }
    return null;
  }
}

Future<auth.AuthClient?> getAuthenticatedClient(BuildContext context) async {
  // Google Authentication instance
  final gAuth = GoogleSignIn.standard(
    scopes: [
      form.FormsApi.formsBodyScope,
      "https://www.googleapis.com/auth/drive.file",
    ],
  );

  try {
    // Sign in and get authentication
    miPrint("Attempting Google Sign-In...");
    final GoogleSignInAccount? googleUser = await gAuth.signIn();

    if (googleUser == null) {
      if (context.mounted) {
        NotificationUtil.showError(context, "❌ Google Sign-In canceled.");
      }
      return null;
    }

    miPrint("Signed in as: ${googleUser.email}");

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    if (googleAuth.accessToken == null) {
      miPrint("❌ No access token received");
      if (context.mounted) {
        NotificationUtil.showError(context, "❌ Failed to get access token.");
      }
      return null;
    }

    // Create credentials for the authenticated client
    final auth.AccessCredentials credentials = auth.AccessCredentials(
      auth.AccessToken(
        'Bearer',
        googleAuth.accessToken!,
        DateTime.now().toUtc().add(const Duration(hours: 1)),
      ),
      null, // No refresh token needed for this use case
      [
        form.FormsApi.formsBodyScope,
        "https://www.googleapis.com/auth/drive.file",
      ],
    );

    miPrint("✅ Authentication successful");
    return auth.authenticatedClient(http.Client(), credentials);
  } catch (e) {
    miPrint("❌ Google Authentication Error: $e");
    if (context.mounted) {
      NotificationUtil.showError(context, "❌ Google Authentication Error: $e");
    }
    return null;
  }
}

Future<form.Form?> _createGoogleForm(
    context, form.FormsApi formsApi, String orgName) async {
  final newForm = form.Form.fromJson({
    "info": {"title": "$orgName - Member Registration"}
  });

  try {
    final createdForm = await formsApi.forms.create(newForm);
    miPrint(
        "✅ Google Form Created: https://docs.google.com/forms/d/${createdForm.formId}/edit");
    return createdForm;
  } catch (e) {
    miPrint("❌ Error creating Google Form: $e");
    if (context.mounted) {
      NotificationUtil.showError(context, "❌ Error creating Google Form: $e");
    }
    return null;
  }
}

Future<void> _addFormQuestions(form.FormsApi formsApi, String formId) async {
  try {
    await formsApi.forms.batchUpdate(
      form.BatchUpdateFormRequest(requests: reqObj()),
      formId,
    );
    miPrint("✅ Form questions added successfully.");
  } catch (e) {
    miPrint("❌ Error adding questions to form: $e");
    throw Exception("❌ Error adding questions to form: $e");
  }
}

Future<String?> generateAndShareGoogleForm(BuildContext context) async {
  String orgName =
      await context.read<AuthController>().getOrgName() ?? "Shepherd App";
  var createdFormId = await createOrganizationGoogleForm(context, orgName);

  return "https://docs.google.com/forms/d/$createdFormId/edit";
}

void showFormBottomSheet(BuildContext context, String formLink) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "✅ Form Generated Successfully!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              """Before sharing the form:
✅ Name the form properly (e.g., Church Member Registration).
✅ Do not edit any fields.
✅ Go to 'Responses' > 'Link to Sheets' to connect it to Google Sheets.
✅ Only share the form after linking it.
This form is always available in your Google Drive and can create a new
one.""",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(formLink,
                  style: const TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: formLink));
                    if (context.mounted) {
                      NotificationUtil.showSuccess(context, "📋 Link copied!");
                    }
                  },
                  child: const Text("Copy Link"),
                ),
                TextButton(
                  onPressed: () async => await launchUrl(Uri.parse(formLink)),
                  child: const Text("Open Form"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
