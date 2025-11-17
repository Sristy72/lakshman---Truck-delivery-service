import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_bottom_nav.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:flutter_lakshman1020/features/chat/presentation/screens/chat_inbox_screen.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/banner_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/header_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/recent_shipment_header.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/shipment_filter_tabs.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/shipment_item.dart';
import 'package:get/get.dart';
import '../../../Location/presentation/screens/location_screen.dart';
import '../../domain/entities/load_entity.dart';
import '../bindings/load_binding.dart';
import '../controllers/load_controller.dart';



class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize bindings if not already initialized
    if (!Get.isRegistered<LoadController>()) {
      LoadBinding().dependencies();
    }
    // Ensure AccountController is initialized and fetches profile
    Future.delayed(const Duration(milliseconds: 200), () {
      final accountController = Get.find<AccountController>();
      accountController.fetchProfile();
    });
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
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
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

// 🔹 NEW: locationPage widget
    final Widget locationPage = Obx(() {
      final loads = loadController.filteredLoads;

      if (loads.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('No shipments to show on map'),
          ),
        );
      }

      LoadEntity? mappable;

      for (final l in loads) {
        bool canParse(String value) {
          final parts = value.split(',');
          if (parts.length != 2) return false;
          return double.tryParse(parts[0].trim()) != null &&
              double.tryParse(parts[1].trim()) != null;
        }

        if (canParse(l.pickupLocation) && canParse(l.deliveryLocation)) {
          mappable = l;
          break;
        }
      }

      if (mappable == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('No shipments with valid coordinates'),
          ),
        );
      }

      return LocationScreen(load: mappable!);
    });


    final List<Widget> pages = [
      homePage,
      locationPage,
       ChatInboxScreen(),
      const AccountsScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            loadController.fetchLoads();
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
