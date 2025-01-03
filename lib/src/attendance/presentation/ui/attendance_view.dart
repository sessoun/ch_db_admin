import 'package:ch_db_admin/src/Members/presentation/controller/member._controller.dart';
import 'package:ch_db_admin/src/attendance/presentation/controller/attendance_controller.dart';
import 'package:ch_db_admin/src/attendance/presentation/ui/new_attendance.dart';
import 'package:flutter/material.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/attendance/domain/entities/attendance.dart';
import 'package:provider/provider.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  Future<void> getAllAttendance() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<AttendanceController>().fetchAllAttendance();
      },
    );
  }

  String searchText = '';

  @override
  void initState() {
    super.initState();
    getAllAttendance();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceController = context.watch<AttendanceController>();
    final filteredAttendance = attendanceController.attendanceList
        .where((record) =>
            record.event.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            Consumer<AttendanceController>(builder: (context, controller, _) {
          if (controller.message != null &&
              controller.message!.contains('Error')) {
            return Center(child: Text(controller.message!));
          }
          return controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by Event...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: filteredAttendance.isEmpty
                          ? const Center(
                              child: Text(
                                'No attendance records found.',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : _buildListView(filteredAttendance),
                    ),
                  ],
                );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: '//',
        onPressed: _createNewAttendance,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView(List<Attendance> records) {
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return GestureDetector(
          onTap: () {
            _showMembersDialog(record.members);
          },
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event: ${record.event}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Created At: ${record.createdAt.toLocal().toIso8601String().split('T')[0]}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        record.members.length.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMembersDialog(List<Member> members) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Members'),
          content: SizedBox(
            height: 200,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  title: Text(member.fullName),
                  subtitle: Text('Role: ${member.role}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _createNewAttendance() {
    final members = context.read<MemberController>().members;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAttendanceView(
          allMembers: members,
        ), // Replace with actual page
      ),
    );
  }
}
