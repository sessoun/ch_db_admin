import 'dart:io';

import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/shared/utils/extensions.dart';
import 'package:ch_db_admin/shared/utils/upload_and_download.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/Members/presentation/controller/member._controller.dart';
import 'package:ch_db_admin/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddMemberView extends StatefulWidget {
  const AddMemberView({super.key, this.member});
  final Member? member;

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
  late TextEditingController fullNameController;
  late TextEditingController locationController;
  late TextEditingController contactController;
  late TextEditingController spouseNameController;
  late TextEditingController childrenController;
  late TextEditingController relativeContactController;
  late TextEditingController dateOfBirthController;

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

  final List<String> groupAffiliations = [
    'Choir',
    'Youth Ministry',
    'Women Ministry',
    'Men Ministry',
  ];
  List<String> selectedAffiliations = [];
  String selectedRole = 'None';

  void toggleAffiliation(String affiliation) {
    setState(() {
      if (selectedAffiliations.contains(affiliation)) {
        selectedAffiliations.remove(affiliation);
      } else {
        selectedAffiliations.add(affiliation);
      }
    });
  }

  Future<void> submitForm() async {
    final provider = context.read<MemberController>();

    if (_formKey.currentState!.validate()) {
      String profileImage = profilePic?.path ?? '';
      String otherImage = additionalImage?.path ?? '';

      try {
        provider.setLoading(true);
        if (profilePic != null || additionalImage != null) {
          //if not in editting mode
          if (!profileImage.contains('https://')) {
            profileImage = await imageStore(
              context,
              fileFolder: 'profilePics',
              imageUrl: profileImage,
              selectedImage: profilePic!,
            );
          }
          if (!otherImage.contains('https://')) {
            otherImage = await imageStore(
              // ignore: use_build_context_synchronously
              context,
              fileFolder: 'otherImages',
              imageUrl: otherImage,
              selectedImage: additionalImage!,
            );
          }
        }
      } on FirebaseException catch (_) {
        provider.setLoading(false);
        if (mounted) {
          NotificationUtil.showError(
              context, 'Failed to upload image. Please try again.');
        }
      }

      Member newMember = Member(
        id: widget.member?.id,
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
        groupAffiliate: selectedAffiliations,
        role: selectedRole,
        dateOfBirth: DateTime.parse(dateOfBirthController.text),
      );
      print(newMember.role);
      if (widget.member != null) {
        await provider.updateMember(newMember.id!, newMember).then(
          (result) {
            if (provider.statusMessage.contains('Error')) {
              NotificationUtil.showError(context, provider.statusMessage);
            } else {
              NotificationUtil.showSuccess(context, provider.statusMessage);
            }
          },
        );
      } else {
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
      print(newMember.role);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.member != null) {
      profilePic = File(widget.member?.profilePic ?? '');
      additionalImage = File(widget.member?.additionalImage ?? '');
      selectedRole = widget.member?.role ?? selectedRole;
      selectedAffiliations =
          widget.member?.groupAffiliate ?? selectedAffiliations;
    }
    print(selectedAffiliations);
    print(selectedRole);
    fullNameController = TextEditingController(text: widget.member?.fullName);
    locationController = TextEditingController(text: widget.member?.location);
    contactController = TextEditingController(text: widget.member?.contact);
    spouseNameController =
        TextEditingController(text: widget.member?.spouseName);
    childrenController =
        TextEditingController(text: widget.member?.children?.join(','));
    relativeContactController =
        TextEditingController(text: widget.member?.relativeContact);
    dateOfBirthController = TextEditingController(
        text: widget.member?.dateOfBirth.toIso8601String().split('T')[0]);
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
    // final provider = context.read<MemberController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.member != null ? 'Update Member Details' : 'Add Member'),
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
                      if (profilePic != null &&
                          !profilePic!.path.contains('https://'))
                        Image.file(
                          profilePic!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      if (profilePic != null &&
                          profilePic!.path.contains('https://'))
                        Image.network(
                          profilePic!.path,
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
                      if (additionalImage != null &&
                          !additionalImage!.path.contains('https://'))
                        Image.file(
                          additionalImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      if (additionalImage != null &&
                          additionalImage!.path.contains('https://'))
                        Image.network(
                          additionalImage!.path,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Group Affiliations'),
              Column(
                children: groupAffiliations.map((affiliation) {
                  return CheckboxListTile(
                    title: Text(affiliation),
                    value: selectedAffiliations.contains(affiliation),
                    onChanged: (_) {
                      toggleAffiliation(affiliation);
                      print(selectedAffiliations);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: [
                  'None',
                  'Elder',
                  'Deacon',
                  'Deaconess',
                  'Teacher',
                ].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                  print(selectedRole);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  submitForm();
                },
                child:
                    Text(widget.member != null ? 'Save Changes' : 'Add Member'),
              ).loadingIndicator(
                  context, context.watch<MemberController>().isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
