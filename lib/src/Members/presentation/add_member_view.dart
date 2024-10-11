import 'dart:io';

import 'package:ch_db_admin/src/Members/data/models/member_model.dart';
import 'package:ch_db_admin/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMemberView extends StatefulWidget {
  const AddMemberView({super.key});

  @override
  State<AddMemberView> createState() => _AddMemberViewState();
}

class _AddMemberViewState extends State<AddMemberView> {
  final _formKey = GlobalKey<FormState>();
  String profilePic = '';
  String additionalImage = '';
  String fullName = '';
  String location = '';
  String contact = '';
  String marriageStatus = 'Single';
  String spouseName = '';
  List<String> children = [];
  String relativeContact = '';
  DateTime dateOfBirth = DateTime.now();

  // Create an instance of ImagePicker
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
          profilePic = pickedFile.path; // Save the selected image path
        } else {
          additionalImage =
              pickedFile.path; // Save the selected additional image path
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // Profile Picture Field
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
                      if (profilePic.isNotEmpty)
                        Image.file(
                          File(profilePic),
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
                labelText: 'Full Name',
                hintText: 'Enter full name',
                onSaved: (value) {
                  fullName = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Additional Image Field
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
                      if (additionalImage.isNotEmpty)
                        Image.file(
                          File(additionalImage),
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
                labelText: 'Location',
                hintText: 'Enter location',
                onSaved: (value) {
                  location = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Contact',
                hintText: 'Enter contact number',
                onSaved: (value) {
                  contact = value ?? '';
                },
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
                labelText: 'Spouse Name',
                hintText: 'Enter spouse name',
                onSaved: (value) {
                  spouseName = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Children (comma separated)',
                hintText: 'Enter children names',
                onSaved: (value) {
                  children =
                      value!.split(',').map((child) => child.trim()).toList();
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Relative Contact',
                hintText: 'Enter relative contact',
                onSaved: (value) {
                  relativeContact = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Date of Birth (YYYY-MM-DD)',
                hintText: 'Enter date of birth',
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    dateOfBirth = DateTime.parse(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Create a new member object and do something with it
                    MemberModel newMember = MemberModel(
                      profilePic: profilePic,
                      fullName: fullName,
                      location: location,
                      contact: contact,
                      marriageStatus: marriageStatus,
                      spouseName: spouseName,
                      children: children,
                      relativeContact: relativeContact,
                      additionalImage: additionalImage,
                      dateOfBirth: dateOfBirth,
                    );

                    // Perform your logic here (e.g., add member to the list or database)
                    Navigator.pop(
                        context); // Close the form after adding member
                  }
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
