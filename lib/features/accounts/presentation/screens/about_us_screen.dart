import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(title: 'About us', titleCenter: true, onBack: Get.back,),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 48),
            Container(
              height: 240,
              decoration: BoxDecoration(
                color: TColors.white1,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomText(
                      'We’re on a mission to make shifting and delivery simple, fast, and reliable. Whether it’s medicine, home decor, or heavy furniture — our platform connects customers with trusted truck drivers for safe and on-time transport.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: TColors.grey,
                      ),
                    ),

                    SizedBox(height: 17),

                    CustomText(
                      'With real-time tracking, verified drivers, and easy booking, we’re building a smarter way to move things across the city — safely and stress-free.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: TColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32,),

            Container(
              height: 58,
              child: Row(
                children: [
                  Container(height: 42, width: 4,decoration: BoxDecoration(color: TColors.red, borderRadius: BorderRadius.circular(2))),
                  SizedBox(width: 8,),
                  Expanded(child: CustomText('Driven by technology. Powered by people. Focused on trust.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: TColors.deliveryDetails),))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
