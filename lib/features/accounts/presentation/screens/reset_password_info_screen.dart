import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/custom_text_box.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/highlighted_text.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/custom_appbar.dart';

import '../../controller/box_controller.dart'; // your controller

class ResetPasswordInfoScreen extends StatelessWidget {
  ResetPasswordInfoScreen({super.key});

  final FAQController controller = Get.put(FAQController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(title: "Reset Password", titleCenter: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          // FAQItem replacing ResetInfoWidget
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: TColors.white1, // put your color here
              borderRadius: BorderRadius.circular(
                5,
              ), // adjust your corner radius
            ),
            child: Column(
              children: [
                FAQItem(
                  question: "How do I reset my password?",
                  description:
                      "If you’ve forgotten your password or want to \nchange it:",
                  bulletPoints: const [
                    "Go to the Login screen.",
                    "Tap 'Forgot Password?'",
                    "Enter your registered phone number or \nemail.",
                    "You’ll receive an OTP (One-Time Password) \nto verify your identity.",
                    "Enter the OTP and set a new password.",
                  ],
                  questionColor: TColors.deliveryDetails,
                  descriptionColor: TColors.deliveryDetails,
                  bulletColor: TColors.deliveryDetails,
                ),

                const SizedBox(height: 24),

                // Highlighted Warning Text
                const HighlightedTextBox(
                  text:
                      "Make sure your new password is at least 6 characters and easy for you to remember, but hard for others to guess",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 80,
                  barHeight: 60,
                  barWidth: 4,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Bottom text with support
          Row(
            children: [
              const Text(
                "Need more help? ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: TColors.deliveryDetails,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Implement navigation to support page
                },
                child: const Text(
                  "Contact Support",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: TColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
