import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/forms/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

Future<String?> createOrganizationGoogleForm(String orgName, String orgId) async {
  try {
    // Load the service account JSON
    final String credentials = await rootBundle.loadString('assets/service_account.json');
    final Map<String, dynamic> jsonCredentials = json.decode(credentials);

    // Authenticate with Google
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(jsonCredentials),
      [FormsApi.formsBodyScope],
    );

    // Initialize Google Forms API
    final FormsApi formsApi = FormsApi(client);

    // Create a new form with organization-specific title
    Form newForm = Form.fromJson({
      "title": "$orgName - Member Registration",
      "items": [
        // Hidden field for Organization ID (Optional)
        {
          "title": "Organization ID: $orgId",
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
