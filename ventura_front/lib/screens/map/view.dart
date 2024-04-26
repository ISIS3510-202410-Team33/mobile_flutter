import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";

import "../../services/models/location_model.dart";
import "../../services/models/user_model.dart";

import "../components/header_component.dart";

import "../../mvvm_components/observer.dart";
import "../../services/repositories/locations_repository.dart";
import "../../services/view_models/locations_viewmodel.dart";

import "../../services/repositories/gps_repository.dart";
import 'package:ventura_front/screens/map/components/rateIcon_component.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State createState() => MapViewState();
}

class MapViewState extends State implements EventObserver{

  Position? position;

  GpsRepository gps = GpsRepository.getState();

  final LocationsViewModel _viewModel = LocationsViewModel(LocationRepository.getState());
  bool _isLoading = true;
  Map<String,LocationModel> locations = {};
  
  final UserModel user = UserModel(
    uuid: 1, 
    name: "Juan",
    studentCode: 202011638);
  
  void getPosition () async {
    try {
      position = await gps.determinePosition();
    } catch (e) {
      print(e);
    }
  }


  @override
  void initState() {

    super.initState();
    getPosition();
    _viewModel.subscribe(this);
    _viewModel.loadLocations();

  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.unsubscribe(this);
  }

  @override
  void notify(ViewEvent event) {
    if (event is LoadingEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is LocationsLoadedEvent) {
      setState(() {
        locations = event.locations;
      });
    }
  }

  String setDistance(double distance) {
    if (distance < 1000) {
      return "${distance.toStringAsFixed(2)} mts";
    } else {
      return "${(distance / 1000).toStringAsFixed(2)} km";
    }
  } 

  String setTime(double time){
    if (time < 60) {
      return "${time.toStringAsFixed(2)} seconds";
    } else if (time < 3600) {
      return "${(time / 60).toStringAsFixed(2)} minutes";
    } else {
      return "${(time / 3600).toStringAsFixed(2)} hours";
    }
  }
  List<Widget> getRecommendedWidget(location){
    List<Widget> widgets = [];
    if (location.recommended ?? false) {
      widgets.add(const Icon(Icons.recommend, color: Colors.white, size: 30));
      widgets.add(const SizedBox(width: 10));
      widgets.add(const Text("Recommended location", style: TextStyle(color: Colors.white, fontSize: 14)));
      widgets.add(const Spacer());
      return widgets;
    }
    else{
      return [];
    }
  }

  Widget getLocationsWidget(){
    var widgets = <Widget>[];
    for (var location in locations.values){
      widgets.add(
        Column(
          children: [
          Column( // Aqui se agregan las recomendaciones si hay 
            children: [
              Row(
              children: getRecommendedWidget(location) ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Expanded(
              child: Text(
                location.name,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.visible, // Permite que el texto se desborde si es demasiado largo
              ),
            ),
              Row(children: [
                TextButton(onPressed: (){
                  gps.launchGoogleMaps(location.latitude, location.longitude);  
                  _viewModel.updateLocationFrequency(1, 1);
                }, child: Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D3B40),
                    borderRadius: BorderRadius.circular(60)
                  ),
                  child: const Text("Locate", style: TextStyle(color: Colors.white, fontSize: 15))
                )),
                ],
              ),
            ],
          ),
          ExpansionTile(
  title: const Text(
    'View more information',
    style: TextStyle(
      color: const Color.fromARGB(255, 211, 164, 219),
      fontSize: 16, fontWeight: FontWeight.bold
    ),
  ),
  children: <Widget>[
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Green zones: ${location.greenAreas}", style: const TextStyle(color: Colors.white, fontSize: 14)),
            Text("Restaurants: ${location.restaurants}", style: const TextStyle(color: Colors.white, fontSize: 14))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Obstructions: ${location.obstructions ? "Sí" : "No"}", style: const TextStyle(color: Colors.white, fontSize: 14)),
            Text("Floors: ${location.floors}", style: const TextStyle(color: Colors.white, fontSize: 14))
          ],
        ),
        const SizedBox(height: 10,),
        Text("Latitude: ${location.latitude} ", style: const TextStyle(color: Colors.white, fontSize: 14)),
        Text("Longitude: ${location.longitude}", style: const TextStyle(color: Colors.white, fontSize: 14)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Distance: ", style: TextStyle(color: Colors.white, fontSize: 14)),
            Text(setDistance(gps.getDistanceLatLon(location.latitude, location.longitude)), style: const TextStyle(color: Colors.white, fontSize: 14))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Estimated walking \ntime: ", style: TextStyle(color: Colors.white, fontSize: 14)),
            Text(setTime(gps.getTimeLatLon(location.latitude, location.longitude, 0)), style: const TextStyle(color: Colors.white, fontSize: 14))
          ],
        ),
      ],
    ),
  ],
),
const SizedBox(width: 10),
Align(
  alignment: Alignment.centerLeft,
  child:GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (context) {
        return const RateIcon();
      },
    );
  },
  child: const Text(
    'Rate this location!',
    style: TextStyle(color: Color.fromARGB(255, 135, 230, 139), fontSize: 14, fontWeight: FontWeight.bold), 
  ),
),),

          const SizedBox(height: 10,), 
          const Divider(color: const Color(0xFF3D3B40), thickness: 1, height: 1, indent: 0, endIndent: 0,),
          const SizedBox(height: 10,),

        ],),);}


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

                  Header(showUserInfo: false, user: user, showHomeIcon: true, showLogoutIcon: false,),
                  const SizedBox(height: 20),
                  _isLoading ? const Center(child: CircularProgressIndicator()) :
                  Expanded(
                    child: SingleChildScrollView(
                      child: getLocationsWidget())
                  )
                  
                  

                ],
              )),
        ));
  }

}
  


