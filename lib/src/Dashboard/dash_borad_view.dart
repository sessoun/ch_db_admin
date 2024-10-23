import 'package:ch_db_admin/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back!',
              style: themeProvider.theme.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildDashboardCard(
                  context,
                  icon: Icons.group,
                  label: 'Members',
                  onTap: () {
                    // Navigate to members page
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.event,
                  label: 'Events',
                  onTap: () {
                    // Navigate to events page
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.check_circle,
                  label: 'Attendance',
                  onTap: () {
                    // Navigate to attendance page
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.notifications,
                  label: 'Notifications',
                  onTap: () {
                    // Navigate to notifications page
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Divider(color: themeProvider.theme.primaryColor, thickness: 1),
            const SizedBox(height: 16.0),
            Text(
              'Recent Activities',
              style: themeProvider.theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _buildActivityListItem(context, 'You have 5 new members registered'),
            _buildActivityListItem(context, 'New event: Community Outreach'),
            _buildActivityListItem(context, 'Attendance report is ready'),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: theme.primaryColor),
              const SizedBox(height: 12),
              Text(label, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityListItem(BuildContext context, String activity) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.circle, color: theme.primaryColor, size: 10),
      title: Text(activity, style: theme.textTheme.bodyMedium),
    );
  }
}
