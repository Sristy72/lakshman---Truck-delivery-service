import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/notification/presentations/bindings/notification_binding.dart';
import 'package:flutter_lakshman1020/features/notification/presentations/controllers/notification_controller.dart';
import 'package:flutter_lakshman1020/features/notification/presentations/screens/notification_list.dart';
import 'package:get/get.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Welcome back! Here's an overview of your transport operations.",
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
        ),
        // Notification icon button
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 28),
          onPressed: () async {
            // Initialize notification binding if needed
            if (!Get.isRegistered<NotificationController>()) {
              NotificationBinding().dependencies();
            }
            
            // Get controller and fetch notifications if empty
            final notificationController = Get.find<NotificationController>();
            if (notificationController.notifications.isEmpty) {
              await notificationController.fetchNotifications();
            }
            
            // Navigate to notification list screen
            Get.to(() => const NotificationListScreen());
          },
        ),
      ],
    );
  }
}