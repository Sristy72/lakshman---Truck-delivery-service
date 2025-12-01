import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../../domain/dispatcher_repository.dart';
import '../../models/dispatcher_model.dart';

class DispatcherController extends GetxController {
  final DispatcherRepository _repository;

  DispatcherController({required DispatcherRepository repository})
      : _repository = repository;

  // Observable lists
  final RxList<Dispatcher> dispatchers = <Dispatcher>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDispatchers();
  }

  Future<void> fetchDispatchers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log("========== FETCH DISPATCHERS ==========");

      final result = await _repository.getDispatchers();

      result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch dispatchers: ${failure.message}");
          errorMessage.value = failure.message;
          dispatchers.clear();
        },
        (success) {
          DPrint.log("✅ Received ${success.data.length} dispatchers from API");
          
          // Debug log each dispatcher
          for (var dispatcher in success.data) {
            DPrint.log("   - ${dispatcher.name} (${dispatcher.mobile})");
          }
          
          dispatchers.value = success.data;
          errorMessage.value = '';
        },
      );
    } catch (e) {
      DPrint.error("❌ Exception in fetchDispatchers: $e");
      errorMessage.value = 'An unexpected error occurred';
      dispatchers.clear();
    } finally {
      isLoading.value = false;
      DPrint.log("========================================");
    }
  }

  Future<void> removeDispatcher(String dispatcherId) async {
    try {
      DPrint.log("🗑️ Removing dispatcher: $dispatcherId");
      
      final result = await _repository.removeDispatcher(dispatcherId);
      
      result.fold(
        (failure) {
          DPrint.error("❌ Failed to remove dispatcher: ${failure.message}");
          errorMessage.value = failure.message;
        },
        (success) {
          DPrint.log("✅ Dispatcher removed successfully from API");
          // Remove from local list
          dispatchers.removeWhere((dispatcher) => dispatcher.id == dispatcherId);
          errorMessage.value = '';
        },
      );
    } catch (e) {
      DPrint.error("❌ Error removing dispatcher: $e");
      errorMessage.value = 'Failed to remove dispatcher';
    }
  }
}