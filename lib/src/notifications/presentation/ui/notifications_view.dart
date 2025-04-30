import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/Members/presentation/controller/member._controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  String searchText = '';
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    final birthdays = context.read<MemberController>().members;
    final filteredNotifications = birthdays
        .where((notification) =>
            notification.dateOfBirth.month == DateTime.now().month &&
            notification.dateOfBirth.day > DateTime.now().day &&
            notification.dateOfBirth.day <= DateTime.now().day + 7)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Birthday Notices'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Expanded(
              child: _buildListView(filteredNotifications),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<Member> notifications) {
    return notifications.isEmpty
        ? const Center(child: Text('No birthdays at the moment'))
        : ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final member = notifications[index];
              return GestureDetector(
                onTap: () {
                  // Handle tap on notification
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month,
                            size: 36, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.fullName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${member.fullName} has a birthday on ${member.dateOfBirth.day}/${member.dateOfBirth.month}',
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
