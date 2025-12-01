import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:flutter_lakshman1020/features/home/controller/driver_home_controller.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/driver_home_widgets/current_load_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/driver_home_widgets/header_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/driver_home_widgets/status_card.dart';
import 'package:flutter_lakshman1020/features/notification/presentation/screens/messages_screen.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/custom_bottom_nav.dart';
import '../../../driver_activity/presentation/widgets/activity_body.dart';
import '../bindings/load_binding.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize LoadBinding for LoadRepository and LoadController
    LoadBinding().dependencies();
    
    // Ensure AccountController is initialized and fetches profile
    Future.delayed(const Duration(milliseconds: 200), () {
      final accountController = Get.find<AccountController>();
      accountController.fetchProfile();
      
      // Fetch driver's current load
      final driverHomeController = Get.find<DriverHomeController>();
      driverHomeController.refreshLoads();
    });
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh data when app comes to foreground
    if (state == AppLifecycleState.resumed) {
      _refreshCurrentPage();
    }
  }
  
  void _refreshCurrentPage() {
    final accountController = Get.find<AccountController>();
    final driverHomeController = Get.find<DriverHomeController>();
    
    switch (_currentIndex) {
      case 0: // Home
        accountController.fetchProfile();
        driverHomeController.refreshLoads();
        break;
      case 1: // Activity
        // Activity screen has its own controller that handles data
        break;
      case 2: // Messages
        // Messages screen has its own controller that auto-fetches on init
        break;
      case 3: // Profile
        accountController.fetchProfile();
        break;
    }
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
          // Refresh data when switching to a different tab
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
            _refreshCurrentPage();
          }
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
