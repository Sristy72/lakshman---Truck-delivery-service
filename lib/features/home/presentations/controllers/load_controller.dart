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
          debugPrint('❌ Error fetching loads: ${failure.message}');
        },
        (success) {
          debugPrint('========== FETCH ALL LOADS ==========');
      debugPrint('✅ Received ${success.data.length} loads from API');
      for (var load in success.data) {
        debugPrint('   - ${load.id}: ${load.title}');
        debugPrint('     Status: "${load.orderStatus}" (lowercase: "${load.orderStatus.toLowerCase()}")');
      }
      
      loads.value = success.data;
      
      // Apply current filter instead of showing all
      filterLoads(selectedFilter.value);
      
      debugPrint('📊 After filtering: ${filteredLoads.length} loads displayed');
      debugPrint('====================================');
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      debugPrint('❌ Error in fetchLoads: $e');
    } finally {
      isLoading.value = false;
    }
  }

   /// Filter loads by UI filter
  void filterLoads(String filter) {
    selectedFilter.value = filter;

    debugPrint('========== FILTER LOADS ==========');
    debugPrint('🔍 Filter selected: $filter');
    debugPrint('📦 Total loads: ${loads.length}');
    
    if (filter == 'All') {
      // Show only pending or accepted loads in "All" tab
      debugPrint('🔎 Showing only pending or accepted loads in All tab');
      filteredLoads.value = loads.where((load) {
        final status = load.orderStatus.toLowerCase();
        final matches = status == 'pending' || status == 'accepted';
        debugPrint('   - ${load.id}: status="${load.orderStatus}" ($status) -> $matches');
        return matches;
      }).toList();
      debugPrint('✅ Showing ${filteredLoads.length} loads (pending + accepted)');
    } else if (filter == 'Assign price') {
      debugPrint('🔎 Looking for loads with status: "pending"');
      filteredLoads.value = loads.where((load) {
        final matches = load.orderStatus.toLowerCase() == 'pending';
        debugPrint('   - ${load.id}: status="${load.orderStatus}" (${load.orderStatus.toLowerCase()}) -> $matches');
        return matches;
      }).toList();
      debugPrint('✅ Filtered to ${filteredLoads.length} pending loads');
    } else if (filter == 'Assign driver') {
      debugPrint('🔎 Looking for loads with status: "accepted"');
      filteredLoads.value = loads.where((load) {
        final matches = load.orderStatus.toLowerCase() == 'accepted';
        debugPrint('   - ${load.id}: status="${load.orderStatus}" (${load.orderStatus.toLowerCase()}) -> $matches');
        return matches;
      }).toList();
      debugPrint('✅ Filtered to ${filteredLoads.length} accepted loads');
    } else {
      filteredLoads.value = [];
      debugPrint('⚠️ Unknown filter, showing 0 loads');
    }
    debugPrint('==================================');
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

  /// Fetch loads by company ID
  Future<void> fetchLoadsByCompany(String companyId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      debugPrint('========== FETCH LOADS BY COMPANY ==========');
      debugPrint('📦 Company ID: $companyId');

      final result = await repository.getLoadsByCompany(companyId);
      
      debugPrint('✅ Received ${result.length} loads from API');
      for (var load in result) {
        debugPrint('   - ${load.id}: ${load.title}');
        debugPrint('     Status: "${load.orderStatus}" (lowercase: "${load.orderStatus.toLowerCase()}")');
      }
      
      loads.value = result;
      
      // Apply current filter instead of showing all
      filterLoads(selectedFilter.value);
      
      debugPrint('📊 After filtering: ${filteredLoads.length} loads displayed');
      debugPrint('============================================');
    } catch (e) {
      errorMessage.value = 'Failed to fetch company loads: $e';
      debugPrint('❌ Error in fetchLoadsByCompany: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
