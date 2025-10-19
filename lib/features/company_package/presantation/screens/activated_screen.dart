import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_icons.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:flutter_lakshman1020/features/company_package/presantation/screens/signup_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../home/models/app_text_styles.dart';

class ActivatedScreen extends StatelessWidget {
  const ActivatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppIcons.subscription,
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 24),


                Text(
                  "Subscription Activated",
                  style: TTextStyles.label.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppIcons.s_mail,
                      height: 21 ,
                      width: 16,
                    ),
                    const SizedBox(width:4),
                    Expanded(
                      child: Text(
                        "Check your Stripe email for your unique code",
                        style: TTextStyles.subtitle.copyWith(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                //Primary Button
                context.primaryButton(
                  text: "Get Started",
                  onPressed: () => Get.to(SignUpCompanyScreen()),
                  height: 48,
                  borderRadius: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
