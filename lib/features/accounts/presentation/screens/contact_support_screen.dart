import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/contact_support_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ContactSupportWidget(
      title: "Contact support",
      heading: "Need Help?\nWe’re Here for You",
      subText:
          "Get fast support for deliveries, app \n issues, and more — anytime you \n need it.",
      buttonText: "Contact Support",
      onPressed: () {
        // Example: open a support page, send email, or open chat
        Get.snackbar(
          "Support",
          "Support team will contact you soon!",
          backgroundColor: TColors.white1,
          colorText: TColors.deliveryDetails,
        );
      },
    );
  }
}
