import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:geolocator/geolocator.dart";
import "package:ventura_front/services/view_models/connection_viewmodel.dart";
import "package:ventura_front/services/view_models/user_viewModel.dart";
import "package:provider/provider.dart";
import "package:ventura_front/services/view_models/profile_viewmodel.dart";

import "../../services/models/location_model.dart";
import "../../services/models/user_model.dart";

import "../components/header_component.dart";

import "../../mvvm_components/observer.dart";
import "../../services/repositories/locations_repository.dart";
import "../../services/view_models/locations_viewmodel.dart";

import "../../services/repositories/gps_repository.dart";
import 'package:ventura_front/screens/map/components/rateIcon_component.dart';


class MapView extends StatelessWidget {
  const MapView({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: const MapViewContent(),
    );
  }
  
  
}

class MapViewContent extends StatefulWidget {
  const MapViewContent({super.key});

  @override
  State<MapViewContent> createState() => MapViewState();
}

class MapViewState extends State<MapViewContent> implements EventObserver {
  Position? position;

  GpsRepository gps = GpsRepository.getState();

  final LocationsViewModel _viewModel = LocationsViewModel();
  late ProfileViewModel profileViewModel;
  static final ConnectionViewModel _connectionViewModel = ConnectionViewModel();
  bool _isLoading = true;
  List<Widget> locationWidgets = [];
  int pasosHoy = 0;
  int caloriasHoy = 0;
  bool showSitesButtons = true;
  bool showAllLocationsButton = false;

  final UserModel user = UserViewModel().user;
  bool showNoInternetWidget = false;

  void getPosition() async {
    try {
      position = await gps.determinePosition();
    } catch (e) {
      print(e);
    }
  }

  void addCalorias(double distance) async {
    profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    await profileViewModel.addCalorias(distance);
    setState(() {});
  }

  void addPasos(double distance) async {
    profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    await profileViewModel.addPasos(distance);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPosition();
    _connectionViewModel.subscribe(this);
    _viewModel.subscribe(this);

    if(_viewModel.locations.isEmpty){
        print("Cargando loc desde 0");
        _viewModel.getLocationsInitial();
    }
    else {
      print("Cargando locs ya cargados");
      notify(LocationsLoadedEvent(success: true));
    }

  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.unsubscribe(this);
    _connectionViewModel.unsubscribe(this);

  }

  @override
  void notify(ViewEvent event) {
    if (event is LoadingEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is LocationsLoadedEvent) {
      if (event.success){
          locationWidgets = getUpdatedLocationsList();
          setState(() {
            _isLoading = false;
          });
          if (_connectionViewModel.isConnected() && _viewModel.firstTime){
            print("First time - pidiendo recomendados");
            _viewModel.firstTime = false;
            _viewModel.updateRecommendedLocations(user.id);
          }
          else if (_connectionViewModel.isConnected() && _viewModel.updatings > 0){
            print("Hay actualizaciones pendientes - pidiendo recomendados");
            _viewModel.updatings = 0;
            _viewModel.updateRecommendedLocations(user.id);
          }
      }
      else {
        locationWidgets = [const Text("Error loading locations")];
        print("Error loading locations");
      }
    }
      else if (event is LocationFrequencyUpdateEvent) {
      if (event.success) {
        print("Location frequency updated");
      } else {
        print("Error updating location frequency");
      }
    }
      else if (event is UpdateRecommendedLocationsEvent) {
        if (event.success) {
          setState(() {
            locationWidgets = getUpdatedLocationsList();
          });
          print("Recommended locations updated");
        } else {
          print("Error updating recommended locations");
        }
      }
      else if (event is ConnectionEvent) {
        if (event.connection) {
          if (showNoInternetWidget) {
            setState(() {
              showNoInternetWidget = false;
              showSitesButtons = true;
            });
            if (_viewModel.updatings > 0){
              _viewModel.updateRecommendedLocations(user.id);
            }
          }
        } else {
          setState(() {
            showSitesButtons = false;
            showNoInternetWidget = true;
          });
        }
      }
  }



  

  String setDistance(double distance) {
    if (distance < 1000) {
      return "${distance.toStringAsFixed(2)} Mts";
    } else {
      return "${(distance / 1000).toStringAsFixed(2)} Kms";
    }
  }

  String setTime(double time) {
    if (time < 60) {
      return "${time.toStringAsFixed(2)} seconds";
    } else if (time < 3600) {
      return "${(time / 60).toStringAsFixed(2)} minutes";
    } else {
      return "${(time / 3600).toStringAsFixed(2)} hours";
    }
  }

  List<Widget> getRecommendedWidget(location) {
    List<Widget> widgets = [];
    if (location.recommended ?? false) {
      widgets.add(const Icon(Icons.recommend, color: Colors.white, size: 30));
      widgets.add(const SizedBox(width: 10));
      widgets.add(const Text("Recommended location",
          style: TextStyle(color: Colors.white, fontSize: 14)));
      widgets.add(const Spacer());
      return widgets;
    } else {
      return [];
    }
  }

  void restart(){
    _viewModel.getLocationsInitial();
  }

  void paintOneLocationById(String id){
    LocationModel? finalLocation = _viewModel.locations[id];
    Map<String, LocationModel> locationsLocal = Map();
    (setState(() {
      if (finalLocation != null){
        showAllLocationsButton = true;
        print(finalLocation.toString());
        print("Llegó aca");
          locationsLocal.putIfAbsent(finalLocation.id.toString(), () => finalLocation);
        _viewModel.locations = locationsLocal;
        locationWidgets = getUpdatedLocationsList();
        
      }
    }));
  }

 
  List<Widget> getUpdatedLocationsList() {
    List<Widget> locationWidgetsUpdated = [];
    for (var location in _viewModel.locations.values) {
      locationWidgetsUpdated.add(
        Column(
          children: [
            Column(
              // Aqui se agregan las recomendaciones si hay
              children: [
                Row(children: getRecommendedWidget(location)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    location.name,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    overflow: TextOverflow
                        .visible, // Permite que el texto se desborde si es demasiado largo
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          if (_connectionViewModel.isConnected()){
                            addCalorias(gps.getDistanceLatLon(
                                location.latitude, location.longitude));
                            addPasos(gps.getDistanceLatLon(
                                location.latitude, location.longitude));
                            gps.launchGoogleMaps(
                                location.latitude, location.longitude);
                            _viewModel.updateLocationFrequency(user.id, location.id);
                            _viewModel.updatings++;
                          } 
                          else{
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("No internet connection"),
                                  content: const Text("You need an internet connection to locate a place"),
                                  actions: [
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: const Color(0xFF3D3B40),
                                borderRadius: BorderRadius.circular(60)),
                            child: const Text("Locate",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)))),
                  ],
                ),
              ],
            ),
            ExpansionTile(
              title: const Text(
                'View more information',
                style: TextStyle(
                    color: const Color.fromARGB(255, 211, 164, 219),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Green zones: ${location.greenAreas}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14)),
                        Text("Restaurants: ${location.restaurants}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Obstructions: ${location.obstructions ? "Sí" : "No"}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14)),
                        Text("Floors: ${location.floors}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Latitude: ${location.latitude} ",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14)),
                    Text("Longitude: ${location.longitude}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Distance: ",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        Text(
                            setDistance(gps.getDistanceLatLon(
                                location.latitude, location.longitude)),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Estimated walking \ntime: ",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        Text(
                            setTime(gps.getTimeLatLon(
                                location.latitude, location.longitude, 0)),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14))
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  if(_connectionViewModel.isConnected()){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const RateIcon();
                      },
                    );
                  }
                  else{
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("No internet connection"),
                          content: const Text("You need an internet connection to rate a place"),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            )
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  'Rate this location!',
                  style: TextStyle(
                      color: Color.fromARGB(255, 135, 230, 139),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: const Color(0xFF3D3B40),
              thickness: 1,
              height: 1,
              indent: 0,
              endIndent: 0,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }
    return locationWidgetsUpdated;
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF16171B), Color(0xFF353A40)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
              padding: const EdgeInsets.only(
                  top: 40, left: 20, right: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //header of the app
                children: [
                  Header(
                    showUserInfo: false,
                    user: user,
                    showHomeIcon: true,
                    showLogoutIcon: false,
                    showNotiIcon: false
                  ),
                  showNoInternetWidget
                      ? const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(                          
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Icon(Icons.wifi_off, color: Colors.white, size: 30),
                              SizedBox(width: 10),
                              Text("No internet connection",
                                  style: TextStyle(color: Colors.white, fontSize: 16))
                            ]),
                            SizedBox(height: 10),
                          ],
                        ),
                          
                      )
                      : const SizedBox(),
                  showSitesButtons
                      ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          const Text("Search for a place to go",
                              style: TextStyle(color: Colors.white, fontSize: 20)),
                          const SizedBox(height: 20),

                          Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                paintOneLocationById(_viewModel.getSite("green_areas"));

                              },
                              child: const Text("Search Green Zone"),
                            ),

                            const SizedBox(width: 10),

                            ElevatedButton(
                              onPressed: () {
                                paintOneLocationById(_viewModel.getSite("restaurants"));
                              },
                              child: const Text("Search Restaurant"),
                            ),
                          ],
                          
                        ),
                        const SizedBox(height: 20),
                        showAllLocationsButton
                            ? ElevatedButton(
                                onPressed: () {
                                  (setState( () => showAllLocationsButton = false));
                                  restart();
                                },
                                child: const Text("Show all locations"),
                              )
                            : const SizedBox(),


                        ],
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: SingleChildScrollView(
                              child: Column(children: locationWidgets,)))
                ],
              )),
        ));
  }
}
