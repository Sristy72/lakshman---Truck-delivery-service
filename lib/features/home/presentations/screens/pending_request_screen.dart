import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/network/services/auth_storage_service.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/pending_request_filter.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/pending_request_item.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../../models/shipment_model.dart';
import '../bindings/load_binding.dart';
import '../controllers/load_controller.dart';


// class PendingReqScreen1 extends StatelessWidget {
//   const PendingReqScreen1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         titleCenter: true,
//         title:("Pending request"),
//       ),

//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               PendingRequestFilter(),
//               SizedBox(height: 16),
//               Column(
//                 children: shipments.map((shipment) {
//                   return PendingRequestItem(shipment: shipment);
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


class PendingReqScreen1 extends StatefulWidget {
  const PendingReqScreen1({super.key});

  @override
  State<PendingReqScreen1> createState() => _PendingReqScreen1State();
}

class _PendingReqScreen1State extends State<PendingReqScreen1> {
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
      final role = await _authStorageService.getRole();
      
      DPrint.log('========== DISPATCHER PENDING REQUEST SCREEN ==========');
      DPrint.log('👤 Role: $role');
      DPrint.log('📦 Company ID: ${companyId ?? "null"}');
      
      if (companyId != null && companyId.isNotEmpty) {
        DPrint.log('🔄 Fetching loads for company...');
        
        // Fetch loads for this company (same as company role)
        await _loadController.fetchLoadsByCompany(companyId);
        
        DPrint.log('✅ Loads fetched successfully');
        DPrint.log('📊 Total loads: ${_loadController.loads.length}');
        DPrint.log('📊 Filtered loads: ${_loadController.filteredLoads.length}');
      } else {
        DPrint.log('⚠️ No company ID, fetching all loads...');
        // Fallback: fetch all loads if no company ID
        await _loadController.fetchLoads();
      }
      
      DPrint.log('====================================================');
    } catch (e) {
      DPrint.error('❌ Error loading dispatcher data: $e');
      Get.snackbar(
        'Error',
        'Failed to load data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleCenter: true,
        title: "Pending request",
      ),
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
                      child: Text("No loads available"),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: loads
                            .map((load) => PendingRequestItem(
                                  shipment: Shipment(
                                    id: load.id, // Pass full MongoDB ObjectId
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
