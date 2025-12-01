import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_appbar.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_drawer.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/revenue_graph.dart';
import 'package:get/get.dart';

import '../bindings/dashboard_binding.dart';
import '../controllers/dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardController _dashboardController;

  @override
  void initState() {
    super.initState();
    // Register binding if not already registered
    if (!Get.isRegistered<DashboardController>()) {
      DashboardBinding().dependencies();
    }
    _dashboardController = Get.find<DashboardController>();
    
    // Reload dashboard data after the first frame is built
    // This prevents "setState called during build" error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dashboardController.fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanyAppbar(),
      backgroundColor: Colors.white,
      body: Obx(() {
        // Loading state
        if (_dashboardController.isLoading.value) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonText(width: 150, height: 24),
                const SizedBox(height: 24),
                const SkeletonDashboardStats(),
                const SizedBox(height: 24),
                SkeletonLoader(
                  width: double.infinity,
                  height: 250,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(height: 24),
                const SkeletonText(width: 120, height: 20),
                const SizedBox(height: 16),
                ...List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SkeletonLoader(
                      width: double.infinity,
                      height: 80,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Error state
        if (_dashboardController.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  _dashboardController.errorMessage.value,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _dashboardController.fetchDashboard(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Success state with data
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/dashboard_icon.png",
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Dashboard / Overview",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _buildStatCard(
                    imagePath: "assets/images/today_delivery.png",
                    title: "Today's delivery",
                    value: _dashboardController.todaysDelivery.toString(),
                  ),
                  _buildStatCard(
                    imagePath: "assets/images/today_earning.png",
                    title: "Today's Earnings",
                    value: _dashboardController.todaysEarningsFormatted,
                  ),
                  _buildStatCard(
                    imagePath: "assets/images/active_drivers.png",
                    title: "Active drivers",
                    value: _dashboardController.activeDrivers.toString(),
                  ),
                  _buildStatCard(
                    imagePath: "assets/images/running_loads.png",
                    title: "Running loads",
                    value: _dashboardController.runningLoads.toString(),
                  ),
                ],
              ),

              RevenueGraph(chartData: _dashboardController.chartData),
            ],
          ),
        );
      }),
      drawer: CompanyDrawer(),
    );
  }

  Widget _buildStatCard({
    required String imagePath,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 48, height: 48),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
