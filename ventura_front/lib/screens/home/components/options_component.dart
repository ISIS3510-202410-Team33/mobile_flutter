import 'package:flutter/material.dart';
import 'package:ventura_front/screens/home/view.dart';
import './ButtonElement.dart';

class Options extends StatefulWidget {
  final HomeViewContentState homeViewContentState;
  const Options({super.key, required this.homeViewContentState});

  @override
  State<Options> createState() => OptionsState();
}

class DataWidget {
  String name;
  IconData icon;
  Color color;
  String description;

  DataWidget(this.name, this.icon, this.color, this.description);
}

class OptionsState extends State<Options> {
  var dataWidgets = [
    DataWidget("Map", Icons.home, Colors.white, "Navigate Through campus"),
    DataWidget("Schedule", Icons.schedule, Colors.white, "Watch your projects"),
    DataWidget("Grades", Icons.grading, Colors.white, "Set your grades"),
    DataWidget("Profile", Icons.person, Colors.white, "Set your profile"),
    DataWidget("Settings", Icons.settings, Colors.white, "Set your settings"),
  ];
  var optionWidgets = <Widget>[];

  void initializeOptions() {
    for (var element in dataWidgets) {
      optionWidgets.add(const SizedBox(height: 20));
      optionWidgets.add(
        Material(
          color: const Color(0xFF262E32),
          elevation: 10,
          shadowColor: Colors.black,
          borderRadius: BorderRadius.circular(60),
          child: MyButton(
            color: element.color,
            iconData: element.icon,
            title: element.name,
            description: element.description,
            homeViewContentState: widget.homeViewContentState,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initializeOptions();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(60),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: optionWidgets,
        ),
      ),
    );
  }
}
