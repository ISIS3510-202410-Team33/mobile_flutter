class LocationModel {
  int id;
  String name;
  int floors;
  int restaurants;
  int greenAreas;
  double latitude;
  double longitude;
  bool obstructions;
  bool? bestRated;
  bool? recommended;

  LocationModel({
    required this.id,
    required this.name,
    required this.floors,
    required this.restaurants,
    required this.greenAreas,
    required this.latitude,
    required this.longitude,
    required this.obstructions,
    this.bestRated,
    this.recommended
  }); 

  @override
  String toString() {
    return 'LocationModel{id: $id, name: $name, floors: $floors, restaurants: $restaurants, greenAreas: $greenAreas, latitude: $latitude, longitude: $longitude, obstructions: $obstructions, bestRated: $bestRated, recommended: $recommended}';
  }
}