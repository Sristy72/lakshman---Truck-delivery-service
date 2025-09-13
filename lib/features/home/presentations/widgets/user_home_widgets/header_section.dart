import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/constants/app_images.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:flutter_lakshman1020/features/notification/presentations/screens/notification_alert.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HeaderSection extends StatelessWidget {
  const  HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: ()=>Get.to(AccountsScreen()),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(AppImages.accountUser),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.all(2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "Welcome back, Daniel",
                  style: TextStyle(
                    color: TColors.activityColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "@daniel001",
                  style: TextStyle(color: TColors.activityColor, fontSize: 12),
                ),
              ],
            ),
          ),
          Spacer(),
          // Notification icon
          IconButton(
            icon: const Image(
              image: AssetImage("assets/images/notification.png"),
              height: 32,
              width: 32,
            ),
            onPressed: () => Get.to(NotificationAlertScreen()),

          ),
        ],
      ),
    );
  }
}
