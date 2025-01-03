import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/attendance/domain/entities/attendance.dart';
import 'package:ch_db_admin/src/attendance/presentation/controller/attendance_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAttendanceView extends StatefulWidget {
  final List<Member> allMembers;

  const CreateAttendanceView({super.key, required this.allMembers});

  @override
  State<CreateAttendanceView> createState() => _CreateAttendanceViewState();
}

class _CreateAttendanceViewState extends State<CreateAttendanceView> {
  final List<Member> selectedMembers = [];
  final TextEditingController eventController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AttendanceController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Attendance'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: eventController,
              decoration: InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: widget.allMembers.length,
                itemBuilder: (context, index) {
                  final member = widget.allMembers[index];
                  return CheckboxListTile(
                    title: Text(member.fullName),
                    subtitle: Text('Contact: ${member.contact}'),
                    value: selectedMembers.contains(member),
                    onChanged: (isSelected) {
                      setState(() {
                        if (isSelected ?? false) {
                          selectedMembers.add(member);
                        } else {
                          selectedMembers.remove(member);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (eventController.text.isEmpty) {
            NotificationUtil.showError(context, 'Event name is required');
            return;
          }

          final newAttendance = Attendance(
            members: selectedMembers,
            createdAt: DateTime.now(),
            event: eventController.text.trim(),
          );

          print(newAttendance);

          await controller.createAttendance(newAttendance).then((_) async {
            final message = controller.message!;
            if (message.contains('Error')) {
              NotificationUtil.showError(context, message);
            } else {
              NotificationUtil.showSuccess(context, message);
              await controller.fetchAllAttendance();
            }
          });
        },
        child: context.watch<AttendanceController>().isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const Icon(Icons.save),
      ),
    );
  }
}
