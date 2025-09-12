import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/notification_widget.dart';
import 'package:get/get.dart';

import '../../../../core/constants/appTexts.dart';
import '../../model/notification_setting_model.dart';

class NotificationSettingsScreen extends StatelessWidget {
  NotificationSettingsScreen({Key? key}) : super(key: key);

  // 🔹 Use RxList for reactive updates
  final RxList<NotificationSettingModel> titles = <NotificationSettingModel>[
    NotificationSettingModel(
      title: "Job Alerts",
      subtitle:
      "Get notified when new delivery requests are \n available near you.",
      isEnabled: true,
    ),
    NotificationSettingModel(
      title: "Payment Updates",
      subtitle: "Receive alerts about trip earnings, payouts, \n and bonuses.",
      isEnabled: true,
    ),
    NotificationSettingModel(
      title: "Promotions & Announcements",
      subtitle:
      "Be the first to know about new features, \n offers, and driver incentives.",
      isEnabled: true,
    ),
    NotificationSettingModel(
      title: "App Alerts & Warnings",
      subtitle:
      "Important app updates, route issues, or \n account notifications.",
      isEnabled: false,
    ),
  ].obs;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        onBack: Get.back,
        title: appTexts.notification,
        titleCenter: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 48),
          const Text(
            "Control how and when you receive \n alerts about deliveries, payments, \n and updates.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: TColors.deliveryDetails,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 48),

          // 🔹 Build switches reactively
          Obx(
                () => Column(
              children: titles.asMap().entries.map((entry) {
                final index = entry.key;
                final setting = entry.value;

                return NotificationWidget(
                  title: setting.title,
                  subtitle: setting.subtitle,
                  value: setting.isEnabled,
                  onChanged: (val) {
                    titles[index] =
                        setting.copyWith(isEnabled: val); // update value
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
