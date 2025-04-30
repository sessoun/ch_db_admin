import 'dart:io';

import 'package:ch_db_admin/shared/utils/upload_and_download.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../shared/notification_util.dart';
import '../../../../shared/utils/custom_print.dart';
import '../../domain/entities/member.dart';
import '../controller/member._controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> pickAndProcessExcel(BuildContext context) async {
  final provider = context.read<MemberController>();
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
  );

  if (result == null) {
    miPrint("❌ No file selected.");
    return;
  } // User canceled the picker

  miPrint("📂 File selected: ${result.files.single.name}");

  //makes sure the result has only one item. Throws error if empty or more than one
  Uint8List? bytes = result.files.single.bytes;
  String? filePath = result.files.single.path;
  if (bytes == null && filePath != null) {
    try {
      bytes = await File(filePath).readAsBytes();
      miPrint("✅ File read successfully from path.");
    } catch (e) {
      miPrint("❌ Error reading file: $e");
      NotificationUtil.showError(context, "Error reading file: $e");
      return;
    }
  }

  if (bytes == null) {
    miPrint("❌ Unable to read file bytes.");
    NotificationUtil.showError(context, "Error reading file");
    return;
  }
  try {
    var excel = Excel.decodeBytes(bytes);
    miPrint("✅ Excel file loaded successfully.");
  } catch (e) {
    miPrint("❌ Error decoding Excel file: $e");
    NotificationUtil.showError(context, "Error reading file: $e");

    return;
  }

  var excel = Excel.decodeBytes(bytes);
  List<Member> members = [];

  for (var table in excel.tables.keys) {
    {
      var sheet = excel.tables[table]!;
      for (var rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
        var row = sheet.rows[rowIndex];

        if (row.length > 1) {
          var filteredRow = row.sublist(1);
          String fullName = filteredRow[0]!.value!.toString();
          String location = filteredRow[1]?.value?.toString() ?? '';
          String contact = filteredRow[2]?.value?.toString() ?? '';
          String marriageStatus = filteredRow[3]?.value?.toString() ?? '';
          String? spouseName = filteredRow[4]?.value?.toString();
          List<String>? children = filteredRow[5]?.value?.toString().split(",");
          String? relativeContact = filteredRow[6]?.value?.toString();
          String? profilePic = await uploadImageFromDrive(
              context, filteredRow[7]!.value!.toString(), 'profilePics');
          String? additionalImage = filteredRow[8]?.value != null
              ? await uploadImageFromDrive(
                  context, filteredRow[8]!.value!.toString(), 'otherImages')
              : null;
          DateTime dateOfBirth =
              DateTime.tryParse(filteredRow[9]!.value!.toString()) ??
                  DateTime.now();
          List<String>? groupAffiliate =
              filteredRow[10]?.value?.toString().split(",");
          String? role = row[11]?.value?.toString();

          if (fullName.isEmpty ||
              location.isEmpty ||
              contact.isEmpty ||
              marriageStatus.isEmpty) {
            // Skip invalid rows
            continue;
          }

          members.add(Member(
            fullName: fullName,
            location: location,
            contact: contact,
            marriageStatus: marriageStatus,
            spouseName: spouseName,
            children: children,
            relativeContact: relativeContact,
            additionalImage: additionalImage,
            profilePic: profilePic,
            dateOfBirth: dateOfBirth,
            groupAffiliate: groupAffiliate,
            role: role,
          ));
        }
      }
    }
  }

  await _saveToFirebase(members, provider, context);
}

Future<void> _saveToFirebase(List<Member> members, MemberController provider,
    BuildContext context) async {
  provider.setLoading(true);

  for (var member in members) {
    await provider.addMember(member);
  }
  if (context.mounted) {
    NotificationUtil.showSuccess(context, "Excel data uploaded successfully!");
  }
  await provider.fetchAllMembers().then((_) {
    if (provider.statusMessage.contains('Error')) {
      NotificationUtil.showError(context, provider.statusMessage);
    } else {
      NotificationUtil.showSuccess(context, provider.statusMessage);
    }
  });
  provider.setLoading(false);
}

//retrieves url from excel as drive file, download and store in firebase storage
Future<String?> uploadImageFromDrive(
  BuildContext context,
  String driveLink,
  String fileFolder,
) async {
  try {
    // Extract File ID from Google Drive link
    final RegExp regex = RegExp(r"/d/([a-zA-Z0-9_-]+)/");
    final match = regex.firstMatch(driveLink);
    if (match == null) return null;

    String fileId = match.group(1)!;
    String downloadUrl =
        "https://www.googleapis.com/drive/v3/files/$fileId?alt=media&key=${dotenv.env['DRIVE_API_KEY']}";

    // Download image
    var response = await http.get(Uri.parse(downloadUrl));

    if (response.statusCode != 200) return null;

    // Get local directory to save image
    Directory tempDir = await getTemporaryDirectory();
    File file = File("${tempDir.path}/image.jpg");

    // Write the image to file
    await file.writeAsBytes(response.bodyBytes);

    return await imageStore(context,
        fileFolder: fileFolder, selectedImage: file); // Return Firebase URL
  } catch (e) {
    miPrint("Error uploading image: $e");
    return null;
  }
}
