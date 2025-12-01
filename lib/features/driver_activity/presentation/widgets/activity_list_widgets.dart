import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/delivery_details/presentation/screens/driver_delivery_details_screen.dart';
import 'package:flutter_lakshman1020/features/home/domain/entities/load_entity.dart';
import 'package:get/get.dart';

import '../controller/activitry_controller.dart';

class ActivityListWidget extends StatelessWidget {
  final ActivityController controller;

  const ActivityListWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Show empty state if no loads
    if (controller.loads.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              'No activities yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Activities will appear here once loads are assigned',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.loads.length,
      itemBuilder: (context, index) {
        return ActivityItemWidget(
          load: controller.loads[index],
          controller: controller,
        );
      },
    );
  }
}

// presentation/widgets/activity_item_widget.dart
class ActivityItemWidget extends StatelessWidget {
  final LoadEntity load;
  final ActivityController controller;

  const ActivityItemWidget({
    Key? key,
    required this.load,
    required this.controller,
  }) : super(key: key);

  String _formatLoadId(String id) {
    // Show last 8 characters of ID
    if (id.length > 8) {
      return '#${id.substring(id.length - 8)}';
    }
    return '#$id';
  }

  String _formatStatus(String status) {
    // Capitalize first letter and format status
    return status.replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Color(0xFF4CAF50); // Green
      case 'in_progress':
      case 'picked_up':
        return Color(0xFF2196F3); // Blue
      case 'pending':
        return Color(0xFFFFA726); // Orange
      case 'cancelled':
        return Color(0xFFF44336); // Red
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final geocodedAddress = controller.getGeocodedAddress(load.id);
    final isGeocoding = controller.isGeocoding(load.id);
    final pickupAddress = geocodedAddress?['pickup'] ?? load.pickupLocation;

    return GestureDetector(
      onTap: () {
        // Navigate to driver delivery details screen with load ID
        Get.to(
          () => DriverDeliveryDetailsScreen(loadId: load.id),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFF2C3E50),
              child: Text(
                load.category.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatLoadId(load.id),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    load.description.isNotEmpty
                        ? load.description
                        : load.title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: _getStatusColor(load.orderStatus),
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      _formatStatus(load.orderStatus),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    if (isGeocoding) ...[
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      SizedBox(width: 4),
                    ] else
                      Icon(Icons.location_on, color: Colors.grey.shade500, size: 14),
                    SizedBox(width: 2),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 120),
                      child: Text(
                        pickupAddress,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}