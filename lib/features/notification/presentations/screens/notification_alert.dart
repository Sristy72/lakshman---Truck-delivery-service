import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_icons.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../features/notification/presentations/widgets/notification_alert_widget.dart';
import '../../../home/models/app_text_styles.dart';
import '../bindings/notification_binding.dart';
import '../controllers/notification_alert_controller.dart';

class NotificationAlertScreen extends StatefulWidget {
  const NotificationAlertScreen({super.key});

  @override
  State<NotificationAlertScreen> createState() => _NotificationAlertScreenState();
}

class _NotificationAlertScreenState extends State<NotificationAlertScreen> {
  late final NotificationAlertController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize bindings if not already initialized
    if (!Get.isRegistered<NotificationAlertController>()) {
      // Initialize notification binding first
      NotificationBinding().dependencies();
      // Then put the alert controller
      Get.put(NotificationAlertController());
    }
    _controller = Get.find<NotificationAlertController>();
  }

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

                Obx(() => Row(
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
                        onPressed: _controller.isLoading.value 
                          ? null 
                          : () => _controller.handleLaterPressed(),
                        child: _controller.isLoading.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _controller.isLoading.value 
                          ? null 
                          : () => _controller.handleGetNotifiedPressed(),
                        child: _controller.isLoading.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Get notified",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


