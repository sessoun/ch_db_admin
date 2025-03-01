import 'package:ch_db_admin/src/Members/notifications/data/models/notification.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  // Sample notification data
  final List<NotificationModel> notifications = [
    NotificationModel(
      title: 'Service Reminder',
      message: 'Sunday service at 9:00 AM.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      id: '',
    ),
    NotificationModel(
      title: 'Event Update',
      message: 'Youth Conference moved to 2:00 PM.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      id: '',
    ),
    NotificationModel(
      title: 'Special Announcement',
      message: 'New outreach program this weekend!',
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      id: '',
    ),
    // Add more notification records as needed
  ];

  String searchText = '';
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = notifications
        .where((notification) =>
            notification.title
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            notification.message
                .toLowerCase()
                .contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Notifications...',
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
            const Expanded(
                child: Center(
                    child: Text(
              'Anticipate!',
              style: TextStyle(
                fontSize: 30,
                fontStyle: FontStyle.italic,
              ),
            ))
                //  isGridView
                //     ? _buildGridView(filteredNotifications)
                //     : _buildListView(filteredNotifications),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<NotificationModel> notifications) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 2,
      ),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return GestureDetector(
          onTap: () {
            // Handle tap on notification
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications,
                      size: 36, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 8),
                  Text(
                    notification.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(List<NotificationModel> notifications) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
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
                  Icon(Icons.notifications,
                      size: 36, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Date: ${notification.timestamp.toLocal()}',
                          style: Theme.of(context).textTheme.bodySmall,
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
