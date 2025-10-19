import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/constants/app_images.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:flutter_lakshman1020/features/notification/presentations/screens/notification_alert.dart';
import 'package:get/get.dart';
import '../../../../accounts/controller/account_controller.dart';
import '../../../../accounts/presentation/screens/accounts_screen.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final accountController = Get.find<AccountController>();

    // Fetch profile when header loads (optional if already fetched in onInit)
    // accountController.fetchProfile();

    return GestureDetector(
      onTap: () => Get.to(() => const AccountsScreen()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // ✅ Profile Avatar (reactive)
            Obx(() {
              final user = accountController.userInfo.value;
              final avatarUrl = user?.avatar?.url ?? "";

              return CircleAvatar(
                radius: 24,
                backgroundImage: avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : const AssetImage(AppImages.accountUser) as ImageProvider,
              );
            }),

            const SizedBox(width: 8),

            // ✅ User Info (name + username)
            Obx(() {
              final user = accountController.userInfo.value;
              final name = user?.name ?? "Loading...";
              final email = user?.email ?? "";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back, $name",
                    style: const TextStyle(
                      color: TColors.activityColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "@${email.split('@').first}",
                    style: const TextStyle(
                      color: TColors.activityColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }),

            const Spacer(),

            // ✅ Notification icon
            IconButton(
              icon: const Image(
                image: AssetImage("assets/images/notification.png"),
                height: 32,
                width: 32,
              ),
              onPressed: () => Get.to(() => const NotificationAlertScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
