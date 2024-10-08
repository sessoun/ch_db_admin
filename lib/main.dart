import 'package:ch_db_admin/src/theme/apptheme.dart';
import 'package:ch_db_admin/src/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await loadPreferences();
  runApp(MyApp(preferences['isDarkMode'], preferences['primaryColor']));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;
  final Color primaryColor;

  MyApp(this.isDarkMode, this.primaryColor);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(isDarkMode, primaryColor),
        ),
      ],
      builder: (context, _) {
        // Access the ThemeProvider instance
        final themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          theme: themeProvider.theme,
          darkTheme: themeProvider.theme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          // home: const LoginScreen(),
        );
      },
    );
  }
}
