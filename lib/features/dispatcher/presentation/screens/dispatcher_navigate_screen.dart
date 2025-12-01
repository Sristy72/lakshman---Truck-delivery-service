import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/network/services/auth_storage_service.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/home/presentations/bindings/load_binding.dart';
import 'package:flutter_lakshman1020/features/home/presentations/controllers/load_controller.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class DispatcherNavigateScreen extends StatefulWidget {
  const DispatcherNavigateScreen({super.key});

  @override
  State<DispatcherNavigateScreen> createState() => _DispatcherNavigateScreenState();
}

class _DispatcherNavigateScreenState extends State<DispatcherNavigateScreen> with AutomaticKeepAliveClientMixin {
  final AuthStorageService _authStorageService = Get.find<AuthStorageService>();
  late LoadController _loadController;
  
  // Map to store geocoded addresses: loadId -> {pickup, delivery}
  final Map<String, Map<String, String>> _geocodedAddresses = {};
  final Map<String, bool> _geocodingInProgress = {};
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    
    // Register LoadController if not already registered
    if (!Get.isRegistered<LoadController>()) {
      LoadBinding().dependencies();
    }
    
    _loadController = Get.find<LoadController>();
    _loadCompanyIdAndFetchLoads();
  }
  
  /// Public method to refresh data when tab becomes visible
  Future<void> refreshData() async {
    await _loadCompanyIdAndFetchLoads();
  }

  Future<void> _loadCompanyIdAndFetchLoads() async {
    try {
      // Get company ID from auth storage
      final companyId = await _authStorageService.getCompanyId();
      final role = await _authStorageService.getRole();
      
      DPrint.log('========== DISPATCHER NAVIGATE SCREEN ==========');
      DPrint.log('👤 Role: $role');
      DPrint.log('📦 Company ID: ${companyId ?? "null"}');
      
      if (companyId != null && companyId.isNotEmpty) {
        DPrint.log('🔄 Fetching loads for company...');
        
        // Fetch loads for this company
        await _loadController.fetchLoadsByCompany(companyId);
        
        DPrint.log('✅ Loads fetched successfully');
        DPrint.log('📊 Total loads: ${_loadController.loads.length}');
        
        // Start geocoding addresses in parallel
        _geocodeAllAddresses();
      } else {
        DPrint.log('⚠️ No company ID found');
        Get.snackbar(
          'Error',
          'Company ID not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      
      DPrint.log('==============================================');
    } catch (e) {
      DPrint.error('❌ Error loading dispatcher navigate data: $e');
      Get.snackbar(
        'Error',
        'Failed to load data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _geocodeAllAddresses() async {
    final loads = _loadController.loads;
    
    DPrint.log('🌍 Starting parallel geocoding for ${loads.length} loads...');
    
    // Process all loads in parallel
    await Future.wait(
      loads.map((load) => _geocodeLoadAddresses(load.id, load.pickupLocation, load.deliveryLocation))
    );
    
    DPrint.log('✅ Geocoding complete for all loads');
  }

  Future<void> _geocodeLoadAddresses(String loadId, String pickupLatLng, String deliveryLatLng) async {
    if (_geocodingInProgress[loadId] == true) return;
    
    setState(() {
      _geocodingInProgress[loadId] = true;
    });

    try {
      // Parse coordinates from strings (format: "lat,lng")
      final pickupParts = pickupLatLng.split(',').map((s) => s.trim()).toList();
      final deliveryParts = deliveryLatLng.split(',').map((s) => s.trim()).toList();

      double pickupLat = double.parse(pickupParts[0]);
      double pickupLng = double.parse(pickupParts[1]);
      double deliveryLat = double.parse(deliveryParts[0]);
      double deliveryLng = double.parse(deliveryParts[1]);

      // Geocode both addresses in parallel using placemarkFromCoordinates
      final results = await Future.wait([
        _getAddressFromCoordinates(pickupLat, pickupLng),
        _getAddressFromCoordinates(deliveryLat, deliveryLng),
      ]);

      if (mounted) {
        setState(() {
          _geocodedAddresses[loadId] = {
            'pickup': results[0],
            'delivery': results[1],
          };
          _geocodingInProgress[loadId] = false;
        });
      }
    } catch (e) {
      DPrint.error('❌ Error geocoding addresses for load $loadId: $e');
      if (mounted) {
        setState(() {
          _geocodingInProgress[loadId] = false;
        });
      }
    }
  }

  /// Convert coordinates to human-readable address using placemarkFromCoordinates
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
      DPrint.error('Error geocoding $latitude, $longitude: $e');
      return '$latitude, $longitude';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Navigate',
          onBack: () => Get.back(),
        ),
      ),
      body: Obx(
        () {
          if (_loadController.isLoading.value) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SkeletonListItem(
                  hasLeading: false,
                  hasTrailing: true,
                  lines: 4,
                ),
              ),
            );
          }

          if (_loadController.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _loadController.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loadCompanyIdAndFetchLoads,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final loads = _loadController.loads;

          if (loads.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No loads available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: loads.length,
            itemBuilder: (context, index) {
              final load = loads[index];
              final geocodedData = _geocodedAddresses[load.id];
              final isGeocoding = _geocodingInProgress[load.id] == true;

              // Get addresses
              final pickupAddress = geocodedData?['pickup'] ?? '';
              final deliveryAddress = geocodedData?['delivery'] ?? '';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFF0F0F0),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Load Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.local_shipping,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Load details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '#${load.id}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            load.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Addresses
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Pickup address
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            isGeocoding && pickupAddress.isEmpty
                                ? const SizedBox(
                                    width: 80,
                                    height: 12,
                                    child: LinearProgressIndicator(
                                      backgroundColor: Color(0xFFF0F0F0),
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                    ),
                                  )
                                : SizedBox(
                                    width: 120,
                                    child: Text(
                                      pickupAddress.isEmpty 
                                          ? load.pickupLocation
                                          : pickupAddress,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Delivery address
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4),
                            isGeocoding && deliveryAddress.isEmpty
                                ? const SizedBox(
                                    width: 80,
                                    height: 12,
                                    child: LinearProgressIndicator(
                                      backgroundColor: Color(0xFFF0F0F0),
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                    ),
                                  )
                                : SizedBox(
                                    width: 120,
                                    child: Text(
                                      deliveryAddress.isEmpty 
                                          ? load.deliveryLocation
                                          : deliveryAddress,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
