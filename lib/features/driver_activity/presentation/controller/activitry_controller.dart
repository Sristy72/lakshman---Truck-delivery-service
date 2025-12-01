import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/home/domain/entities/load_entity.dart';
import 'package:flutter_lakshman1020/features/home/domain/repositories/load_repository.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class ActivityController extends ChangeNotifier {
  LoadRepository get _loadRepository => Get.find<LoadRepository>();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isDisposed = false; // Flag to prevent background processing after dispose

  // User info
  String userName = 'Driver';
  String userRole = 'Driver';
  
  // Period and checkpoint tracking
  String _period = 'Weekly';
  String get period => _period;
  
  late int _checkpoints;
  int get checkpoints => _checkpoints;

  // Checkpoint data for different periods
  final Map<String, int> checkpointsByPeriod = {
    'Daily': 28,
    'Weekly': 198,
    'Monthly': 842,
  };

  // Real load data
  List<LoadEntity> _loads = [];
  List<LoadEntity> get loads => _loads;
  
  // Geocoded addresses
  final Map<String, Map<String, String>> _geocodedAddresses = {};
  final Map<String, bool> _geocodingInProgress = {};
  
  // Get geocoded address for a load
  Map<String, String>? getGeocodedAddress(String loadId) => _geocodedAddresses[loadId];
  bool isGeocoding(String loadId) => _geocodingInProgress[loadId] ?? false;

  ActivityController() {
    _checkpoints = checkpointsByPeriod['Weekly'] ?? 198;
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      DPrint.log('========== LOADING ACTIVITY DATA ==========');
      
      // Fetch loads from API
      final result = await _loadRepository.getLoads();
      
      result.fold(
        (failure) {
          DPrint.error('❌ Failed to fetch loads: ${failure.message}');
          _loads = [];
        },
        (success) {
          DPrint.log('✅ Fetched ${success.data.length} loads from API');
          _loads = success.data;
          
          // Start geocoding all addresses in parallel
          _geocodeAllAddresses();
        },
      );
    } catch (e, stackTrace) {
      DPrint.error('❌ Error loading activity data: $e');
      DPrint.error('Stack trace: $stackTrace');
      _loads = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Geocode all addresses for all loads in parallel
  Future<void> _geocodeAllAddresses() async {
    if (_loads.isEmpty) return;
    
    // Don't proceed if controller is disposed
    if (_isDisposed) {
      DPrint.log('⏹️ Controller disposed - skipping geocoding');
      return;
    }
    
    try {
      DPrint.log('🌍 Starting parallel geocoding for ${_loads.length} load(s)');
      
      // Process all loads in parallel
      await Future.wait(
        _loads.map((load) => _geocodeLoadAddresses(
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
      notifyListeners();
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
      _geocodingInProgress[loadId] = true;
      notifyListeners();

      DPrint.log('🌍 Geocoding load $loadId');

      // Parse coordinates
      final pickupParts = pickupLatLng.split(',').map((s) => s.trim()).toList();
      final deliveryParts = deliveryLatLng.split(',').map((s) => s.trim()).toList();

      if (pickupParts.length != 2 || deliveryParts.length != 2) {
        DPrint.error('⚠️ Invalid coordinate format for load $loadId');
        _geocodedAddresses[loadId] = {
          'pickup': pickupLatLng,
          'delivery': deliveryLatLng,
        };
        _geocodingInProgress[loadId] = false;
        notifyListeners();
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

      _geocodedAddresses[loadId] = {
        'pickup': results[0],
        'delivery': results[1],
      };

      DPrint.log('✅ Geocoded load $loadId:');
      DPrint.log('   Pickup: ${results[0]}');
      DPrint.log('   Delivery: ${results[1]}');

      _geocodingInProgress[loadId] = false;
      notifyListeners();
    } catch (e) {
      DPrint.error('❌ Error geocoding load $loadId: $e');
      
      // Check if disposed before updating state
      if (_isDisposed) return;
      
      _geocodedAddresses[loadId] = {
        'pickup': pickupLatLng,
        'delivery': deliveryLatLng,
      };
      _geocodingInProgress[loadId] = false;
      notifyListeners();
    }
  }

  /// Get human-readable address from coordinates using Google Geocoding
  Future<String> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address = '${p.locality ?? ''}, ${p.administrativeArea ?? ''}';
        return address.replaceAll('  ', ' ').trim();
      }
      
      return '$latitude, $longitude';
    } catch (e) {
      DPrint.error('❌ Error geocoding $latitude, $longitude: $e');
      return '$latitude, $longitude';
    }
  }

  void changePeriod(String newPeriod) {
    _period = newPeriod;
    _checkpoints = checkpointsByPeriod[newPeriod] ?? 198;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _isDisposed = true; // Stop any background geocoding
    DPrint.log('🛑 ActivityController disposed - stopping all geocoding operations');
    super.dispose();
  }
}