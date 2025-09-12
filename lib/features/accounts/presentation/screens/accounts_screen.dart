import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_images.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_text.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/help_screen.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/personal_details_screen.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/settings_screen.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/customCurvedEdges.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(backgroundColor: TColors.primary),
      body: SafeArea(
        child: Stack(
          children: [
            ClipPath(
              clipper: CustomCurvedEdges(),
              child: Container(
                decoration: BoxDecoration(color: TColors.primary),
                height: 428,
                width: double.infinity,
              ),
            ),

            SingleChildScrollView(
              child: Column(
                children: [
                  CustomText(
                    'Account',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: TColors.account,
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Image.asset(Images.accountUser),
                    ),
                  ),
              
                  SizedBox(height: 16),
                  CustomText(
                    'Daniel Gabrel',
                    style: TextStyle(
                      color: TColors.account,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomText(
                    '@daniel001',
                    style: TextStyle(
                      color: TColors.white1,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              
                  SizedBox(height: 32),
              
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: TColors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildMenuItem(Images.personal, 'Personal', () {
                              Get.to(PersonalDetailsScreen());
                            }),
              
                            Divider(color: TColors.grey2.withOpacity(.4)),
                            _buildMenuItem(
                              Images.paymentMethod,
                              'Payment Method', () {Get.to('page');}
                            ),
              
                            Divider(color: TColors.grey2.withOpacity(.4)),
                            _buildMenuItem(Images.settings, 'Settings', (){Get.to(SettingsScreen());}),
              
                            Divider(color: TColors.grey2.withOpacity(.4)),
                            _buildMenuItem(Images.heloCenter, 'Help Center', (){Get.to(HelpScreen());}),
              
                            Divider(color: TColors.grey2.withOpacity(.4)),
                            _buildMenuItem(Images.logout, 'Logout', (){Get.to(PersonalDetailsScreen());}),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    String image,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    if (title == 'Logout') {
      return Container(
        decoration: BoxDecoration(
          color: TColors.redLogout,
          borderRadius: BorderRadius.circular(4),
        ),
        child: ListTile(
          leading: SizedBox(height: 20, width: 20, child: Image.asset(image)),
          title: Text(
            title,
            style: TextStyle(
              color: color ?? TColors.activityColor,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: ListTile(
        leading: Container(height: 20, width: 20, child: Image.asset(image)),
        title: Text(
          title,
          style: TextStyle(
            color: color ?? TColors.activityColor,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        tileColor: TColors.redLogout,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
