import 'package:get/get.dart';
import 'location_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>?;

    final loadId = args?['loadId'] as String? ?? '#load_45982';

    Get.put<LocationController>(
      LocationController(loadId),
      permanent: false,
    );
  }
}
