import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/manage_users/presentation/add_driver_screen.dart';
import 'package:get/get.dart';

import '../../../others/presentation/widgets/company_appbar.dart';
import '../../../others/presentation/widgets/company_drawer.dart';
import '../bindings/driver_binding.dart';
import '../controllers/driver_controller.dart';
import '../widgets/list_items.dart';

class CompanyDriverScreen extends StatefulWidget {
  const CompanyDriverScreen({super.key});

  @override
  State<CompanyDriverScreen> createState() => _CompanyDriverScreenState();
}

class _CompanyDriverScreenState extends State<CompanyDriverScreen> {
  late DriverController _driverController;

  @override
  void initState() {
    super.initState();
    // Register binding if not already registered
    if (!Get.isRegistered<DriverController>()) {
      DriverBinding().dependencies();
    }
    _driverController = Get.find<DriverController>();
  }

  @override
  Widget build(BuildContext context) {
    // Auto-reload drivers when screen is visited
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _driverController.fetchDrivers();
    });

    return AppScaffold(
      appBar: CompanyAppbar(),
      drawer: CompanyDrawer(),
      body: Obx(
        () {
          // Loading state
          if (_driverController.isLoading.value) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SkeletonListItem(
                  hasLeading: true,
                  hasTrailing: true,
                  lines: 2,
                ),
              ),
            );
          }

          // Error state
          if (_driverController.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${_driverController.errorMessage.value}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _driverController.fetchDrivers(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (_driverController.drivers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No drivers found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _driverController.fetchDrivers(),
                    child: Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          // Driver list
          return Column(
            children: [
              // Header with icon and title
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      height: 16,
                      width: 16,
                      child: Image.asset(
                        "assets/icons/company_icon2.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Driver",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Filter buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Spacer(),

                    // Add button
                    GestureDetector(
                      onTap: () {
                        // Handle add driver functionality
                        Get.to(() => AddDriverScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color(0xffF5FFF9),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Add",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF219653),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.add,
                              size: 16,
                              color: Color(0xFF219653),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Table headers
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF18191A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Driver list
              Expanded(
                child: ListView.separated(
                  itemCount: _driverController.drivers.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final driver = _driverController.drivers[index];
                    return DriverListItem(
                      name: driver.name,
                      deliveryCount: driver.deliveryCount,
                      rating: driver.rating,
                      imageUrl: driver.imageUrl ?? "assets/images/truck_home.png",
                      driver: driver,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
