import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/network/services/auth_storage_service.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_drawer.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/pending_request_filter.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/pending_request_item.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../../../home/models/shipment_model.dart';
import '../../../home/presentations/bindings/load_binding.dart';
import '../../../home/presentations/controllers/load_controller.dart';

class CompanyPendingReqScreen extends StatefulWidget {
  const CompanyPendingReqScreen({super.key});

  @override
  State<CompanyPendingReqScreen> createState() =>
      _CompanyPendingReqScreenState();
}

class _CompanyPendingReqScreenState extends State<CompanyPendingReqScreen> {
  final AuthStorageService _authStorageService = Get.find<AuthStorageService>();
  late LoadController _loadController;

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

  Future<void> _loadCompanyIdAndFetchLoads() async {
    try {
      // Get company ID from auth storage
      final companyId = await _authStorageService.getCompanyId();
      
      if (companyId != null && companyId.isNotEmpty) {
        DPrint.log('========== COMPANY PENDING REQUEST SCREEN ==========');
        DPrint.log('📦 Company ID: $companyId');
        DPrint.log('� Current filter: ${_loadController.selectedFilter.value}');
        DPrint.log('�🔄 Fetching loads for company...');
        
        // Fetch loads for this company
        await _loadController.fetchLoadsByCompany(companyId);
        
        DPrint.log('✅ Loads fetched successfully');
        DPrint.log('📊 Total loads: ${_loadController.loads.length}');
        DPrint.log('📊 Filtered loads: ${_loadController.filteredLoads.length}');
        DPrint.log('====================================================');
      } else {
        DPrint.error('❌ Company ID not found in auth storage');
        Get.snackbar(
          'Error',
          'Company ID not found. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      DPrint.error('❌ Error loading company data: $e');
      Get.snackbar(
        'Error',
        'Failed to load company data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: "Pending Requests",
          titleCenter: true,
        ),
      ),
      drawer: const CompanyDrawer(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Obx(
          () {
            if (_loadController.isLoading.value) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const PendingRequestFilter(),
                    const SizedBox(height: 16),
                    ...List.generate(
                      5,
                      (index) => const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: SkeletonListItem(
                          hasLeading: true,
                          hasTrailing: true,
                          lines: 3,
                        ),
                      ),
                    ),
                  ],
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

            final loads = _loadController.filteredLoads;

            return Column(
              children: [
                const PendingRequestFilter(),
                const SizedBox(height: 16),
                if (loads.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text("No pending requests available"),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: loads
                            .map((load) => PendingRequestItem(
                                  shipment: Shipment(
                                    id: load.id, // Pass actual load ID
                                    title: load.title,
                                    description: load.description,
                                    status: load.orderStatus.toLowerCase() == 'accepted',
                                    origin: load.pickupLocation,
                                    destination: load.deliveryLocation,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
