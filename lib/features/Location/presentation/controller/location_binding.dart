import 'package:get/get.dart';
import '../../../home/domain/entities/load_entity.dart';
import '../controller/location_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    final load = Get.arguments as LoadEntity;
    Get.put<LocationController>(
      LocationController(load),
    );
  }
}
