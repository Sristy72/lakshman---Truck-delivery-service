import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_bottom_nav.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/banner_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/header_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/recent_shipment_header.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/shipment_filter_tabs.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/shipment_item.dart';
import 'package:flutter_lakshman1020/features/notification/presentation/controllers/messages_controller.dart';
import 'package:flutter_lakshman1020/features/notification/presentation/screens/messages_screen.dart';
// Pages used for bottom navigation
import 'package:flutter_lakshman1020/features/others/presentation/screen/shipment_screen.dart';
import 'package:get/get.dart';

import '../controllers/load_controller.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // LoadController is now registered globally in service locator
    // Fetch loads only if not already loaded (first time or empty)
    final LoadController loadController = Get.find<LoadController>();
    if (loadController.loads.isEmpty) {
      loadController.fetchLoads();
    }
    
    // Ensure AccountController is initialized and fetches profile
    Future.delayed(const Duration(milliseconds: 200), () {
      final accountController = Get.find<AccountController>();
      accountController.fetchProfile();
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
    final LoadController loadController = Get.find<LoadController>();
    final accountController = Get.find<AccountController>();
    
    switch (_currentIndex) {
      case 0: // Home
        loadController.fetchLoads();
        break;
      case 1: // Loads/Shipment
        loadController.fetchLoads();
        break;
      case 2: // Messages
        final messagesController = Get.find<MessagesController>();
        messagesController.fetchConversations();
        break;
      case 3: // Profile
        accountController.fetchProfile();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final LoadController loadController = Get.find<LoadController>();

    // Home content as a page
    final Widget homePage = SafeArea(
      child: RefreshIndicator(
        onRefresh: () => loadController.refreshLoads(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HeaderSection(),
              const SizedBox(height: 20),
              const BannerSection(),
              const SizedBox(height: 20),
              const RecentShipmentHeader(),
              const SizedBox(height: 12),
              const ShipmentFilterTabs(),
              const SizedBox(height: 12),
              // Obx for reactive UI updates
              Obx(() {
                if (loadController.isLoading.value) {
                  return Column(
                    children: List.generate(
                      3,
                      (index) => const SkeletonShipmentCard(),
                    ),
                  );
                }

                if (loadController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            loadController.errorMessage.value,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => loadController.fetchLoads(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (loadController.filteredLoads.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('No shipments found'),
                    ),
                  );
                }

                return Column(
                  children: loadController.filteredLoads.map((load) {
                    return ShipmentItem(load: load);
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );

    final List<Widget> pages = [
      homePage,
      const ShipmentScreen(),
      MessagesScreen(),
      const AccountsScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
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
            label: 'Loads',
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
