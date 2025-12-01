import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../../domain/driver_repository.dart';
import '../../model/dariver_model.dart';

class DriverController extends GetxController {
  final DriverRepository _repository;
  bool _hasInitialized = false;

  DriverController({required DriverRepository repository})
      : _repository = repository;

  // Observable lists
  final RxList<Driver> drivers = <Driver>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Only fetch on first initialization if not already done
    if (!_hasInitialized) {
      fetchDrivers();
      _hasInitialized = true;
    }
  }

  Future<void> fetchDrivers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log("========== FETCH DRIVERS ==========");

      final result = await _repository.getDrivers();

      result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch drivers: ${failure.message}");
          errorMessage.value = failure.message;
          drivers.clear();
        },
        (success) {
          DPrint.log("✅ Received ${success.data.length} drivers from API");
          
          // Debug log each driver
          for (var driver in success.data) {
            DPrint.log("   - ${driver.name} (${driver.phone}) - Deliveries: ${driver.deliveryCount}, Rating: ${driver.rating}");
          }
          
          drivers.value = success.data;
          errorMessage.value = '';
        },
      );
    } catch (e) {
      DPrint.error("❌ Exception in fetchDrivers: $e");
      errorMessage.value = 'An unexpected error occurred';
      drivers.clear();
    } finally {
      isLoading.value = false;
      DPrint.log("========================================");
    }
  }
}