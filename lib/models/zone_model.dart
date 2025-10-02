import 'package:google_maps_flutter/google_maps_flutter.dart';

class Zone {
  final int id;
  final String name;
  final List<LatLng> coordinates;

  Zone({required this.id, required this.name, required this.coordinates});

  factory Zone.fromJson(Map<String, dynamic> json) {
    final coords = (json['formated_coordinates'] as List<dynamic>)
        .map((c) => LatLng(c['lat'], c['lng']))
        .toList();
    return Zone(
      id: json['id'],
      name: json['name'],
      coordinates: coords,
    );
  }
}
