import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/src/Members/presentation/controller/member._controller.dart';
import 'package:ch_db_admin/src/dependencies/auth.dart';
import 'package:ch_db_admin/src/auth/presentation/controller/auth_controller.dart';
import 'package:ch_db_admin/src/auth/presentation/ui/login.dart';
import 'package:ch_db_admin/src/main_view/controller/main_view_controller.dart';
import 'package:ch_db_admin/src/settings/settings.dart';
import 'package:ch_db_admin/theme/apptheme.dart';
import 'package:ch_db_admin/src/main_view/presentation/menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Center(
                child: ListTile(
                  title: Text(
                      locator.get<SharedPreferences>().getString('orgName') ??
                          'Admin',
                      style: const TextStyle(fontSize: 25)),
                  // leading: const CircleAvatar(
                  //   child: Icon(Icons.person),
                  // ),
                ),
              ),
            ),
            ...List.generate(
                navItems.length,
                (index) => MenuTile(
                      title: navItems[index]['title'],
                      icon: navItems[index]['icon'],
                      onTap: () async {
                        controller.updatePage(index);
                      },
                      isSelected:
                          context.watch<MainViewController>().initialPage ==
                              index,
                    )),
            const Spacer(),
            MenuTile(
              title: 'Settings',
              icon: Icons.settings,
              showTrailingIcon: false,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsView(),
                ));
              },
            ),
            MenuTile(
              title: '${watchTheme.isDarkMode ? 'Dark' : 'Light'}' ' Mode',
              icon: watchTheme.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              showTrailingIcon: false,
              onTap: () async {
                themeProvider.toggleTheme();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: MenuTile(
                title: 'Logout',
                icon: Icons.logout,
                showTrailingIcon: false,
                onTap: () async {
                  await context.read<AuthController>().signOut().then(
                        (result) => result.fold(
                          (l) => NotificationUtil.showError(context, l.message),
                          (r) {
                            context.read<MemberController>().clearState();

                            controller.toggleMenuOpened();

                            NotificationUtil.showSuccess(context, r);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginView(),
                                ),
                                (r) => false);
                          },
                        ),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> navItems = [
  // {
  //   'icon': Icons.dashboard,
  //   'title': 'Dashboard',
  // },
  {
    'icon': Icons.group,
    'title': 'Members',
  },
  {
    'icon': Icons.calendar_today,
    'title': 'Attendance',
  },
  // {
  //   'icon': Icons.event,
  //   'title': 'Events',
  // },
  {
    'icon': Icons.notifications,
    'title': 'Birthdays',
  },
];
