import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../home/domain/entities/load_entity.dart';

class LocationScreen extends StatefulWidget {
  final LoadEntity load;

  const LocationScreen({
    super.key,
    required this.load,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GoogleMapController? _mapController;

  LatLng? _pickupLatLng;
  LatLng? _deliveryLatLng;

  static const LatLng _fallbackCenter = LatLng(23.8103, 90.4125);
  static const double _defaultZoom = 12;

  @override
  void initState() {
    super.initState();
    _initFromLoad();
  }

  LatLng? _parseLatLng(String value) {
    final parts = value.split(',');
    if (parts.length != 2) return null;

    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) return null;

    return LatLng(lat, lng);
  }

  void _initFromLoad() {
    _pickupLatLng = _parseLatLng(widget.load.pickupLocation);
    _deliveryLatLng = _parseLatLng(widget.load.deliveryLocation);
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    if (_pickupLatLng != null && _deliveryLatLng != null) {
      final southWest = LatLng(
        math.min(_pickupLatLng!.latitude, _deliveryLatLng!.latitude),
        math.min(_pickupLatLng!.longitude, _deliveryLatLng!.longitude),
      );
      final northEast = LatLng(
        math.max(_pickupLatLng!.latitude, _deliveryLatLng!.latitude),
        math.max(_pickupLatLng!.longitude, _deliveryLatLng!.longitude),
      );

      final bounds = LatLngBounds(southwest: southWest, northeast: northEast);

      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 60),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasRoute = _pickupLatLng != null && _deliveryLatLng != null;

    final markers = <Marker>{};
    final polylines = <Polyline>{};

    if (hasRoute) {
      markers.addAll({
        Marker(
          markerId: const MarkerId('pickup'),
          position: _pickupLatLng!,
          infoWindow: const InfoWindow(title: 'Pickup'),
        ),
        Marker(
          markerId: const MarkerId('delivery'),
          position: _deliveryLatLng!,
          infoWindow: const InfoWindow(title: 'Delivery'),
        ),
      });

      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [
            _pickupLatLng!,
            _deliveryLatLng!,
          ],
          width: 5,
          color: Colors.blue,
        ),
      );
    }

    final initialTarget = hasRoute ? _pickupLatLng! : _fallbackCenter;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialTarget,
              zoom: _defaultZoom,
            ),
            onMapCreated: _onMapCreated,
            markers: markers,
            polylines: polylines,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          // 👇 top blue pill like mock
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0057FF),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    '#${widget.load.id}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
