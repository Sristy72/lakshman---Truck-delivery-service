import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/constants/app_images.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/accounts/data/models/driver_profile_response_model.dart';
import 'package:flutter_lakshman1020/features/delivery_details/presentation/screens/driver_delivery_details_screen.dart';
import 'package:flutter_lakshman1020/features/home/controller/driver_home_controller.dart';
import 'package:flutter_lakshman1020/features/home/presentations/screens/load_navigation_screen.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/driver_home_widgets/load_stop.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CurrentLoadSection extends StatelessWidget {
  const CurrentLoadSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Get DriverHomeController
    final controller = Get.find<DriverHomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Current Load",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Obx(() {
          // Loading state
          if (controller.isLoading.value) {
            return const Card(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    SkeletonText(width: 150, height: 20),
                    SizedBox(height: 24),
                    SkeletonText(width: double.infinity, height: 16),
                    SizedBox(height: 12),
                    SkeletonText(width: double.infinity, height: 14),
                    SizedBox(height: 24),
                    SkeletonText(width: double.infinity, height: 16),
                    SizedBox(height: 12),
                    SkeletonText(width: double.infinity, height: 14),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        SkeletonText(width: 100, height: 36),
                        Spacer(),
                        SkeletonText(width: 100, height: 36),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          // Error state
          if (controller.errorMessage.isNotEmpty) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.refreshLoads(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Empty state
          if (controller.currentLoads.isEmpty) {
            return Card(
              color: TColors.white1,
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.local_shipping_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No current loads',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Single load - show normally
          if (controller.currentLoads.length == 1) {
            return _LoadCard(load: controller.currentLoads.first);
          }

          // Multiple loads - show horizontal list
          return SizedBox(
            height: 400,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.currentLoads.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  margin: EdgeInsets.only(right: index < controller.currentLoads.length - 1 ? 12 : 0),
                  child: _LoadCard(load: controller.currentLoads[index]),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

class _LoadCard extends StatelessWidget {
  final CurrentLoad load;

  const _LoadCard({required this.load});

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'driver_pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'driver_pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'in_progress':
        return TColors.activityColor;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'driver_pending':
        return const Color(0xFFFFFDE8);
      case 'accepted':
        return Colors.blue.shade50;
      case 'in_progress':
        return const Color(0xFFFFFDE8);
      case 'completed':
        return Colors.green.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dateToCheck = DateTime(date.year, date.month, date.day);

      if (dateToCheck == today) {
        return 'Today, ${DateFormat('h:mm a').format(date)}';
      } else {
        return DateFormat('MMM d, h:mm a').format(date);
      }
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DriverHomeController>();

    return Obx(() {
      final geocodedData = controller.geocodedAddresses[load.id];
      final isGeocoding = controller.geocodingInProgress[load.id] ?? false;

      final pickupAddress = geocodedData?['pickup'] ?? '';
      final deliveryAddress = geocodedData?['delivery'] ?? '';

      return Card(
        color: TColors.white1,
        shadowColor: TColors.primary,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Load ID and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Load ID #${load.id.substring(load.id.length - 8)}",
                      style: const TextStyle(
                        color: TColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: _getStatusColor(load.orderStatus)),
                      borderRadius: BorderRadius.circular(8),
                      color: _getStatusBgColor(load.orderStatus),
                    ),
                    child: Text(
                      _formatStatus(load.orderStatus),
                      style: TextStyle(
                        color: _getStatusColor(load.orderStatus),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Pickup
              isGeocoding && pickupAddress.isEmpty
                  ? const LinearProgressIndicator()
                  : LoadStop(
                      label: "Pickup",
                      location: pickupAddress.isEmpty ? load.pickupLocation : pickupAddress,
                      status: "Scheduled",
                      statusColor: Colors.green,
                      time: _formatDate(load.pickupDate),
                    ),
              const SizedBox(height: 16),

              // Final Destination
              isGeocoding && deliveryAddress.isEmpty
                  ? const LinearProgressIndicator()
                  : LoadStop(
                      label: "Final Destination",
                      location: deliveryAddress.isEmpty ? load.deliveryLocation : deliveryAddress,
                      status: "Pending",
                      statusColor: Colors.red,
                      time: _formatDate(load.pickupDate),
                    ),

              const SizedBox(height: 12),

              // Bottom actions
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // Navigate to map screen with load details
                      Get.to(
                        () => LoadNavigationScreen(load: load),
                      );
                    },
                    icon: const Image(
                      image: AssetImage(AppImages.truckIcon),
                      height: 12,
                      width: 12,
                    ),
                    label: const Text(
                      "Navigate",
                      style: TextStyle(color: TColors.primary),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // Navigate to driver delivery details screen with load ID
                      Get.to(
                        () => DriverDeliveryDetailsScreen(loadId: load.id),
                      );
                    },
                    child: const Text(
                      "View Details",
                      style: TextStyle(color: TColors.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
