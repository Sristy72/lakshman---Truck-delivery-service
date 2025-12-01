import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/dispatcher/presentation/screens/company_driver_details_screen.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/data/datasources/driver_remote_datasource.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/data/repository/driver_repository_impl.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/model/dariver_model.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/presentation/controllers/driver_controller.dart';
import 'package:get/get.dart';

class AssignDriverScreen extends StatefulWidget {
  final String loadId;

  const AssignDriverScreen({super.key, required this.loadId});

  @override
  State<AssignDriverScreen> createState() => _AssignDriverScreenState();
}

class _AssignDriverScreenState extends State<AssignDriverScreen> {
  late DriverController _driverController;
  late RxString searchQuery = ''.obs;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    try {
      // Check if controller is already registered
      if (Get.isRegistered<DriverController>()) {
        _driverController = Get.find<DriverController>();
        debugPrint('✅ Found existing DriverController');
        
        // If controller already has data and no error, use it
        // Otherwise fetch fresh data
        if (_driverController.drivers.isEmpty && _driverController.errorMessage.isEmpty) {
          debugPrint('🔄 Existing controller has no data, fetching...');
          _driverController.fetchDrivers();
        }
      } else {
        // Create and register a new instance if not exists
        debugPrint('🔨 Creating new DriverController instance');
        final apiClient = ApiClient();
        final remoteDataSource = DriverRemoteDataSourceImpl(apiClient: apiClient);
        final repository = DriverRepositoryImpl(remoteDataSource: remoteDataSource);
        _driverController = DriverController(repository: repository);
        Get.put(_driverController);
        // onInit() is called automatically by Get.put, which calls fetchDrivers()
        debugPrint('✅ New DriverController registered and onInit() called');
      }
      
      // Mark as initialized - UI will now show via Obx
      setState(() => _isInitialized = true);
      
      debugPrint('✅ DriverController initialization complete');
    } catch (e) {
      debugPrint('❌ Error initializing DriverController: $e');
      setState(() => _isInitialized = true);
      
      // Show error in UI
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing driver list: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: const CustomAppBar(title: "Assign Driver"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: "Assign Driver"),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // 🔍 Search bar
            TextField(
              onChanged: (val) => searchQuery.value = val.toLowerCase(),
              decoration: InputDecoration(
                hintText: "Search",
                filled: true,
                fillColor: Colors.grey.shade100,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Available driver",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Driver list with Obx for reactive updates
            Expanded(
              child: Obx(() {
                // Show loading state
                if (_driverController.isLoading.value) {
                  return ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => const SkeletonListItem(
                      hasLeading: true,
                      hasTrailing: true,
                      lines: 2,
                    ),
                  );
                }

                // Show error state
                if (_driverController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${_driverController.errorMessage.value}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _driverController.fetchDrivers(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Show empty state
                if (_driverController.drivers.isEmpty) {
                  return const Center(
                    child: Text('No drivers available'),
                  );
                }

                // Filter drivers based on search query
                final filtered = _driverController.drivers
                    .where((d) =>
                        d.name.toLowerCase().contains(searchQuery.value))
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('No drivers found matching your search'),
                  );
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 10, color: Colors.transparent),
                  itemBuilder: (context, index) {
                    final driver = filtered[index];
                    return _buildDriverCard(driver);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard(Driver driver) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: CircleAvatar(
          backgroundImage: (driver.imageUrl != null && driver.imageUrl!.isNotEmpty)
              ? NetworkImage(driver.imageUrl!)
              : const AssetImage('assets/images/profile_d.png'),
          radius: 22,
          onBackgroundImageError: (exception, stackTrace) {
            debugPrint('❌ Error loading driver image: $exception');
          },
        ),
        title: Text(
          driver.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: driver.phone.isNotEmpty
            ? Text(
                driver.phone,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )
            : null,
        trailing: TextButton(
          onPressed: () => _assignDriver(driver),
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
          child: const Text(
            "Assign",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  void _assignDriver(Driver driver) {
    debugPrint('🚗 Navigating to driver details for ${driver.name}');

    // Navigate to the company driver details screen where user can confirm assignment
    Get.to(() => CompanyDriverDetailsScreen(driver: driver, loadId: widget.loadId));
  }
}
