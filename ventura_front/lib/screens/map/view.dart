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
  List<LocationModel> locations = [];
  
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

  Widget getLocationsWidget(){
    var widgets = <Widget>[];
    for (var location in locations){
      widgets.add(
        Column(
          children: [
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
                  child: const Text("Ubicar", style: TextStyle(color: Colors.white, fontSize: 15))
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
        ),
        const SizedBox(height: 10,),
        Text("Latitud: ${location.latitude} ", style: const TextStyle(color: Colors.white, fontSize: 14)),
        Text("Longitud: ${location.longitude}", style: const TextStyle(color: Colors.white, fontSize: 14)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Distancia: ", style: TextStyle(color: Colors.white, fontSize: 14)),
            Text("${gps.getDistanceLatLon(location.latitude, location.longitude).toStringAsFixed(2)} mts", style: const TextStyle(color: Colors.white, fontSize: 14))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Tiempo estimado \ncaminando: ", style: const TextStyle(color: Colors.white, fontSize: 14)),
            Text("${(gps.getTimeLatLon(location.latitude, location.longitude) /60).toStringAsFixed(2)} minutes ", style: const TextStyle(color: Colors.white, fontSize: 14))
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

                  Header(showUserInfo: false, user: user, showHomeIcon: true),
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
  


