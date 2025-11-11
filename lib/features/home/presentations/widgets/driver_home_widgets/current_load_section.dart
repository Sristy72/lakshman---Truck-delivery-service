import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/constants/app_images.dart';
import 'package:flutter_lakshman1020/features/delivery_details/presentation/screens/driver_delivery_details_screen.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/driver_home_widgets/load_stop.dart';
import 'package:get/get.dart';

class CurrentLoadSection extends StatelessWidget {
  const CurrentLoadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Current Load",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        _LoadCard(),
      ],
    );
  }
}

class _LoadCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                const Expanded(
                  child: Text(
                    "Load ID #L-1200",
                    style: TextStyle(
                      color: TColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFFFFFDE8),
                  ),
                  child: const Text(
                    "In Progress",
                    style: TextStyle(
                      color: TColors.activityColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pickup
            LoadStop(
              label: "Pickup",
              location: "Milwaukee, WI",
              status: "Completed",
              statusColor: Colors.green,
              time: "Today, 10:00 AM",
            ),
            SizedBox(height: 16),
            // Next Stoppage
            LoadStop(
              label: "Next Stoppage",
              location: "Chicago, IL",
              status: "Est. 0:45 min",
              statusColor: Colors.red,
              time: "Today, 1:30 PM",
            ),
            SizedBox(height: 16),

            // Final Destination
            LoadStop(
              label: "Final Destination",
              location: "Panhandle, IL",
              status: "Est. 3:45 min",
              statusColor: Colors.red,
              time: "Today, 4:30 PM",
            ),

            const SizedBox(height: 12),

            // Bottom actions
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
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
                      () => DriverDeliveryDetailsScreen(),
                      arguments: 'L-1200', // Pass load ID as argument
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
  }
}
