import 'package:ch_db_admin/auth_state.dart';
import 'package:ch_db_admin/firebase_options.dart';
import 'package:ch_db_admin/src/Members/presentation/controller/member._controller.dart';
import 'package:ch_db_admin/src/attendance/presentation/controller/attendance_controller.dart';
import 'package:ch_db_admin/src/dependencies/attendance.dart';
import 'package:ch_db_admin/src/dependencies/auth.dart';
import 'package:ch_db_admin/src/dependencies/events.dart';
import 'package:ch_db_admin/src/dependencies/member.dart';
import 'package:ch_db_admin/src/events/presentation/controller/event_controller.dart';
import 'package:ch_db_admin/src/main_view/controller/main_view_controller.dart';
import 'package:ch_db_admin/theme/apptheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  await dotenv.load(fileName: '.env');

  runApp(MyApp(preferences['isDarkMode'], preferences['primaryColor']));
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
