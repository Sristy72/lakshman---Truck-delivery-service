import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/delivery_details/presentation/screens/driver_delivery_details_screen.dart';
import 'package:get/get.dart';

import '../controller/activitry_controller.dart';

class ActivityListWidget extends StatelessWidget {
  final ActivityController controller;

  const ActivityListWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.activities.length,
      itemBuilder: (context, index) {
        return ActivityItemWidget(activity: controller.activities[index]);
      },
    );
  }
}

// presentation/widgets/activity_item_widget.dart
class ActivityItemWidget extends StatelessWidget {
  final Map<String, String> activity;

  const ActivityItemWidget({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to driver delivery details screen with load ID
        Get.to(
          () => DriverDeliveryDetailsScreen(loadId: activity['id']),
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
              'N',
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
                  activity['id']!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  activity['description']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 14),
                  SizedBox(width: 4),
                  Text(
                    activity['status']!,
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
                  Icon(Icons.location_on, color: Colors.grey.shade500, size: 14),
                  SizedBox(width: 2),
                  Text(
                    activity['location']!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
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