class LocationModel {
  String name;
  int floors;
  int restaurants;
  int greenAreas;
  double latitude;
  double longitude;
  bool obstructions;

  LocationModel({
    required this.name,
    required this.floors,
    required this.restaurants,
    required this.greenAreas,
    required this.latitude,
    required this.longitude,
    required this.obstructions
  }); 
}