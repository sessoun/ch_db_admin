import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/forms/v1.dart' as gapi show FormsApi,Form ;
import 'package:googleapis/forms/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/Members/presentation/controller/member._controller.dart';
import '../../src/dependencies/auth.dart';
import '../notification_util.dart';

Future<String?> createOrganizationGoogleForm(String orgName) async {
  try {
    // Load the service account JSON
    final String credentials = await rootBundle.loadString('assets/service_account.json');
    print(credentials);
    // Decode JSON
    final dynamic decoded = json.decode(credentials);

    // Print debug info
    print("Decoded Type: ${decoded.runtimeType}");
    print("Decoded Data: $decoded");

    final Map<String, dynamic> jsonCredentials = Map<String, dynamic>.from(decoded);


    // Ensure it's a Map before casting
    if (decoded is! Map) {
      throw Exception("Decoded JSON is not a Map! It's of type ${decoded.runtimeType}");
    }
    // Authenticate with Google
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(decoded),
      [FormsApi.formsBodyScope],
    );

    // Initialize Google Forms API
    final gapi.FormsApi formsApi = gapi.FormsApi(client);

    // Create a new form with organization-specific title
    gapi.Form newForm = gapi.Form.fromJson({
      "title": "$orgName - Member Registration",
      "items": [
        // Hidden field for Organization ID (Optional)
        {
          "title": "Organization ID: $orgName",
          "description": "This field links responses to the correct organization.",
          "questionItem": {"question": {"textQuestion": {}}},
        },
        {"title": "Full Name", "questionItem": {"question": {"textQuestion": {}}}},
        {"title": "Location", "questionItem": {"question": {"textQuestion": {}}}},
        {"title": "Contact", "questionItem": {"question": {"textQuestion": {}}}},
        {
          "title": "Marriage Status",
          "questionItem": {
            "question": {
              "choiceQuestion": {
                "type": "DROP_DOWN",
                "options": ["Single", "Married", "Divorced"]
              }
            }
          }
        },
        {"title": "Spouse Name", "questionItem": {"question": {"textQuestion": {}}}},
        {"title": "Children (Comma Separated)", "questionItem": {"question": {"textQuestion": {}}}},
        {"title": "Relative Contact", "questionItem": {"question": {"textQuestion": {}}}},
        {
          "title": "Profile Picture",
          "questionItem": {
            "question": {"fileUploadQuestion": {}}
          }
        },
        {
          "title": "Additional Image",
          "questionItem": {
            "question": {"fileUploadQuestion": {}}
          }
        },
        {"title": "Date of Birth (YYYY-MM-DD)", "questionItem": {"question": {"textQuestion": {}}}},
        {"title": "Group Affiliations (Comma Separated)", "questionItem": {"question": {"textQuestion": {}}}},
        {"title": "Role", "questionItem": {"question": {"textQuestion": {}}}}
      ]
    });

    var createdForm = await formsApi.forms.create(newForm);
    print("✅ Google Form Created for $orgName: ${createdForm.responderUri}");

    return createdForm.responderUri; // Return form link
  } catch (e) {
    print("❌ Error creating form: $e");
    return null;
  }
}


void generateAndShareGoogleForm(BuildContext context) async {
  // context.read<MemberController>().setLoading(true);

  String orgName = locator.get<SharedPreferences>().getString('org_id')!;
  // Generate Google Form
  String? formLink = await createOrganizationGoogleForm(orgName);

  if (formLink != null) {
    // Show share options
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Share Google Form"),
        content: SelectableText("Share this form link:\n$formLink"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
    // context.read<MemberController>().setLoading(false);

  } else {
    // NotificationUtil.showError(context, "Failed to generate form.");
    print( "Failed to generate form.");
  }
}

Future<void> loadServiceAccount() async {
  try {
    final String credentials = await rootBundle.loadString('assets/service_account.json');
    final Map<String, dynamic> jsonCredentials = json.decode(credentials);
    print("✅ JSON Loaded Successfully: ${jsonCredentials['client_email']}");
  } catch (e) {
    print("❌ Error loading service account JSON: $e");
  }
}

