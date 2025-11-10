import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/driver_home_widgets/current_load_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/driver_home_widgets/header_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/driver_home_widgets/status_card.dart';
import 'package:flutter_lakshman1020/features/notification/presentation/screens/messages_screen.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/custom_bottom_nav.dart';
import '../../../driver_activity/presentation/widgets/activity_body.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Ensure AccountController is initialized and fetches profile
    Future.delayed(const Duration(milliseconds: 200), () {
      final accountController = Get.find<AccountController>();
      accountController.fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build driver home page content
    final Widget homePage = Column(
      children: [
        // Top blue header section
        Container(
          color: TColors.primary,
          child: Column(
            children: const [
              SizedBox(height: 50),
              HeaderSection(),
              StatusCard(),
            ],
          ),
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
    );

    final pages = [
      homePage,
      const ActivityBody(),
      MessagesScreen(),
      AccountsScreen(),
    ];

    return Scaffold(
      backgroundColor: TColors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          NavItemData(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Home',
          ),
          NavItemData(
            icon: Icons.local_shipping_outlined,
            selectedIcon: Icons.local_shipping,
            label: 'Activity',
          ),
          NavItemData(
            icon: Icons.mail_outlined,
            selectedIcon: Icons.mail,
            label: 'Message',
          ),
          NavItemData(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
