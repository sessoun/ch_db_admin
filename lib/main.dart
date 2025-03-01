import 'package:ch_db_admin/firebase_options.dart';
import 'package:ch_db_admin/src/Members/presentation/controller/member._controller.dart';
import 'package:ch_db_admin/src/attendance/presentation/controller/attendance_controller.dart';
import 'package:ch_db_admin/src/dependencies/attendance.dart';
import 'package:ch_db_admin/src/dependencies/auth.dart';
import 'package:ch_db_admin/src/dependencies/events.dart';
import 'package:ch_db_admin/src/dependencies/member.dart';
import 'package:ch_db_admin/src/auth/presentation/ui/login.dart';
import 'package:ch_db_admin/src/events/presentation/controller/event_controller.dart';
import 'package:ch_db_admin/src/main_view/controller/main_view_controller.dart';
import 'package:ch_db_admin/src/main_view/presentation/home.dart';
import 'package:ch_db_admin/theme/apptheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await loadPreferences();
  //initialize dependencies
  initAuthDep();
  initMemberDep();
  initEventDep();
  initAttendanceDep();
  final prefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(
    () => prefs,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //increase cache memory size
  configureCache();
  runApp(MyApp(preferences['isDarkMode'], preferences['primaryColor']));
}

void configureCache() {
  PaintingBinding.instance.imageCache.maximumSizeBytes =
      300 * 1024 * 1024; // 300 MB
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;
  final Color primaryColor;

  const MyApp(this.isDarkMode, this.primaryColor, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(isDarkMode, primaryColor),
        ),
        ChangeNotifierProvider(
          create: (context) => MainViewController(),
        ),
        ChangeNotifierProvider(
          create: (context) => authController,
        ),
        ChangeNotifierProvider(
          create: (context) => locator.get<MemberController>(),
        ),
        ChangeNotifierProvider(
          create: (context) => locator.get<EventController>(),
        ),
        ChangeNotifierProvider(
          create: (context) => locator.get<AttendanceController>(),
        ),
      ],
      builder: (context, _) {
        // Access the ThemeProvider instance
        final themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          theme: themeProvider.theme,
          darkTheme: themeProvider.theme,
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const AuthState(),
        );
      },
    );
  }
}

class AuthState extends StatefulWidget {
  const AuthState({super.key});

  @override
  State<AuthState> createState() => _AuthStateState();
}

class _AuthStateState extends State<AuthState> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  // void checkPrefs() async {
  //   await _checkPreferences(context);
  // }

  // // Define preset colors
  // final List<Color> presetColors = [
  //   Colors.red,
  //   Colors.green,
  //   Colors.blue,
  //   Colors.orange,
  //   Colors.purple,
  //   Colors.teal,
  //   Colors.pink,
  //   Colors.indigo,
  //   Colors.yellow,
  //   Colors.brown,
  // ];

  // Future<void> _checkPreferences(BuildContext context) async {
  //   final prefs = locator.get<SharedPreferences>();
  //   // Check if theme preferences are already saved
  //   if (!prefs.containsKey('isDarkMode') ||
  //       !prefs.containsKey('primaryColor')) {
  //     // If not saved, show theme dialog to let the user choose
  //     _showThemeDialog(context);
  //   } else {
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (context) => const HomeView(),
  //       ),
  //     );
  //   }
  // }

  // void _showThemeDialog(BuildContext context) {
  //   final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Choose Theme'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             SwitchListTile(
  //               title: const Text('Dark Mode'),
  //               value: themeProvider.isDarkMode,
  //               onChanged: (value) {
  //                 themeProvider.toggleTheme();
  //               },
  //             ),
  //             const SizedBox(height: 20),
  //             const Text('Choose Primary Color:'),
  //             const SizedBox(height: 10),
  //             Wrap(
  //               spacing: 10.0,
  //               children: presetColors.map((color) {
  //                 return GestureDetector(
  //                   onTap: () async {
  //                     themeProvider.setPrimaryColor(color);
  //                     // Save preferences after selecting the color and theme
  //                     await savePreferences(themeProvider.isDarkMode,
  //                         themeProvider.theme.primaryColor);

  //                     // Close the dialog after saving
  //                     Navigator.of(context).pushAndRemoveUntil(
  //                       MaterialPageRoute(
  //                         builder: (context) => const HomeView(),
  //                       ),
  //                       (route) => false,
  //                     );
  //                   },
  //                   child: Container(
  //                     width: 40,
  //                     height: 40,
  //                     decoration: BoxDecoration(
  //                       color: color,
  //                       shape: BoxShape.circle,
  //                       border: Border.all(
  //                         color: themeProvider.theme.primaryColor == color
  //                             ? Colors.black
  //                             : Colors.transparent,
  //                         width: 3.0,
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               }).toList(),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const LoginView();
    }
    return const HomeView();
  }
}
