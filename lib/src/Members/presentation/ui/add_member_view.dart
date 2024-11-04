import 'dart:io';

import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/shared/utils/upload_and_download.dart';
import 'package:ch_db_admin/src/Members/data/data_source/remote_db.dart';
import 'package:ch_db_admin/src/Members/data/models/member_model.dart';
import 'package:ch_db_admin/src/Members/presentation/controller/member._controller.dart';
import 'package:ch_db_admin/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddMemberView extends StatefulWidget {
  const AddMemberView({super.key});

  @override
  State<AddMemberView> createState() => _AddMemberViewState();
}

class _AddMemberViewState extends State<AddMemberView> {
  final _formKey = GlobalKey<FormState>();
  File? profilePic;
  File? additionalImage;
  String marriageStatus = 'Single';
  DateTime dateOfBirth = DateTime.now();

  // Text controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController spouseNameController = TextEditingController();
  final TextEditingController childrenController = TextEditingController();
  final TextEditingController relativeContactController =
      TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // Method to pick an image from camera or gallery
  Future<void> _pickImage(String type) async {
    final pickedFile = await _picker.pickImage(
      source: type == 'profile' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        if (type == 'profile') {
          profilePic = File(pickedFile.path);
        } else {
          additionalImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> submitForm() async {
    final provider = context.read<MemberController>();

    if (_formKey.currentState!.validate()) {
      String profileImage = profilePic?.path ?? '';
      String otherImage = additionalImage?.path ?? '';

      try {
        if (profilePic != null || additionalImage != null) {
          profileImage = await imageStore(
            context,
            fileFolder: 'profilePics',
            imageUrl: profileImage,
            selectedImage: profilePic!,
          );
          otherImage = await imageStore(
            // ignore: use_build_context_synchronously
            context,
            fileFolder: 'otherImages',
            imageUrl: otherImage,
            selectedImage: additionalImage!,
          );
        }
      } on FirebaseException catch (_) {
        if (mounted) {
          NotificationUtil.showError(
              context, 'Failed to upload image. Please try again.');
        }
      }

      MemberModel newMember = MemberModel(
        profilePic: profileImage,
        fullName: fullNameController.text,
        location: locationController.text,
        contact: contactController.text,
        marriageStatus: marriageStatus,
        spouseName: spouseNameController.text,
        children: childrenController.text
            .split(',')
            .map((child) => child.trim())
            .toList(),
        relativeContact: relativeContactController.text,
        additionalImage: otherImage,
        dateOfBirth: DateTime.parse(dateOfBirthController.text),
      );

      await provider.addMember(newMember).then(
        (result) {
          if (provider.statusMessage.contains('Error')) {
            NotificationUtil.showError(context, provider.statusMessage);
          } else {
            NotificationUtil.showSuccess(context, provider.statusMessage);
          }
        },
      );
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    locationController.dispose();
    contactController.dispose();
    spouseNameController.dispose();
    childrenController.dispose();
    relativeContactController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MemberController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Member'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Profile Picture:'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickImage('profile'),
                        child: const Text('Pick Profile Picture'),
                      ),
                      const SizedBox(width: 16),
                      if (profilePic != null)
                        Image.file(
                          profilePic!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: fullNameController,
                labelText: 'Full Name',
                hintText: 'Enter full name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Additional Image:'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickImage('additional'),
                        child: const Text('Pick Additional Image'),
                      ),
                      const SizedBox(width: 16),
                      if (additionalImage != null)
                        Image.file(
                          additionalImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: locationController,
                labelText: 'Location',
                hintText: 'Enter location',
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: contactController,
                labelText: 'Contact',
                hintText: 'Enter contact number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: marriageStatus,
                items: [
                  'Single',
                  'Married',
                  'Widowed',
                  'Divorced',
                ].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Marriage Status',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    marriageStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: spouseNameController,
                labelText: 'Spouse Name',
                hintText: 'Enter spouse name',
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: childrenController,
                labelText: 'Children (comma separated)',
                hintText: 'Enter children names',
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: relativeContactController,
                labelText: 'Relative Contact',
                hintText: 'Enter relative contact',
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: dateOfBirthController,
                labelText: 'Date of Birth (YYYY-MM-DD)',
                hintText: 'Enter date of birth',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  submitForm();
                },
                child: const Text('Add Member'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
