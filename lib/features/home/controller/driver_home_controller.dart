import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/core/network/constants/api_constants.dart';
import 'package:flutter_lakshman1020/features/accounts/data/models/driver_profile_response_model.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class DriverHomeController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  bool _isDisposed = false; // Flag to prevent background processing after dispose

  DriverHomeController();

  // Observable current loads
  final RxList<CurrentLoad> currentLoads = <CurrentLoad>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Geocoded addresses storage
  final RxMap<String, Map<String, String>> geocodedAddresses = <String, Map<String, String>>{}.obs;
  final RxMap<String, bool> geocodingInProgress = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentLoads();
  }

  @override
  void onClose() {
    _isDisposed = true; // Stop any background geocoding
    DPrint.log('🛑 DriverHomeController disposed - stopping all geocoding operations');
    super.onClose();
  }

  /// Load current loads from AccountController's driver profile
  Future<void> _loadCurrentLoads() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log('========== LOADING DRIVER CURRENT LOADS ==========');

      // Fetch driver profile directly from API to get raw dashboard data
      final response = await _apiClient.get(
        ApiConstants.getProfile.fetchProfile,
        fromJsonT: (json) => json, // Return raw JSON
      );

      response.fold(
        (failure) {
          DPrint.error('❌ Failed to fetch driver profile: ${failure.message}');
          errorMessage.value = 'Failed to load current loads';
          isLoading.value = false;
        },
        (success) {
          DPrint.log('✅ Raw API response received');
          
          // Parse the response data
          final data = success.data;
          DPrint.log('📦 Response data type: ${data.runtimeType}');
          
          // The response should be the JSON map directly
          Map<String, dynamic> profileData;
          if (data is Map<String, dynamic>) {
            // Check if it's wrapped in 'data' key
            if (data.containsKey('data')) {
              profileData = data['data'] as Map<String, dynamic>;
            } else {
              profileData = data;
            }
          } else {
            DPrint.error('⚠️ Unexpected response format: ${data.runtimeType}');
            errorMessage.value = 'Invalid response format';
            isLoading.value = false;
            return;
          }
          
          DPrint.log('📊 Profile data keys: ${profileData.keys.toList()}');
          
          // Check if dashboard exists
          if (profileData.containsKey('dashboard') && profileData['dashboard'] is Map) {
            final dashboardData = profileData['dashboard'] as Map<String, dynamic>;
            DPrint.log('📊 Dashboard data: $dashboardData');
            DPrint.log('📊 Dashboard keys: ${dashboardData.keys.toList()}');
            
            // Parse driver profile with dashboard
            try {
              final driverProfile = DriverProfileResponseModel.fromJson(profileData);
              final dashboard = driverProfile.dashboard;
              
              if (dashboard != null && dashboard.currentLoad != null) {
                currentLoads.value = [dashboard.currentLoad!];
                DPrint.log('✅ Loaded ${currentLoads.length} current load(s)');
                DPrint.log('   Load ID: ${dashboard.currentLoad!.id}');
                DPrint.log('   Title: ${dashboard.currentLoad!.title}');
                DPrint.log('   Pickup: ${dashboard.currentLoad!.pickupLocation}');
                DPrint.log('   Delivery: ${dashboard.currentLoad!.deliveryLocation}');
                
                // Start geocoding for all loads
                _geocodeAllAddresses();
              } else {
                DPrint.log('ℹ️ No current loads found in dashboard');
                currentLoads.clear();
              }
            } catch (e) {
              DPrint.error('❌ Error parsing driver profile: $e');
              errorMessage.value = 'Failed to parse profile data';
            }
          } else {
            DPrint.log('ℹ️ No dashboard found in profile response');
            DPrint.log('   Available keys: ${profileData.keys.toList()}');
            currentLoads.clear();
          }

          isLoading.value = false;
        },
      );
    } catch (e, stackTrace) {
      DPrint.error('❌ Error loading current loads: $e');
      DPrint.error('Stack trace: $stackTrace');
      errorMessage.value = 'Failed to load current loads';
      isLoading.value = false;
    }
  }

  /// Geocode all addresses for all loads in parallel
  Future<void> _geocodeAllAddresses() async {
    // Don't proceed if controller is disposed
    if (_isDisposed) {
      DPrint.log('⏹️ Controller disposed - skipping geocoding');
      return;
    }
    
    try {
      DPrint.log('🌍 Starting parallel geocoding for ${currentLoads.length} load(s)');
      
      // Process all loads in parallel
      await Future.wait(
        currentLoads.map((load) => _geocodeLoadAddresses(
          load.id,
          load.pickupLocation,
          load.deliveryLocation,
        )),
      );
      
      // Check if disposed after async operation
      if (_isDisposed) {
        DPrint.log('⏹️ Controller disposed during geocoding - discarding results');
        return;
      }
      
      DPrint.log('✅ Geocoding completed for all loads');
    } catch (e) {
      DPrint.error('❌ Error geocoding addresses: $e');
    }
  }

  /// Geocode addresses for a specific load
  Future<void> _geocodeLoadAddresses(
    String loadId,
    String pickupLatLng,
    String deliveryLatLng,
  ) async {
    // Don't proceed if controller is disposed
    if (_isDisposed) return;
    
    try {
      geocodingInProgress[loadId] = true;

      DPrint.log('🌍 Geocoding load $loadId');
      DPrint.log('   Pickup: $pickupLatLng');
      DPrint.log('   Delivery: $deliveryLatLng');

      // Parse coordinates
      final pickupParts = pickupLatLng.split(',').map((s) => s.trim()).toList();
      final deliveryParts = deliveryLatLng.split(',').map((s) => s.trim()).toList();

      if (pickupParts.length != 2 || deliveryParts.length != 2) {
        DPrint.error('⚠️ Invalid coordinate format for load $loadId');
        geocodedAddresses[loadId] = {
          'pickup': pickupLatLng,
          'delivery': deliveryLatLng,
        };
        geocodingInProgress[loadId] = false;
        return;
      }

      final pickupLat = double.parse(pickupParts[0]);
      final pickupLng = double.parse(pickupParts[1]);
      final deliveryLat = double.parse(deliveryParts[0]);
      final deliveryLng = double.parse(deliveryParts[1]);

      // Parallel geocoding for both addresses
      final results = await Future.wait([
        _getAddressFromCoordinates(pickupLat, pickupLng),
        _getAddressFromCoordinates(deliveryLat, deliveryLng),
      ]);

      // Check if disposed after async operation
      if (_isDisposed) {
        DPrint.log('⏹️ Controller disposed during load geocoding - discarding results for $loadId');
        return;
      }

      geocodedAddresses[loadId] = {
        'pickup': results[0],
        'delivery': results[1],
      };

      DPrint.log('✅ Geocoded load $loadId:');
      DPrint.log('   Pickup: ${results[0]}');
      DPrint.log('   Delivery: ${results[1]}');

      geocodingInProgress[loadId] = false;
    } catch (e) {
      DPrint.error('❌ Error geocoding load $loadId: $e');
      
      // Check if disposed before updating state
      if (_isDisposed) return;
      
      geocodedAddresses[loadId] = {
        'pickup': pickupLatLng,
        'delivery': deliveryLatLng,
      };
      geocodingInProgress[loadId] = false;
    }
  }

  /// Get human-readable address from coordinates using Google Geocoding
  Future<String> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address = '${p.locality ?? ''}, ${p.country ?? ''}';
        return address.replaceAll('  ', ' ').trim();
      }
      
      return '$latitude, $longitude';
    } catch (e) {
      DPrint.error('❌ Error geocoding $latitude, $longitude: $e');
      return '$latitude, $longitude';
    }
  }

  /// Refresh current loads
  Future<void> refreshLoads() async {
    await _loadCurrentLoads();
  }
}
