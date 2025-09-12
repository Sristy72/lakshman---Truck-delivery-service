import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/constants/texts.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/FAQ_Items.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/highlighted_text.dart';

class SafetyPolicyScreen extends StatelessWidget {
  const SafetyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(title: (appTexts.safetyPolicy)),
      body: ListView(
        children: [
          // Section 1: Customer Misconduct
          FAQItem(
            question: "Customer Misconduct",
            description:
                "If a customer behaves inappropriately or violates our policy:",
            bulletPoints: const [
              "End the trip only if it’s safe to do so.",
              "Go to Help & Support > Report a Customer Issue.",
              "Provide a brief description of what happened (with time and location).",
              "Our team will investigate and take appropriate action.",
            ],
            questionColor: TColors.deliveryDetails,
            descriptionColor: TColors.deliveryDetails,
            bulletColor: TColors.deliveryDetails,
          ),

          const SizedBox(height: 12),

          // Highlighted Warning Box
          const HighlightedTextBox(
            text:
                "All reports are confidential and taken seriously. Your safety is our priority.",
            fontSize: 13,
            fontWeight: FontWeight.w400,
            barHeight: 40,
            height: 60,
          ),

          const SizedBox(height: 32),

          // Section 2: Accident or Damage Reporting
          FAQItem(
            question: "Accident or Damage Reporting",
            description:
                "If an accident or vehicle damage occurs during a trip:",
            bulletPoints: const [
              "Ensure everyone is safe and call emergency services if necessary.",
              "Report the incident in the app under Help & Support.",
              "Upload photos and details of the damage.",
              "Our team will assist with insurance and claim procedures.",
            ],
            questionColor: TColors.deliveryDetails,
            descriptionColor: TColors.deliveryDetails,
            bulletColor: TColors.deliveryDetails,
          ),

          const SizedBox(height: 32),

          // Section 3: Emergency Contact
          FAQItem(
            question: "Emergency Contact",
            description:
                "In case of any emergency during a trip, follow these steps:",
            bulletPoints: const [
              "Call 999 or the local emergency hotline immediately.",
              "Use the in-app Emergency button to notify support.",
              "Provide your live location to authorities and support team.",
            ],
            questionColor: TColors.deliveryDetails,
            descriptionColor: TColors.deliveryDetails,
            bulletColor: TColors.deliveryDetails,
          ),
        ],
      ),
    );
  }
}
