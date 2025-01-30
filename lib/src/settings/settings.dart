import 'package:ch_db_admin/src/main_view/presentation/menu_tile.dart';
import 'package:ch_db_admin/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
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
    const Color(0xFF5E5501),
    Colors.brown,
  ];

  void _showThemeDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose a prefered color:'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 10.0,
                runSpacing: 10,
                children: presetColors.map((color) {
                  return GestureDetector(
                    onTap: () async {
                      themeProvider.setPrimaryColor(color);
                      // Save preferences after selecting the color and theme
                      await savePreferences(themeProvider.isDarkMode,
                          themeProvider.theme.primaryColor);

                      // Close the dialog after saving
                      Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MenuTile(
              title: 'Change App Colour',
              showTrailingIcon: false,
              onTap: () {
                _showThemeDialog(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
