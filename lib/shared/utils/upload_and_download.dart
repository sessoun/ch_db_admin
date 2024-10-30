import 'dart:async';
import 'dart:io' show File;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Future<String> imageStore(
  BuildContext context,
 { required String fileFolder,
  required String imageUrl,
  required File selectedImage,
  }
) async {
    final storageRef = FirebaseStorage.instance.ref();
    String fileName = '$fileFolder/${DateTime.now().millisecondsSinceEpoch}.png';
    final uploadTask = storageRef.child(fileName).putFile(selectedImage);
    //upload image to firebase storage
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    //get and store url to image
  return  imageUrl = await taskSnapshot.ref.getDownloadURL();
}