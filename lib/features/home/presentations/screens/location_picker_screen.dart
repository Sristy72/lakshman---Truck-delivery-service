import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationPickerScreen({super.key, this.initialLocation});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late MapController _mapController;
  LatLng? _pickedLocation;
  String _address = "Tap on map to pick a location";
  double _zoom = 15.0;
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _pickedLocation = widget.initialLocation ?? const LatLng(23.8103, 90.4125);
  }

  /// Get current GPS position
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled')),
        );
        setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        setState(() => _isLoading = false);
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      final latLng = LatLng(pos.latitude, pos.longitude);

      setState(() {
        _pickedLocation = latLng;
      });
      _mapController.move(latLng, _zoom);
      _updateAddress(latLng);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Reverse geocode (LatLng -> Address)
  Future<void> _updateAddress(LatLng latLng) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          setState(() {
            _address =
            "${p.name ?? ''}, ${p.locality ?? ''}, ${p.country ?? ''}";
          });
        }
      } catch (e) {
        setState(() {
          _address = "Unknown location";
        });
      }
    });
  }

  /// Search address manually
  Future<void> _searchAddress(String query) async {
    try {
      final results = await locationFromAddress(query);
      if (results.isNotEmpty) {
        final loc = results.first;
        final latLng = LatLng(loc.latitude, loc.longitude);
        setState(() {
          _pickedLocation = latLng;
        });
        _mapController.move(latLng, 16);
        _updateAddress(latLng);
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No location found")),
      );
    }
  }

  /// Suggested shortcuts
  final List<Map<String, dynamic>> _suggestions = [
    {"label": "Home", "lat": 23.777176, "lng": 90.399452},
    {"label": "Office", "lat": 23.796084, "lng": 90.414456},
    {"label": "Airport", "lat": 23.8467, "lng": 90.4000},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Location"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(_pickedLocation);
          },
        ),
        actions: [
          TextButton(
            onPressed: _pickedLocation == null
                ? null
                : () => Navigator.of(context).pop(_pickedLocation),
            child: const Text(
              "Select",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          // Map with tap-to-pick marker
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _pickedLocation!,
              initialZoom: _zoom,
              onTap: (tapPosition, latLng) {
                setState(() {
                  _pickedLocation = latLng;
                });
                _updateAddress(latLng);
              },

            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              if (_pickedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _pickedLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Address info box
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isLoading
                        ? "Detecting current location..."
                        : _address,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _pickedLocation != null
                        ? 'Lat: ${_pickedLocation!.latitude.toStringAsFixed(5)}, '
                        'Lng: ${_pickedLocation!.longitude.toStringAsFixed(5)}'
                        : '',
                    textAlign: TextAlign.center,
                    style:
                    const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          // Search bar
          Positioned(
            left: 12,
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4),
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search location...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                onSubmitted: _searchAddress,
              ),
            ),
          ),

          // Suggested chips
          Positioned(
            top: 70,
            left: 12,
            right: 12,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _suggestions.map((s) {
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 4),
                    child: ActionChip(
                      label: Text(s["label"]),
                      onPressed: () {
                        final pos = LatLng(s["lat"], s["lng"]);
                        setState(() {
                          _pickedLocation = pos;
                        });
                        _mapController.move(pos, 15);
                        _updateAddress(pos);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Floating buttons
          Positioned(
            right: 10,
            bottom: 120,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: "zoomIn",
                  onPressed: () {
                    _zoom = (_zoom + 1).clamp(1, 19);
                    _mapController.move(_pickedLocation!, _zoom);
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.small(
                  heroTag: "zoomOut",
                  onPressed: () {
                    _zoom = (_zoom - 1).clamp(1, 19);
                    _mapController.move(_pickedLocation!, _zoom);
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.small(
                  heroTag: "locate",
                  onPressed: _getCurrentLocation,
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
