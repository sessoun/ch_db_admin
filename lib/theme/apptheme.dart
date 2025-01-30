import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  // Base light theme
  static ThemeData lightTheme(Color primaryColor) {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white70,
      cardColor: Colors.white,
      canvasColor: Colors.grey[50],
      dialogBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      iconTheme: const IconThemeData(color: Colors.black54),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor, foregroundColor: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    );
  }

  // Base dark theme
  static ThemeData darkTheme(Color primaryColor) {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.black26,
      cardColor: Colors.grey[900],
      canvasColor: Colors.grey[850],
      dialogBackgroundColor: Colors.grey[800],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.normal,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            textStyle: const TextStyle(color: Colors.white)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme;
  bool _isDarkMode;
  Color _primaryColor;

  ThemeProvider(this._isDarkMode, this._primaryColor)
      : _currentTheme = _isDarkMode
            ? AppTheme.darkTheme(_primaryColor)
            : AppTheme.lightTheme(_primaryColor);

  ThemeData get theme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _updateTheme();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    _updateTheme();
  }

  void _updateTheme() {
    _currentTheme = _isDarkMode
        ? AppTheme.darkTheme(_primaryColor)
        : AppTheme.lightTheme(_primaryColor);
    notifyListeners();
  }
}

Future<void> savePreferences(bool isDarkMode, Color primaryColor) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isDarkMode', isDarkMode);
  await prefs.setInt('primaryColor', primaryColor.value);
}

Future<Map<String, dynamic>> loadPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final primaryColor = prefs.getInt('primaryColor') ?? Colors.indigo.value;
  return {
    'isDarkMode': isDarkMode,
    'primaryColor': Color(primaryColor),
  };
}
