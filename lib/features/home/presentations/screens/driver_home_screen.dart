import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/driver_home_widgets/current_load_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/driver_home_widgets/header_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/driver_home_widgets/status_card.dart';
import 'package:get/get.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure AccountController is initialized and fetches profile
    final accountController = Get.find<AccountController>();
    if (accountController.userInfo.value == null) {
      accountController.fetchProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: TColors.primary),
      backgroundColor: TColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top blue header section
            Container(
              color: TColors.primary,
              child: Column(children: [HeaderSection(), StatusCard()]),
            ),
            // Remaining content scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [SizedBox(height: 20), CurrentLoadSection()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
