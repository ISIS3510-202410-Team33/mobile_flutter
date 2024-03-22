import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

import "../../services/models/location_model.dart";
import "../../services/models/user_model.dart";

import "../components/header_component.dart";


class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State createState() => MapViewState();
}

class MapViewState extends State{
  
  final UserModel user = UserModel(
    uuid: 1, 
    name: "Juan",
    studentCode: 202011638);

  final locations = [
    LocationModel(
      floors: 1, 
      name: "Bloque A", 
      greenAreas: 1,
      latitude: 1.00000, 
      longitude: 1.00000, 
      obstructions: false, 
      restaurants: 3),
    LocationModel(
      floors: 1, 
      name: "Bloque B", 
      greenAreas: 1,
      latitude: 1.00000, 
      longitude: 1.00000, 
      obstructions: false, 
      restaurants: 3),
    LocationModel(
      floors: 1, 
      name: "Bloque C", 
      greenAreas: 1,
      latitude: 1.00000, 
      longitude: 1.00000, 
      obstructions: false, 
      restaurants: 3),
    LocationModel(
      floors: 1, 
      name: "Bloque C", 
      greenAreas: 1,
      latitude: 1.00000, 
      longitude: 1.00000, 
      obstructions: false, 
      restaurants: 3),
    LocationModel(
      floors: 1, 
      name: "Bloque C", 
      greenAreas: 1,
      latitude: 1.00000, 
      longitude: 1.00000, 
      obstructions: false, 
      restaurants: 3),

    LocationModel(
      floors: 1, 
      name: "Bloque C", 
      greenAreas: 1,
      latitude: 1.00000, 
      longitude: 1.00000, 
      obstructions: false, 
      restaurants: 3),
    LocationModel(
      floors: 1, 
      name: "Bloque C", 
      greenAreas: 1,
      latitude: 1.00000, 
      longitude: 1.00000, 
      obstructions: false, 
      restaurants: 3),
      
      
  ];


  @override
  void initState() {

    super.initState();
  }

  Widget getLocationsWidget(){
    var widgets = <Widget>[];
    for (var location in locations){
      widgets.add(
        Column(
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(location.name, style: const TextStyle(color: Colors.white, fontSize: 16)),
              Row(children: [
                TextButton(onPressed: (){}, child: Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D3B40),
                    borderRadius: BorderRadius.circular(60)
                  ),
                  child: const Text("Ubicar", style: TextStyle(color: Colors.white, fontSize: 15))
                )),
      
              ],),
             
          ],),

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Áreas verdes: ${location.greenAreas}", style: const TextStyle(color: Colors.white, fontSize: 14)),
                  Text("Restaurantes: ${location.restaurants}", style: const TextStyle(color: Colors.white, fontSize: 14))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Obstrucciones: ${location.obstructions ? "Sí" : "No"}", style: const TextStyle(color: Colors.white, fontSize: 14)),
                  Text("Pisos: ${location.floors}", style: const TextStyle(color: Colors.white, fontSize: 14))
                ],
              )
            ],

            
          ),
          const SizedBox(height: 10,),
          const Divider(color: const Color(0xFF3D3B40), thickness: 1, height: 1, indent: 0, endIndent: 0,),
          const SizedBox(height: 10,),

        ],)
      );
    }


    return Column(
      children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF16171B), Color(0xFF353A40)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft)),
        child:  Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //header of the app
                children: [

                  Header(showUserInfo: false, user: user, showHomeIcon: true),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: getLocationsWidget())
                  )
                  
                  

                ],
              )),
        ));
  }
}

