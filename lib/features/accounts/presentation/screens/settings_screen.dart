import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/constants/app_images.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/about_us_screen.dart';
import 'package:get/get.dart';

import '../../../../core/constants/appTexts.dart';
import 'Reset_PassWord_Screen.dart';
import 'notification_screen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  // 🔹 Using RxBool instead of StatefulWidget
  final RxBool phoneCallEnabled = true.obs;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        title: appTexts.setting,
        titleCenter: true,
        onBack: Get.back,
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                Text(
                  appTexts.accountSettong,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: TColors.activityColor,
                  ),
                ),

                /// Navigate using GetX
                _buildListTile(AppImages.resetPassIcon, "Reset password", () {
                  Get.to(() => const ResetPasswordScreen());
                }),
                Divider(color: TColors.grey2.withValues(alpha: 0.4)),

                _buildListTile(AppImages.notification, "Notification", () {
                  Get.to(() => NotificationSettingsScreen());
                }),
                Divider(color: TColors.grey2.withValues(alpha: 0.4)),

                _buildListTile(AppImages.about_us, "About us", () {
                  Get.to(() => const AboutUsScreen());
                }),
                Divider(color: TColors.grey2.withValues(alpha: 0.4)),

                const SizedBox(height: 24),
                Text(
                  appTexts.moreOption,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: TColors.activityColor,
                  ),
                ),

                _buildSwitchTile(AppImages.callIcon, "Phone calls"),
                Divider(color: TColors.grey2.withValues(alpha: 0.4)),

                _buildListTile(AppImages.languageIcon, "Language", () {}),
                Divider(color: TColors.grey2.withValues(alpha: 0.4)),

                _buildListTile(AppImages.currencyIcon, "Currency", () {}),
                Divider(color: TColors.grey2.withValues(alpha: 0.4)),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String imagePath, String title, VoidCallback onTap) {
    return ListTile(
      leading: _buildLogo(
        child: Image.asset(imagePath, width: 20, height: 20),
        bgColor: TColors.white1,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_down,
        size: 30,
        color: TColors.activityColor,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(String imagePath, String title) {
    return Obx(
      () => ListTile(
        leading: _buildLogo(
          child: Image.asset(imagePath, width: 20, height: 20),
          bgColor: TColors.white1,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        trailing: Transform.scale(
          scale: .6,
          child: Switch(
            value: phoneCallEnabled.value,
            onChanged: (value) {
              phoneCallEnabled.value = value;
            },
            activeThumbColor: TColors.enableButton.withValues(alpha: 1),
            activeTrackColor: TColors.personalBackground,
            inactiveThumbColor: TColors.enableButton,
          ),
        ),
      ),
    );
  }

  Widget _buildLogo({required Widget child, required Color bgColor}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(child: child),
    );
  }
}
