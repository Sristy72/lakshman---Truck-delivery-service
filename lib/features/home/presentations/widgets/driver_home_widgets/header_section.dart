import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_images.dart';
import 'package:flutter_lakshman1020/features/notification/presentations/bindings/notification_binding.dart';
import 'package:flutter_lakshman1020/features/notification/presentations/controllers/notification_controller.dart';
import 'package:flutter_lakshman1020/features/notification/presentations/screens/notification_list.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../accounts/controller/account_controller.dart';
import '../../../../accounts/presentation/screens/accounts_screen.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final accountController = Get.find<AccountController>();

    return GestureDetector(
      onTap: () => Get.to(() => const AccountsScreen(),transition: Transition.rightToLeft),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          children: [
            // ✅ Profile Avatar (reactive)
            Obx(() {
              final user = accountController.userInfo.value;
              final avatarUrl = user?.avatar.url ?? "";

              return CircleAvatar(
                radius: 24,
                backgroundImage: avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : const AssetImage(AppImages.accountUser) as ImageProvider,
              );
            }),

            const SizedBox(width: 8),

            // ✅ User Info (name + date) — use Expanded + overflow handling
            Obx(() {
              final user = accountController.userInfo.value;
              final name = user?.name ?? "Niloy";
              
              // Get today's date in the format: 31 October, 2025
              final now = DateTime.now();
              final dateFormat = DateFormat('d MMMM, yyyy');
              final todayDate = dateFormat.format(now);

              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Welcome back, $name",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      todayDate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),

            // ✅ Notification icon
            IconButton(
              icon: const Image(
                image: AssetImage("assets/images/notification.png"),
                height: 32,
                width: 32,
              ),
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
        ),
      ),
    );
  }
}
