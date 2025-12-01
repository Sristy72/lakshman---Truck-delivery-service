import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/core/network/services/auth_storage_service.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/model/dariver_model.dart';
import 'package:flutter_lakshman1020/features/home/presentations/controllers/load_controller.dart';
import 'package:flutter_lakshman1020/features/home/presentations/screens/dispatcher_home_screen.dart';
import 'package:flutter_lakshman1020/features/others/data/models/assign_driver_request_model.dart';
import 'package:flutter_lakshman1020/features/others/data/repo/load_repo_impl.dart';
import 'package:flutter_lakshman1020/features/others/domain/load_repo.dart';
import 'package:flutter_lakshman1020/features/others/presentation/screen/dashboard_overview_scren.dart';
import 'package:get/get.dart';

class CompanyDriverDetailsScreen extends StatefulWidget {
  final Driver driver;
  final String? loadId;

  const CompanyDriverDetailsScreen({super.key, required this.driver, this.loadId});

  @override
  State<CompanyDriverDetailsScreen> createState() => _CompanyDriverDetailsScreenState();
}

class _CompanyDriverDetailsScreenState extends State<CompanyDriverDetailsScreen> {
  late final AskPriceRepository _loadRepository;
  late final AuthStorageService _authStorageService;
  bool _isAssigning = false;

  @override
  void initState() {
    super.initState();
    _loadRepository = LoadRepositoryImpl(apiClient: ApiClient());
    _authStorageService = Get.find<AuthStorageService>();
  }

  Future<void> _handleAssignDriver() async {
    // Validate loadId
    if (widget.loadId == null || widget.loadId!.isEmpty) {
      Get.snackbar(
        'Error',
        'Load ID is missing',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    setState(() => _isAssigning = true);

    try {
      final request = AssignDriverRequestModel(driverId: widget.driver.id);
      debugPrint('🚗 Assigning driver ${widget.driver.name} (${widget.driver.id}) to load ${widget.loadId}');

      final result = await _loadRepository.assignDriver(widget.loadId!, request);

      setState(() => _isAssigning = false);

      result.fold(
        (failure) {
          // API call failed
          debugPrint('❌ Assign driver API failed: ${failure.message}');
          Get.snackbar(
            'Error',
            'Failed to assign driver: ${failure.message}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade50,
            colorText: Colors.red.shade900,
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 3),
          );
        },
        (success) {
          // API call success
          debugPrint('✅ Driver assigned successfully!');
          debugPrint('📦 Response - Status: ${success.data.orderStatus}, Driver: ${success.data.driver}');

          Get.snackbar(
            'Success',
            '${widget.driver.name} assigned to load successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade50,
            colorText: Colors.green.shade900,
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 2),
          );

          // Refresh the load data by fetching loads again
          try {
            final loadController = Get.find<LoadController>();
            debugPrint('🔄 Refreshing load data...');
            loadController.fetchLoads();
          } catch (e) {
            debugPrint('⚠️ Could not refresh LoadController: $e');
          }

          // Navigate to appropriate dashboard based on user role after delay
          Future.delayed(const Duration(milliseconds: 1500), () async {
            if (mounted) {
              // Get user role from auth storage
              final role = await _authStorageService.getRole();
              debugPrint('👤 User role: $role');
              
              if (role?.toLowerCase() == 'dispatcher') {
                debugPrint('🔙 Navigating to Dispatcher Home Screen...');
                Get.offAll(
                  () => const DispatcherHomeScreen(),
                  transition: Transition.leftToRight,
                );
              } else {
                // Default to company dashboard for company role
                debugPrint('🔙 Navigating to Company Dashboard...');
                Get.offAll(
                  () => const DashboardScreen(),
                  transition: Transition.leftToRight,
                );
              }
            }
          });
        },
      );
    } catch (e) {
      setState(() => _isAssigning = false);
      debugPrint('❌ Unexpected error: $e');
      Get.snackbar(
        'Error',
        'Unexpected error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF666666), fontSize: 14)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, color: Color(0xFF18191A)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Personal details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Center(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: (widget.driver.imageUrl != null && widget.driver.imageUrl!.isNotEmpty)
                        ? NetworkImage(widget.driver.imageUrl!) as ImageProvider
                        : const AssetImage('assets/images/profile_d.png'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildRow('Name', widget.driver.name),
            const Divider(height: 1, color: Color(0xFFDCE4F5)),
            _buildRow('Mail', widget.driver.email ?? '-'),
            const Divider(height: 1, color: Color(0xFFDCE4F5)),
            _buildRow('Mobile', widget.driver.phone),
            const Divider(height: 1, color: Color(0xFFDCE4F5)),
            _buildRow('Address', '-'),
            const Divider(height: 1, color: Color(0xFFDCE4F5)),
            _buildRow('Date of Birth', '-'),
            const Divider(height: 1, color: Color(0xFFDCE4F5)),
            _buildRow('Nationality', '-'),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAssigning ? null : _handleAssignDriver,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B5DCB),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isAssigning
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Assign', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
