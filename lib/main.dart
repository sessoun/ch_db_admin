import 'package:ch_db_admin/firebase_options.dart';
import 'package:ch_db_admin/src/dependencies/auth.dart';
import 'package:ch_db_admin/src/login/presentation/ui/login.dart';
import 'package:ch_db_admin/src/main_view/controller/main_view_controller.dart';
import 'package:ch_db_admin/src/theme/apptheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await loadPreferences();
  //initialize dependencies
  initAuthDep();
  runApp(MyApp(preferences['isDarkMode'], preferences['primaryColor']));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        )
      ],
      builder: (context, _) {
        // Access the ThemeProvider instance
        final themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          theme: themeProvider.theme,
          darkTheme: themeProvider.theme,
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const LoginView(),
        );
      },
    );
  }
}
