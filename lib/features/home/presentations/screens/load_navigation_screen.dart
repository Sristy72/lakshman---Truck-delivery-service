import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/accounts/data/models/driver_profile_response_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LoadNavigationScreen extends StatefulWidget {
  final CurrentLoad load;

  const LoadNavigationScreen({
    super.key,
    required this.load,
  });

  @override
  State<LoadNavigationScreen> createState() => _LoadNavigationScreenState();
}

class _LoadNavigationScreenState extends State<LoadNavigationScreen> {
  late MapController _mapController;
  LatLng? _currentLocation;
  LatLng? _pickupLatLng;
  LatLng? _deliveryLatLng;
  List<LatLng> _routePoints = [];
  bool _isLoading = true;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      // Parse pickup and delivery coordinates
      _pickupLatLng = _parseLatLng(widget.load.pickupLocation);
      _deliveryLatLng = _parseLatLng(widget.load.deliveryLocation);

      if (_pickupLatLng == null || _deliveryLatLng == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Get current location
      await _getCurrentLocation();

      // Generate route points
      _generateRoute();

      setState(() => _isLoading = false);

      // Fit bounds to show entire route
      _fitBounds();

      // Start tracking location
      _startLocationTracking();
    } catch (e) {
      print('Error initializing map: $e');
      setState(() => _isLoading = false);
    }
  }

  LatLng? _parseLatLng(String coordinates) {
    try {
      final parts = coordinates.split(',');
      if (parts.length == 2) {
        final lat = double.parse(parts[0].trim());
        final lng = double.parse(parts[1].trim());
        return LatLng(lat, lng);
      }
    } catch (e) {
      print('Error parsing coordinates: $e');
    }
    return null;
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void _startLocationTracking() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  void _generateRoute() {
    if (_pickupLatLng == null || _deliveryLatLng == null) return;

    // Generate a curved route between pickup and delivery
    // In a real app, you would use Google Directions API
    _routePoints = _generateCurvedRoute(
      _pickupLatLng!,
      _deliveryLatLng!,
      20, // number of points
    );
  }

  List<LatLng> _generateCurvedRoute(LatLng start, LatLng end, int points) {
    List<LatLng> route = [];
    
    // Calculate control point for bezier curve (offset to create curve)
    final midLat = (start.latitude + end.latitude) / 2;
    final midLng = (start.longitude + end.longitude) / 2;
    
    // Offset perpendicular to the line
    final dx = end.longitude - start.longitude;
    final dy = end.latitude - start.latitude;
    
    // Control point offset (creates the curve)
    final offsetRatio = 0.15; // Adjust curve intensity
    final controlLat = midLat - (dx * offsetRatio);
    final controlLng = midLng + (dy * offsetRatio);
    
    final control = LatLng(controlLat, controlLng);

    // Generate points along quadratic bezier curve
    for (int i = 0; i <= points; i++) {
      final t = i / points;
      final lat = pow(1 - t, 2) * start.latitude +
          2 * (1 - t) * t * control.latitude +
          pow(t, 2) * end.latitude;
      final lng = pow(1 - t, 2) * start.longitude +
          2 * (1 - t) * t * control.longitude +
          pow(t, 2) * end.longitude;
      route.add(LatLng(lat.toDouble(), lng.toDouble()));
    }

    return route;
  }

  void _fitBounds() {
    if (_pickupLatLng == null || _deliveryLatLng == null) return;

    final bounds = LatLngBounds(
      _pickupLatLng!,
      _deliveryLatLng!,
    );

    // Add padding
    final southWest = LatLng(
      bounds.southWest.latitude - 0.01,
      bounds.southWest.longitude - 0.01,
    );
    final northEast = LatLng(
      bounds.northEast.latitude + 0.01,
      bounds.northEast.longitude + 0.01,
    );

    final paddedBounds = LatLngBounds(southWest, northEast);

    // Fit to bounds after a short delay to ensure map is ready
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: paddedBounds,
            padding: const EdgeInsets.all(50),
          ),
        );
      }
    });
  }

  void _recenterMap() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15);
    } else {
      _fitBounds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _pickupLatLng ?? const LatLng(37.7749, -122.4194),
                    initialZoom: 13,
                    minZoom: 3,
                    maxZoom: 18,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.flutter_lakshman1020',
                    ),
                    
                    // Route polyline
                    if (_routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _routePoints,
                            strokeWidth: 5.0,
                            color: TColors.primary,
                            borderStrokeWidth: 8.0,
                            borderColor: TColors.primary.withOpacity(0.3),
                          ),
                        ],
                      ),

                    // Markers
                    MarkerLayer(
                      markers: [
                        // Pickup marker (green)
                        if (_pickupLatLng != null)
                          Marker(
                            point: _pickupLatLng!,
                            width: 60,
                            height: 60,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Delivery marker (red)
                        if (_deliveryLatLng != null)
                          Marker(
                            point: _deliveryLatLng!,
                            width: 60,
                            height: 60,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Current location marker (truck icon)
                        if (_currentLocation != null)
                          Marker(
                            point: _currentLocation!,
                            width: 50,
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.local_shipping,
                                color: TColors.primary,
                                size: 28,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

          // Top header with load ID
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: TColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                bottom: 12,
                left: 8,
                right: 16,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '#load_${widget.load.id.substring(widget.load.id.length - 5)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),
          ),

          // Location button (bottom right)
          Positioned(
            bottom: 30,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'recenter',
                  backgroundColor: TColors.primary,
                  onPressed: _recenterMap,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  backgroundColor: Colors.white,
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      (currentZoom + 1).clamp(3.0, 18.0),
                    );
                  },
                  child: const Icon(Icons.add, color: TColors.primary),
                ),
                const SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  backgroundColor: Colors.white,
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      (currentZoom - 1).clamp(3.0, 18.0),
                    );
                  },
                  child: const Icon(Icons.remove, color: TColors.primary),
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
    _positionStreamSubscription?.cancel();
    super.dispose();
  }
}
