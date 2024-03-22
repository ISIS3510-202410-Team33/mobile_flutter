import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'components/homeIcon_component.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
  }

  bool switchValue1 = true;
  bool switchValue2 = true;
  bool switchValue3 = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF16171B), Color(0xFF353A40)],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft),
      ),
      width: double.infinity,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: Text('App Settings', style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFF353A40),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: HomeIcon(),
              )
            ]),
        body: ListView(
          children: [
            Container(
              width: double.infinity,
              color: Color(0xFF555555),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                child: Text(
                  "GENERAL",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            _buildSwitchOption('Use Wifi only', switchValue1),
            _buildDropdownOption(
                'Wifi Data Usage',
                ['Automatic', 'Limit data usage', 'Background data'],
                'Automatic'),
            _buildDropdownOption(
                'Language', ['English', 'Spanish', 'French'], 'English'),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              color: Color(0xFF555555),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                child: Text(
                  "PREFERENCES",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            _buildDropdownOption('Theme', ['Light', 'Dark'], 'Dark'),
            _buildSwitchOption('Allow notifications', switchValue3),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              color: Color(0xFF555555),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                child: Text(
                  "SUPPORT",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Help Center',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchOption(String title, bool initialValue) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: Switch(
        value: initialValue,
        onChanged: (value) {},
        activeTrackColor: Color(0xFF353A40),
        activeColor: Color(0xFF555555),
      ),
    );
  }

  Widget _buildDropdownOption(
      String title, List<String> options, String initialValue) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: DropdownButton<String>(
        value: initialValue,
        onChanged: (newValue) {},
        style: TextStyle(color: Colors.white),
        dropdownColor: Color(0xFF353A40),
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
