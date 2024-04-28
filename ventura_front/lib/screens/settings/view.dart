import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventura_front/screens/settings/components/theme_provider.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of
    <ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Preferences',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: Text('Theme'),
            subtitle: Text(
              themeProvider.getTheme() == ThemeData.dark()
                  ? 'Dark Mode'
                  : 'Light Mode',
              style: TextStyle(
                color: themeProvider.getTheme() == ThemeData.dark()
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            trailing: Switch(
              value: themeProvider.getTheme() == ThemeData.dark(),
              onChanged: (value) {
                _saveThemePreference(value);
                if (value) {
                  themeProvider.setDarkTheme();
                } else {
                  themeProvider.setLightTheme();
                }
              },
            ),
          ),
        ],
      ),
    );
 }

  // Método para guardar la preferencia del usuario
  void _saveThemePreference(bool isDarkTheme) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isDarkTheme', isDarkTheme);
}

}
