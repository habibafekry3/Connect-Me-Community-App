import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommunityMapScreen extends StatelessWidget {
  const CommunityMapScreen({super.key});

  static const List<Map<String, dynamic>> _members = [
    {
      'id': 'member_1',
      'name': 'Ahmed Mohamed',
      'city': 'Cairo',
      'latitude': 30.0444,
      'longitude': 31.2357,
    },
    {
      'id': 'member_2',
      'name': 'Sara Ali',
      'city': 'Alexandria',
      'latitude': 31.2001,
      'longitude': 29.9187,
    },
    {
      'id': 'member_3',
      'name': 'Omar Hassan',
      'city': 'Luxor',
      'latitude': 25.6872,
      'longitude': 32.6396,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final markers = _members.map((member) {
      return Marker(
        markerId: MarkerId(member['id'] as String),
        position: LatLng(
          member['latitude'] as double,
          member['longitude'] as double,
        ),
        infoWindow: InfoWindow(
          title: member['name'] as String,
          snippet: member['city'] as String,
        ),
      );
    }).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('Community Map')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(29.5, 31.0),
          zoom: 5.5,
        ),
        markers: markers,
        mapToolbarEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
