import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:latlong2/latlong.dart' as latlng;

/// Full-screen location picker:
/// - Optional initialLocation (latlong2.LatLng)
/// - User map-e tap korle marker move hobe
/// - "Confirm location" button press korle LatLng back return korbe



class LocationScreen extends StatefulWidget {
  final latlng.LatLng? initialLocation;

  const LocationScreen({
    super.key,
    this.initialLocation,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  gmap.GoogleMapController? _mapController;
  gmap.LatLng? _selectedLatLng;

  // Dhaka default
  static const gmap.LatLng _defaultLatLng = gmap.LatLng(23.8103, 90.4125);
  static const double _defaultZoom = 15;

  @override
  void initState() {
    super.initState();
    // jodi initialLocation pao, oita diye start korbo, na hole Dhaka
    if (widget.initialLocation != null) {
      _selectedLatLng = gmap.LatLng(
        widget.initialLocation!.latitude,
        widget.initialLocation!.longitude,
      );
    } else {
      _selectedLatLng = _defaultLatLng;
    }
  }

  void _onMapCreated(gmap.GoogleMapController controller) {
    _mapController = controller;
    if (_selectedLatLng != null) {
      _mapController!.animateCamera(
        gmap.CameraUpdate.newCameraPosition(
          gmap.CameraPosition(
            target: _selectedLatLng!,
            zoom: _defaultZoom,
          ),
        ),
      );
    }
  }

  void _onTap(gmap.LatLng position) {
    setState(() {
      _selectedLatLng = position;
    });
  }

  void _onConfirm() {
    if (_selectedLatLng == null) {
      Navigator.of(context).pop();
      return;
    }

    // google_maps_flutter.LatLng ➜ latlong2.LatLng convert
    final result = latlng.LatLng(
      _selectedLatLng!.latitude,
      _selectedLatLng!.longitude,
    );

    Navigator.of(context).pop<latlng.LatLng>(result);
  }

  @override
  Widget build(BuildContext context) {
    final target = _selectedLatLng ?? _defaultLatLng;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select location'),

      ),
      body: Stack(
        children: [
          gmap.GoogleMap(
            initialCameraPosition: gmap.CameraPosition(
              target: target,
              zoom: _defaultZoom,
            ),
            onMapCreated: _onMapCreated,
            onTap: _onTap,
            markers: _selectedLatLng == null
                ? {}
                : {
              gmap.Marker(
                markerId: const gmap.MarkerId('selected'),
                position: _selectedLatLng!,
              ),
            },
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24 + MediaQuery.of(context).padding.bottom,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onConfirm,
                child: const Text('Confirm location'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
