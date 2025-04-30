import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyAttractionsPage extends StatefulWidget {
  const NearbyAttractionsPage({super.key});

  @override
  State<NearbyAttractionsPage> createState() => _NearbyAttractionsPageState();
}

class _NearbyAttractionsPageState extends State<NearbyAttractionsPage> {
  Position? _currentPosition;
  GoogleMapController? _mapController;
  final LatLng _defaultLatLng = const LatLng(37.7749, -122.4194); // SF fallback

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || 
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || 
        permission == LocationPermission.always) {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = position;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Location permission is required."),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    LatLng center = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : _defaultLatLng;

    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Attractions")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: center,
          zoom: 14,
        ),
        myLocationEnabled: true,
        markers: _currentPosition != null
            ? {
                Marker(
                  markerId: const MarkerId("me"),
                  position: center,
                  infoWindow: const InfoWindow(title: "You are here"),
                ),
              }
            : {},
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
