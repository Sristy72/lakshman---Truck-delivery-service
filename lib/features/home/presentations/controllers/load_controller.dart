import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/load_entity.dart';
import '../../domain/repositories/load_repository.dart';

class LoadController extends GetxController {
  final LoadRepository repository;

  LoadController({required this.repository});

  // Observable state
  final RxList<LoadEntity> loads = <LoadEntity>[].obs;
  final RxList<LoadEntity> filteredLoads = <LoadEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLoads();
  }

  /// Fetch loads from API
  Future<void> fetchLoads() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await repository.getLoads();

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          debugPrint('Error fetching loads: ${failure.message}');
        },
        (success) {
          loads.value = success.data;
          filteredLoads.value = success.data;
          debugPrint(
            'Loads fetched successfully: ${success.data.length} items',
          );
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      debugPrint('Error in fetchLoads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter loads by status
  void filterLoads(String filter) {
    selectedFilter.value = filter;

    if (filter == 'All') {
      filteredLoads.value = loads;
    } else {
      filteredLoads.value = loads
          .where(
            (load) => load.orderStatus.toLowerCase() == filter.toLowerCase(),
          )
          .toList();
    }
  }

  /// Refresh loads
  Future<void> refreshLoads() async {
    await fetchLoads();
  }

  /// Get load by ID
  LoadEntity? getLoadById(String id) {
    try {
      return loads.firstWhere((load) => load.id == id);
    } catch (e) {
      return null;
    }
  }
}
