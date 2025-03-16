import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/forms/v1.dart' as gapi show FormsApi, Form;
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
    final String credentials =
        await rootBundle.loadString('assets/service_account.json');
    // Decode JSON
    final dynamic decoded = json.decode(credentials);

    // final Map<String, dynamic> jsonCredentials =
    // (json.decode(credentials) as Map).map((key, value) => MapEntry(key.toString(), value));

    // final Map<String, dynamic> jsonCredentials = Map<String, dynamic>.from(decoded);

    // Ensure it's a Map before casting
    if (decoded is! Map) {
      throw Exception(
          "Decoded JSON is not a Map! It's of type ${decoded.runtimeType}");
    }

    // Print debug info
    print("Decoded Type: ${decoded.runtimeType}");

    // Authenticate with Google
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(decoded),
      [FormsApi.formsBodyScope],
    );

    print("Decoded Data: ${decoded}");

    // Initialize Google Forms API
    final gapi.FormsApi formsApi = gapi.FormsApi(client);

    print("Here ..............///////////////");

    // Create a new form with organization-specific title


    Map<String, dynamic> formJson = {
      "formId": orgName,
      "info": {
        "title": "$orgName - Member Registration",
      },
      "items": [
        // Hidden field for Organization ID (Optional)
        {
          "itemId": "72b30353",
          "title": "Organization ID: $orgName",
          "description":
              "This field links responses to the correct organization.",
          "questionItem": {
            "question": {"textQuestion": {}}
          },
        },
        {
          "itemId": "72bd0353",
          "title": "Full Name",
          "questionItem": {
            "question": {"textQuestion": {}}
          }
        },
        {
          "itemId": "72b30153",
          "title": "Location",
          "questionItem": {
            "question": {"textQuestion": {}}
          }
        },
        {
          "itemId": "72b30350",
          "title": "Contact",
          "questionItem": {
            "question": {"textQuestion": {}}
          }
        },
        {
          "itemId": "71b30353",
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
        {
          "itemId": "72230353",
          "title": "Spouse Name",
          "questionItem": {
            "question": {"textQuestion": {}}
          }
        },
        {
          "itemId": "72b30303",
          "title": "Children (Comma Separated)",
          "questionItem": {
            "question": {"textQuestion": {}}
          }
        },
        {
          "itemId": "72b31353",
          "title": "Relative Contact",
          "questionItem": {
            "question": {"textQuestion": {}}
          }
        },
        {
          "itemId": "72b30357",
          "title": "Profile Picture",
          "questionItem": {
            "question": {"fileUploadQuestion": {}}
          }
        },
        {
          "itemId": "22b30353",
          "title": "Additional Image",
          "questionItem": {
            "question": {"fileUploadQuestion": {}}
          }
        },
        {
          "itemId": "82b30353",
          "title": "Date of Birth (YYYY-MM-DD)",
          "questionItem": {
            "question": {"textQuestion": {}}
          }
        },
        {
          "itemId": "72bc0353",
          "title": "Group Affiliations (Comma Separated)",
          "questionItem": {
            "question": {"textQuestion": {}}
          }
        },
        {
          "itemId": "7ab30353",
          "title": "Role",
          "questionItem": {
            "question": {"textQuestion": {}}
          }
        }
      ]
    };

      gapi.Form newForm = gapi.Form.fromJson({
        "info": {
          "title": "My Organization Form"
        }
      });

    print("Here ..............///////////////");

    print('About to create .......');
    var createdForm = await formsApi.forms.create(newForm);
    print("✅ Google Form Created for $orgName: ${createdForm.responderUri}");

    return createdForm.responderUri; // Return form link
  } catch (e) {
    print("❌ Error creating form: $e");
    return null;
  }
}

Future<String?> generateAndShareGoogleForm(BuildContext context) async {
  // context.read<MemberController>().setLoading(true);

  String orgName = locator.get<SharedPreferences>().getString('org_id')!;
  // Generate Google Form
  return await createOrganizationGoogleForm(orgName);
  //
  // if (formLink != null) {
  //   // Show share options
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Share Google Form"),
  //       content: SelectableText("Share this form link:\n$formLink"),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Close"),
  //         ),
  //       ],
  //     ),
  //   );
    // context.read<MemberController>().setLoading(false);
  // } else {
  //   // NotificationUtil.showError(context, "Failed to generate form.");
  //   print("Failed to generate form.");
  // }
}

Future<void> loadServiceAccount() async {
  try {
    final String credentials =
        await rootBundle.loadString('assets/service_account.json');
    final Map<String, dynamic> jsonCredentials = json.decode(credentials);
    print("✅ JSON Loaded Successfully: ${jsonCredentials['client_email']}");
  } catch (e) {
    print("❌ Error loading service account JSON: $e");
  }
}
