import 'dart:io';

import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/shared/utils/extensions.dart';
import 'package:ch_db_admin/shared/utils/upload_and_download.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/Members/presentation/controller/member._controller.dart';
import 'package:ch_db_admin/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../shared/utils/custom_print.dart';

class AddMemberView extends StatefulWidget {
  const AddMemberView({super.key, this.member});
  final Member? member;

  @override
  State<AddMemberView> createState() => _AddMemberViewState();
}

class _AddMemberViewState extends State<AddMemberView> {
  MemberStatus _selectedStatus = MemberStatus.newMember;

  final _formKey = GlobalKey<FormState>();
  // For local file OR network URL handling
  File? profilePicFile;
  String? profilePicUrl;
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

  /// Method to pick an image from camera or gallery

  Future<void> pickAndCropImage() async {
    // Step 1: Pick image
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
      requestFullMetadata: false,
      preferredCameraDevice: CameraDevice.rear,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFile != null) {
      // Step 2: Crop image
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Picture',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
          ),
          IOSUiSettings(
            title: 'Crop Profile Picture',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );
      miPrint('Cropped file path: ${croppedFile?.path}');
      setState(() =>
          profilePicFile = croppedFile != null ? File(croppedFile.path) : null);
    }
  }

  final List<String> groupAffiliations = [
    'Choir',
    'Youth Ministry',
    'Women Ministry',
    'Men Ministry',
    'Children Ministry',
    'Evangelism Ministry',
    'Hospitality',
    'Prayer Team',
    'Media Team',
    'Bible Study Group',
    'Outreach Program',
    'Community Service',
    'Counseling',
    'Finance Team',
    'Maintenance Team',
    'Missionary Work',
    'Other',
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

    if (_formKey.currentState!.validate() && profilePicFile != null ||
        profilePicUrl != null) {
      String profileImage = profilePicUrl ?? '';

      try {
        provider.setLoading(true);
        if (profilePicFile != null) {
          // Process the local file
          profileImage = await processImageToStore(
            context,
            selectedImage: profilePicFile!,
          );
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
        status: _selectedStatus,
        spouseName: spouseNameController.text,
        children: childrenController.text
            .split(',')
            .map((child) => child.trim())
            .toList(),
        relativeContact: relativeContactController.text,
        groupAffiliate: selectedAffiliations,
        role: selectedRole,
        dateOfBirth: DateTime.parse(dateOfBirthController.text.trim()),
      );

      if (widget.member != null) {
        await provider.updateMember(newMember.id!, newMember).then(
          (_) {
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
    } else if (_formKey.currentState!.validate() && profilePicFile == null) {
      NotificationUtil.showError(context, "Profile picture must be provided");
    } else {
      NotificationUtil.showError(
          context, "Some fields are required, including profile picture");
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.member != null) {
      // Handle existing member data
      if (widget.member?.profilePic != null) {
        String path = widget.member!.profilePic!;
        miPrint(path);
        if (path.startsWith('http')) {
          profilePicUrl = path; // Store as URL
        }
      }

      selectedRole = widget.member?.role ?? selectedRole;
      selectedAffiliations =
          widget.member?.groupAffiliate ?? selectedAffiliations;
    }

    if (widget.member?.status != null) {
      _selectedStatus = widget.member!.status;
    }

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
                        onPressed: () => pickAndCropImage(),
                        child: const Text('Pick Profile Picture'),
                      ),
                      const SizedBox(width: 16),
                      // Display profile image (file or URL)
                      if (profilePicFile != null)
                        Image.file(
                          profilePicFile!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      else if (profilePicUrl != null)
                        Image.network(
                          profilePicUrl!,
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
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<MemberStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Member Status',
                ),
                onChanged: (MemberStatus? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                  miPrint(_selectedStatus.name);
                  miPrint(newValue);
                },
                items: MemberStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status == MemberStatus.newMember
                          ? 'New'
                          : status == MemberStatus.active
                              ? 'Active'
                              : status == MemberStatus.visitor
                                  ? 'Visitor'
                                  : status == MemberStatus.inactive
                                      ? 'Inactive'
                                      : 'Unknown',
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: marriageStatus,
                items: [
                  'Single',
                  'Married',
                  'Widowed',
                  'Divorced',
                  'Separated',
                  'Engaged',
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
                hintText: 'Enter date of birth (YYYY-MM-DD)',
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
                      miPrint(selectedAffiliations);
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
                  miPrint(selectedRole);
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
