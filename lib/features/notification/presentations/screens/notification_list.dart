import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_icons.dart';
import 'package:flutter_lakshman1020/core/widgets/notification_tile.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:get/get.dart';

import '../bindings/notification_binding.dart';
import '../controllers/notification_controller.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize bindings if not already initialized
    if (!Get.isRegistered<NotificationController>()) {
      NotificationBinding().dependencies();
    }
    
    // Fetch notifications only if not already loaded
    final notificationController = Get.find<NotificationController>();
    if (notificationController.notifications.isEmpty) {
      notificationController.fetchNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController = Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Unread count badge
          Obx(() {
            final unreadCount = notificationController.unreadCount;
            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    // Future action for marking all as read
                  },
                  icon: Image.asset(
                    AppIcons.notification,
                    width: 22,
                    height: 22,
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(width: 12),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => notificationController.refreshNotifications(),
        child: Obx(() {
          if (notificationController.isLoading.value) {
            return ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) => const SkeletonListItem(
                hasLeading: true,
                lines: 3,
              ),
            );
          }

          if (notificationController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notificationController.errorMessage.value,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => notificationController.fetchNotifications(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (notificationController.notifications.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You\'ll see notifications here when they arrive',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: notificationController.notifications.length,
            itemBuilder: (context, index) {
              final notification = notificationController.notifications[index];
              return GestureDetector(
                onTap: () {
                  // Mark as read when tapped
                  if (!notification.isRead) {
                    notificationController.markAsRead(notification.id);
                  }
                  // Future: Navigate to detail screen or perform action
                },
                child: NotificationTile(
                  notification: notification,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
