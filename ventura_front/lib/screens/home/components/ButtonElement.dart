import 'package:flutter/material.dart';
import 'package:ventura_front/screens/home/view.dart';
import 'package:ventura_front/screens/map/view.dart';
import 'package:ventura_front/screens/profile/view.dart';
import 'package:ventura_front/screens/settings/view.dart';
import 'package:ventura_front/sensors_components/proximity_sensor.dart';

class MyButton extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final String title;
  final String description;
  final HomeViewContentState homeViewContentState;

  const MyButton({
    super.key,
    required this.iconData,
    required this.color,
    required this.title,
    required this.description,
    required this.homeViewContentState,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          if (title == "Map") {
            await Navigator.push(context, 
                MaterialPageRoute(builder: (context) =>  MapView(homeViewContentState: homeViewContentState,)));
                homeViewContentState.madeConnection();
          } else if (title == "Schedule") {
            print("Schedule");
          } else if (title == "Settings") {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsView()));
            homeViewContentState.madeConnection();
          } else if (title == "Profile") {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileView(homeViewContentState: homeViewContentState)));
            homeViewContentState.madeConnection();
          }
        },
        child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFF262E32),
                borderRadius: BorderRadius.circular(60)),
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 50, right: 50),
            child: Row(
              children: [
                Icon(iconData, color: color, size: 30),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                    Text(description,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ],
            )));
  }
}
