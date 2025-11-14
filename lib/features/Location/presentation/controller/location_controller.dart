import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  LocationController(this.loadId);

  final String loadId;

  final Completer<GoogleMapController> mapController = Completer();

  /// observable markers & polylines
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  static const LatLng origin = LatLng(37.7588, -122.4469);
  static const LatLng destination = LatLng(37.7700, -122.4450);

  static const List<LatLng> demoRoute = [
    LatLng(37.7588, -122.4469),
    LatLng(37.7599, -122.4455),
    LatLng(37.7625, -122.4450),
    LatLng(37.7655, -122.4445),
    LatLng(37.7680, -122.4448),
    LatLng(37.7700, -122.4450),
  ];

  @override
  void onInit() {
    super.onInit();
    _initRoute();
  }

  void _initRoute() {
    markers.addAll( {
      Marker(markerId: MarkerId('origin'), position: origin),
      Marker(markerId: MarkerId('destination'), position: destination),
    });

    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: demoRoute,
        width: 5,
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }
}
