import 'package:flutter/material.dart';
import 'package:ventura_front/screens/map/view.dart';

class MyButton extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final String title;
  final String description;

  const MyButton({
    super.key,
    required this.iconData,
    required this.color,
    required this.title,
    required this.description,
  
  });


  @override
  Widget build (BuildContext context) {
    
    return InkWell(
      onTap: (){
        if (title == "Map"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapView())
          );
        }

        else if (title == "Schedule"){
          print("Schedule");
        }
        else if (title == "Settings"){
          print("Settings");
        }
        else if (title == "Profile"){
          print("Profile");
        }


      },
      
      child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF262E32),
                    borderRadius: BorderRadius.circular(60)
                  ),
                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 50, right: 50),
                  child: Row(children: [
                    Icon(iconData, color: color, size: 30),
                    const SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
                        Text(description, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ],)
              )
    );
  }
}