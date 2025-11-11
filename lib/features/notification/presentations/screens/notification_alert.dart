import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_icons.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/notification_screen.dart';
import 'package:flutter_lakshman1020/features/home/presentations/screens/user_home_screen.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../home/models/app_text_styles.dart';
import 'notification_empty.dart';
import 'notification_list.dart';
import '../../../../features/notification/presentations/widgets/notification_alert_widget.dart';
class NotificationAlertScreen extends StatelessWidget {
  const NotificationAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    AppImages.notification2,
                    width: 200,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: 300,
                  child: Text(
                    "Get notified about important stuff",
                    style: TTextStyles.title,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  "We will notify you when",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: TColors.white1,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BulletItem(
                          iconPath: AppIcons.getsnewjob,
                          text: "Gets new job"),
                      BulletItem(
                          iconPath: AppIcons.promotion,
                          text: "Promotion announcement"),
                      BulletItem(
                          iconPath: AppIcons.deliverydone,
                          text: "Delivery done"),
                      BulletItem(
                          iconPath: AppIcons.technicalissue,
                          text: "Technical issue"),
                    ],
                  ),
                ),

                const SizedBox(height: 118),



                // Info text
                Text(
                  "You can adjust these settings later",
                  style: TTextStyles.hint,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    //Later button
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: TColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () =>
                            Get.to(const NotificationEmptyScreen()),
                        child: const Text(
                          "Later",
                          style: TextStyle(
                            color: TColors.deliveryDetails,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Get Notified button (primary)
                    Expanded(
                      child: context.primaryButton(
                        text: "Get notified",
                        onPressed: () =>
                            Get.to( NotificationListScreen()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


