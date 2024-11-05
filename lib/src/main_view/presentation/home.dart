import 'dart:math';

import 'package:ch_db_admin/src/Dashboard/dash_borad_view.dart';
import 'package:ch_db_admin/src/Members/presentation/ui/members_view.dart';
import 'package:ch_db_admin/src/attendance/presentation/attendance_view.dart';
import 'package:ch_db_admin/src/events/presentation/ui/events_view.dart';
import 'package:ch_db_admin/src/main_view/controller/main_view_controller.dart';
import 'package:ch_db_admin/src/main_view/presentation/side_menu_view.dart';
import 'package:ch_db_admin/src/notifications/presentation/ui/notifications_view.dart';
import 'package:ch_db_admin/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    context.read<MainViewController>().init(setState: update, vsync: this);
    // checkPrefs();
    super.initState();
  }

  void checkPrefs() async {
    await _checkPreferences(context);
  }

  // Define preset colors
  final List<Color> presetColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.yellow,
    Colors.brown,
  ];

  Future<void> _checkPreferences(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // Check if theme preferences are already saved
    if (!prefs.containsKey('isDarkMode') ||
        !prefs.containsKey('primaryColor')) {
      // If not saved, show theme dialog to let the user choose
      _showThemeDialog(context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
    }
  }

  void _showThemeDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
              const SizedBox(height: 20),
              const Text('Choose Primary Color:'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10.0,
                children: presetColors.map((color) {
                  return GestureDetector(
                    onTap: () async {
                      themeProvider.setPrimaryColor(color);
                      // Save preferences after selecting the color and theme
                      await savePreferences(themeProvider.isDarkMode,
                          themeProvider.theme.primaryColor);

                      // Close the dialog after saving
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomeView(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: themeProvider.theme.primaryColor == color
                              ? Colors.black
                              : Colors.transparent,
                          width: 3.0,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    var controller = context.read<MainViewController>();
    var watchController = context.watch<MainViewController>();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.fastOutSlowIn,
                height: MediaQuery.sizeOf(context).height,
                width: 288,
                left: watchController.isMenuOpened ? 0 : -288,
                child: const SideMenuView()),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                //rotate 30 degress
                ..rotateY(controller.animation.value -
                    30 * controller.animation.value * pi / 180),
              child: Transform.translate(
                offset: Offset(controller.animation.value * 265, 0),
                child: Transform.scale(
                    scale: controller.scaleAnimation.value,
                    child: ClipRRect(
                        borderRadius: controller.isMenuOpened
                            ? BorderRadius.circular(15)
                            : BorderRadius.zero,
                        child: const HomeBodyView())),
              ),
            ),
            AnimatedPositioned(
                left: watchController.isMenuOpened ? screenWidth * .8 : 20,
                top: 8,
                duration: const Duration(milliseconds: 250),
                child: GestureDetector(
                  onTap: () {
                    controller.toggleMenuOpened();
                  },
                  child: CircleAvatar(
                    child: watchController.isMenuOpened == true
                        ? const Icon(Icons.close)
                        : const Icon(Icons.menu),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class HomeBodyView extends StatefulWidget {
  const HomeBodyView({super.key});

  @override
  State<HomeBodyView> createState() => _HomeBodyViewState();
}

class _HomeBodyViewState extends State<HomeBodyView> {
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    context.read<MainViewController>().initIt(setState: update);
  }

  var views = const [
    DashboardView(),
    MembersView(),
    AttendanceView(),
    EventsView(),
    NotificationsView()
  ];
  @override
  Widget build(BuildContext context) {
    var controller = context.read<MainViewController>();
    return PageView.builder(
        itemCount: views.length,
        controller: controller.pageController,
        itemBuilder: (context, index) => views[index]);
  }
}
