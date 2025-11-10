import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_bottom_nav.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:flutter_lakshman1020/features/dispatcher/presentation/screens/dispatcher_navigate_screen.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/dispatcher_home_widgets/header_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/dispatcher_home_widgets/recent_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/dispatcher_home_widgets/stats_section.dart';
import 'package:flutter_lakshman1020/features/notification/presentation/screens/messages_screen.dart';
import 'package:get/get.dart';

class DispatcherHomeScreen extends StatefulWidget {
  const DispatcherHomeScreen({super.key});

  @override
  State<DispatcherHomeScreen> createState() => _DispatcherHomeScreenState();
}

class _DispatcherHomeScreenState extends State<DispatcherHomeScreen> {
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

  Widget _buildHomePage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HeaderSection(),
            SizedBox(height: 20),
            StatsSection(),
            SizedBox(height: 24),
            RecentSection(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomePage(),
      const DispatcherNavigateScreen(),
      MessagesScreen(),
      AccountsScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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
