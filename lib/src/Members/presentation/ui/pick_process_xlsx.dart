import 'dart:io';

import 'package:ch_db_admin/shared/utils/upload_and_download.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../shared/notification_util.dart';
import '../../domain/entities/member.dart';
import '../controller/member._controller.dart';

Future<void> pickAndProcessExcel(BuildContext context) async {
  final provider = context.read<MemberController>();

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
  );

  if (result == null) {
    print("❌ No file selected.");
    return;
  } // User canceled the picker

  print("📂 File selected: ${result.files.single.name}");

  //makes sure the result has only one item. Throws error if empty or more than one
  Uint8List? bytes = result.files.single.bytes;
  String? filePath = result.files.single.path;
  if (bytes == null && filePath != null) {
    try {
      bytes = await File(filePath).readAsBytes();
      print("✅ File read successfully from path.");
    } catch (e) {
      print("❌ Error reading file: $e");
      return;
    }
  }

  if (bytes == null) {
    print("❌ Unable to read file bytes.");
    return;
  }
  try {
    var excel = Excel.decodeBytes(bytes);
    print("✅ Excel file loaded successfully.");
  } catch (e) {
    print("❌ Error decoding Excel file: $e");
    return;
  }

  var excel = Excel.decodeBytes(bytes);
  List<Member> members = [];

  for (var table in excel.tables.keys) {
    for (var row in excel.tables[table]!.rows.skip(1)) {
      // Skip header row
      if (row.isEmpty) continue;

      String fullName = row[0]?.value?.toString() ?? '';
      String location = row[1]?.value?.toString() ?? '';
      String contact = row[2]?.value?.toString() ?? '';
      String marriageStatus = row[3]?.value?.toString() ?? '';
      String? spouseName = row[4]?.value?.toString();
      List<String>? children = row[5]?.value?.toString().split(",");
      String? relativeContact = row[6]?.value?.toString();
      String? additionalImage = await uploadImageFromDrive(context,  row[7]!.value!.toString(), 'otherImages');
      String? profilePic = await uploadImageFromDrive(context,  row[8]!.value!.toString(), 'profilePics');
      DateTime dateOfBirth =
          DateTime.tryParse(row[9]?.value?.toString() ?? '') ?? DateTime.now();
      List<String>? groupAffiliate = row[10]?.value?.toString().split(",");
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

  await _saveToFirebase(members, provider, context);
}

Future<void> _saveToFirebase(List<Member> members, MemberController provider,
    BuildContext context) async {
  provider.setLoading(true);

  for (var member in members) {
    await provider.addMember(member).then((_) {
      if (provider.statusMessage.contains('Error')) {
        NotificationUtil.showError(context, provider.statusMessage);
      } else {
        NotificationUtil.showSuccess(context, provider.statusMessage);
      }
    });
  }

  provider.setLoading(false);

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Excel data uploaded successfully!")),
    );
  }
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
        "https://drive.google.com/uc?export=download&id=$fileId";

    // Download image
    var response = await http.get(Uri.parse(downloadUrl));
    if (response.statusCode != 200) return null;

    // Get local directory to save image
    Directory tempDir = await getTemporaryDirectory();
    File file = File("${tempDir.path}/temp_image.jpg");

    // Write the image to file
    await file.writeAsBytes(response.bodyBytes);

   /* // Upload to Firebase Storage
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child("uploads/${DateTime.now().millisecondsSinceEpoch}.jpg");
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String firebaseUrl = await snapshot.ref.getDownloadURL();
*/
    return await imageStore(context,
        fileFolder: fileFolder, selectedImage: file); // Return Firebase URL
  } catch (e) {
    print("Error uploading image: $e");
    return null;
  }
}
