import 'dart:async';
import 'dart:io' show File;

import 'package:ch_db_admin/src/auth/presentation/controller/auth_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///store and retrieve image from firebase store
Future<String> processImageToStore(
  BuildContext context, {
  required File selectedImage,
  bool? isEvent = false,
}) async {
  final storageRef = FirebaseStorage.instance.ref();
  var orgName = await context.read<AuthController>().getOrgName();
  String fileName = isEvent == true
      ? '$orgName/events/${DateTime.now().millisecondsSinceEpoch}.jpg':
      '$orgName/profilePics/${DateTime.now().millisecondsSinceEpoch}.jpg';
  final uploadTask = storageRef.child(fileName).putFile(selectedImage);
  //upload image to firebase storage
  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
  //get the download URL of the uploaded image
  return await taskSnapshot.ref.getDownloadURL();
}
