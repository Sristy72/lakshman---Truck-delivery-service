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
      // Normalize orderStatus and map UI filter names to backend status values.
      final f = filter.trim();
      final lowerFilter = f.toLowerCase();

      // Define acceptable backend status values for each UI filter
      // Note: include 'ask_pending' and 'asked' as part of the pending bucket
      final Map<String, List<String>> filterMap = {
        'pending': ['pending'],
        'processing': ['ask_pending', 'asked'],
        // sometimes backend uses 'completed' or 'delivered' interchangeably
        'delivered': ['delivered', 'completed'],
      };

      final allowed = filterMap[lowerFilter] ?? [lowerFilter];

      filteredLoads.value = loads.where((load) {
        final status = load.orderStatus.toString().trim().toLowerCase();
        return allowed.contains(status);
      }).toList();
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

  /// Fetch single load by ID from repository
  Future<LoadEntity?> fetchLoadById(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await repository.getLoadById(id);
      return result;
    } catch (e) {
      errorMessage.value = 'Failed to fetch load: $e';
      debugPrint('Error in fetchLoadById: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a new load
  Future<LoadEntity?> createLoad(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await repository.createLoad(payload);
      // Refresh loads after creation
      await fetchLoads();
      return result;
    } catch (e) {
      errorMessage.value = 'Failed to create load: $e';
      debugPrint('Error in createLoad: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
