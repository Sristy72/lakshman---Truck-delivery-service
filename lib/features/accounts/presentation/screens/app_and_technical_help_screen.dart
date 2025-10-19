import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/appTexts.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../controller/box_controller.dart';
import '../widgets/FAQ_Items.dart';
import '../widgets/custom_shadow_title.dart';

class AppAndTechnicalHelpScreen extends StatelessWidget {
  AppAndTechnicalHelpScreen({super.key});

  final FAQController controller = Get.put(FAQController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        title: appTexts.appTechnicalHelp,
        titleCenter: true,
        onBack: Get.back,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),

            // ✅ Only one Obx is needed here
            Obx(() {
              if (!controller.isExpanded.value) {
                // 🔹 Show button when collapsed
                return CustomShadowTile(
                  title: 'How do I reset my password?',
                  onPressed: controller.expand,
                );
              }

              // 🔹 Show container when expanded
              return Container(
                height: 330,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TColors.white1,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    FAQItem(
                      question: "App Not Working Properly",
                      description:
                      "If your app is freezing, crashing, or not responding:",
                      bulletPoints: const [
                        "Close and reopen the app.",
                        "Make sure you’re connected to the internet (Wi-Fi or mobile data).",
                        "Update the app from the Play Store or App Store if a new version is available.",
                        'Restart your phone if the issue continues.',
                      ],
                      descriptionColor: TColors.deliveryDetails,
                      onPressed: controller.collapse,
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Container(
                          height: 42,
                          width: 4,
                          decoration: BoxDecoration(
                            color: TColors.red,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'Still facing problems? Tap “',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: TColors.deliveryDetails,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Report a Bug',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: TColors.red,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  '” in the app to contact our tech support.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: TColors.deliveryDetails,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),
            CustomShadowTile(
              title: 'Location or GPS Problems',
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            CustomShadowTile(
              title: 'Notifications Not Showing',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
