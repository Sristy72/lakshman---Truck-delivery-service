import 'dart:async';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../home/domain/entities/load_entity.dart';



class LocationController extends GetxController {
  LocationController(this.load);

  final LoadEntity load;

  final Completer<GoogleMapController> mapController = Completer();

  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  LatLng? pickupLatLng;
  LatLng? deliveryLatLng;

  @override
  void onInit() {
    super.onInit();
    _initRouteFromLoad();
  }

  // pickupLocation / deliveryLocation = "lat, lng"
  LatLng? _parseLatLng(String value) {
    final parts = value.split(',');
    if (parts.length != 2) return null;

    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) return null;

    return LatLng(lat, lng);
  }

  void _initRouteFromLoad() {
    pickupLatLng = _parseLatLng(load.pickupLocation);
    deliveryLatLng = _parseLatLng(load.deliveryLocation);

    if (pickupLatLng == null || deliveryLatLng == null) {
      // invalid or missing coords → kichu show korbo na
      return;
    }

    markers.addAll({
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickupLatLng!,
        infoWindow: const InfoWindow(title: 'Pickup'),
      ),
      Marker(
        markerId: const MarkerId('delivery'),
        position: deliveryLatLng!,
        infoWindow: const InfoWindow(title: 'Delivery'),
      ),
    });

    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: [
          pickupLatLng!,
          deliveryLatLng!,
        ],
        width: 5,
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) async {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }

    // auto zoom so that pickup & delivery both visible
    if (pickupLatLng != null && deliveryLatLng != null) {
      final southWest = LatLng(
        math.min(pickupLatLng!.latitude, deliveryLatLng!.latitude),
        math.min(pickupLatLng!.longitude, deliveryLatLng!.longitude),
      );
      final northEast = LatLng(
        math.max(pickupLatLng!.latitude, deliveryLatLng!.latitude),
        math.max(pickupLatLng!.longitude, deliveryLatLng!.longitude),
      );

      final bounds = LatLngBounds(southwest: southWest, northeast: northEast);
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 60),
      );
    }
  }
}
