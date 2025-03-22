// import 'package:googleapis/drive/v3.dart';
// import 'package:googleapis_auth/googleapis_auth.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// // Load credentials
// final _credentials = jsonDecode('YOUR_CREDENTIALS_JSON');
//
// // Authenticate
// final client = await clientViaServiceAccount(
// ServiceAccountCredentials.fromJson(_credentials),
// [DriveApi.driveScope],
// );
//
// // Create API Instance
// final driveApi = DriveApi(client);
//
// // Grant Edit Access
// Future<void> grantEditAccess(String formId, String adminEmail) async {
// try {
// var permission = Permission()
// ..role = 'writer'
// ..type = 'user'
// ..emailAddress = adminEmail;
//
// await driveApi.permissions.create(permission, formId);
// print("✅ Admin has edit access!");
// } catch (e) {
// print("❌ Error: $e");
// }
// }
