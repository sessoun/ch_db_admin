import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';

class MemberDetailView extends StatefulWidget {
  final Member member;

  const MemberDetailView({super.key, required this.member});

  @override
  State<MemberDetailView> createState() => _MemberDetailViewState();
}

class _MemberDetailViewState extends State<MemberDetailView> {
  bool isEditing = false;

  // Text controllers for form fields
  late TextEditingController fullNameController;
  late TextEditingController locationController;
  late TextEditingController contactController;
  late TextEditingController marriageStatusController;
  late TextEditingController spouseNameController;
  late TextEditingController relativeContactController;
  late TextEditingController roleController;
  late TextEditingController dateOfBirthController;

  // Dropdown and multi-select options
  List<String> groupOptions = [
    'Choir',
    'Youth Ministry',
    'Women Ministry',
    'Men Ministry'
  ];
  List<String> roleOptions = [
    'Elder',
    'Deacon',
    'Deaconess',
    'Teacher',
    'None'
  ];
  List<String> selectedGroups = [];

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data from the Member object
    fullNameController = TextEditingController(text: widget.member.fullName);
    locationController = TextEditingController(text: widget.member.location);
    contactController = TextEditingController(text: widget.member.contact);
    marriageStatusController =
        TextEditingController(text: widget.member.marriageStatus);
    spouseNameController =
        TextEditingController(text: widget.member.spouseName ?? '');
    relativeContactController =
        TextEditingController(text: widget.member.relativeContact ?? '');
    roleController = TextEditingController(text: widget.member.role);
    dateOfBirthController = TextEditingController(
        text: widget.member.dateOfBirth.toLocal().toString().split(' ')[0]);

    selectedGroups = widget.member.groupAffiliate ?? [];
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    fullNameController.dispose();
    locationController.dispose();
    contactController.dispose();
    marriageStatusController.dispose();
    spouseNameController.dispose();
    relativeContactController.dispose();
    roleController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  // Toggle edit mode
  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Detail'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: toggleEditMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField('Full Name', fullNameController),
            buildTextField('Location', locationController),
            buildTextField('Contact', contactController),
            buildTextField('Marriage Status', marriageStatusController),
            buildTextField('Spouse Name', spouseNameController),
            buildTextField('Relative Contact', relativeContactController),
            buildTextField('Role', roleController),
            buildTextField('Date of Birth', dateOfBirthController,
                isReadOnly: true),

            const SizedBox(height: 16),
            // Group Affiliations Dropdown Multi-select
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Group Affiliations',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ),
            Wrap(
              spacing: 8.0,
              children: groupOptions.map((group) {
                return ChoiceChip(
                  label: Text(group),
                  selected: selectedGroups.contains(group),
                  onSelected: isEditing
                      ? (selected) {
                          setState(() {
                            selected
                                ? selectedGroups.add(group)
                                : selectedGroups.remove(group);
                          });
                        }
                      : null,
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            // Dropdown for Role
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Role',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ),
            DropdownButtonFormField<String>(
              value: widget.member.role ?? 'None',
              items: roleOptions
                  .map((role) =>
                      DropdownMenuItem(value: role, child: Text(role)))
                  .toList(),
              onChanged: isEditing
                  ? (newRole) {
                      setState(() {
                        roleController.text = newRole!;
                      });
                    }
                  : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                enabled: isEditing,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Utility method to build a text field
  Widget buildTextField(String label, TextEditingController controller,
      {bool isReadOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        readOnly: !isEditing || isReadOnly,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isEditing ? Colors.white : Colors.grey[200],
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
