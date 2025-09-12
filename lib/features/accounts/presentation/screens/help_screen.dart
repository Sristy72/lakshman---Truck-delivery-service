import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/constants/app_images.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_text.dart';
import 'package:flutter_lakshman1020/features/accounts/model/help_and_support_item.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/support_card.dart';
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SupportItem> supportItems = [
      SupportItem(Images.resetPassword, "How do I reset my password"),
      SupportItem(Images.safetyIcon, "Safety & Policy"),
      SupportItem(Images.deliveryIcon, "Delivery & Job Support"),
      SupportItem(Images.technicalIcon, "App & Technical Help"),
      SupportItem(Images.customerSupport, "Customer support"),
    ];

    return AppScaffold(body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 100),
        Center(child: CustomText('Help & Support',style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: TColors.deliveryDetails),)),

        SizedBox(height: 48,),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: supportItems.length,
              itemBuilder: (context, index) {
                final item = supportItems[index];
                return SupportCard(item: item,);
              },
            ),
          ),
        ),
      ],
    ));
  }
}

