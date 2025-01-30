import 'package:ch_db_admin/src/dependencies/auth.dart';
import 'package:ch_db_admin/src/auth/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> orgNameFormField(BuildContext context) {
  final key = GlobalKey<FormState>();
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final orgNameController = TextEditingController();
      return AlertDialog(
        title: const Text("Enter Organization Name"),
        content: Form(
          key: key,
          child: TextFormField(
            controller: orgNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Organization Name. eg. OB Group",
            ),
          ),
        ),
        actions: [
          // TextButton(
          //   onPressed: () {
          //     Navigator.of(context).pop(); // Close dialog without saving
          //   },
          //   child: const Text("Cancel"),
          // ),
          TextButton(
            onPressed: () {
              if (key.currentState!.validate()) {
                Navigator.of(context).pop(orgNameController.text);
              } // Return entered name
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}

checkOnOrgName(BuildContext context) async {
  // Retrieve the organization name
  var orgName = await context.read<AuthController>().getOrgName();

  // Check if orgName is null
  if (orgName == null) {
    // Show dialog to prompt for organization name
    orgName = await orgNameFormField(context);

    // Save organization name to Firestore and SharedPreferences if not null
    if (orgName != null && orgName.isNotEmpty) {
      // ignore: use_build_context_synchronously
      await context.read<AuthController>().setOrgName(orgName);
      await locator.get<SharedPreferences>().setString('orgName', orgName);
    }
  } else {
    // If orgName was already retrieved, save it to SharedPreferences
    await locator.get<SharedPreferences>().setString('orgName', orgName);
  }
}
