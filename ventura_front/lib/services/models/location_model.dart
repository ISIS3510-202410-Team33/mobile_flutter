class LocationModel {
  int id;
  String name;
  int floors;
  int restaurants;
  int greenAreas;
  double latitude;
  double longitude;
  bool obstructions;
  int? frequency;
  bool? bestRated;

  LocationModel({
    required this.id,
    required this.name,
    required this.floors,
    required this.restaurants,
    required this.greenAreas,
    required this.latitude,
    required this.longitude,
    required this.obstructions,
    this.frequency,
    this.bestRated
  }); 
}