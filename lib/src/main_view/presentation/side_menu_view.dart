import 'package:ch_db_admin/src/main_view/controller/main_view_controller.dart';
import 'package:ch_db_admin/src/theme/apptheme.dart';
import 'package:ch_db_admin/src/main_view/presentation/menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenuView extends StatefulWidget {
  const SideMenuView({super.key});

  @override
  State<SideMenuView> createState() => _SideMenuViewState();
}

class _SideMenuViewState extends State<SideMenuView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    var controller = context.read<MainViewController>();
    var watchTheme = context.watch<ThemeProvider>();

    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          // ignore: prefer_const_constructors
          SizedBox(
            height: 100,
            child: const Center(
              child: ListTile(
                title: Text('Church Admin', style: TextStyle(fontSize: 25)),
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          ...List.generate(
              navItems.length,
              (index) => MenuTile(
                    title: navItems[index]['title'],
                    icon: navItems[index]['icon'],
                    onTap: () {
                      controller.updatePage(index);
                    },
                  )),
          const Spacer(),
          const MenuTile(
            title: 'Settings',
            icon: Icons.settings,
            showTrailingIcon: false,
          ),
          MenuTile(
            title: '${watchTheme.isDarkMode ? 'Dark' : 'Light'}' ' Mode',
            icon: watchTheme.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            showTrailingIcon: false,
            onTap: () async {
              themeProvider.toggleTheme();
            },
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: MenuTile(
              title: 'Logout',
              icon: Icons.logout,
              showTrailingIcon: false,
            ),
          ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> navItems = [
  {
    'icon': Icons.dashboard,
    'title': 'Dashboard',
  },
  {
    'icon': Icons.group,
    'title': 'Members',
  },
  {
    'icon': Icons.calendar_today,
    'title': 'Attendance',
  },
  {
    'icon': Icons.event,
    'title': 'Events',
  },
  {
    'icon': Icons.notifications,
    'title': 'Notifications',
  },
];
