import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/network/services/auth_storage_service.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_bottom_nav.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:flutter_lakshman1020/features/dispatcher/presentation/screens/dispatcher_navigate_screen.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/dispatcher_home_widgets/header_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/dispatcher_home_widgets/recent_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/dispatcher_home_widgets/stats_section.dart';
import 'package:flutter_lakshman1020/features/notification/presentation/screens/messages_screen.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../bindings/load_binding.dart';
import '../controllers/load_controller.dart';

class DispatcherHomeScreen extends StatefulWidget {
  const DispatcherHomeScreen({super.key});

  @override
  State<DispatcherHomeScreen> createState() => _DispatcherHomeScreenState();
}

class _DispatcherHomeScreenState extends State<DispatcherHomeScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  final AuthStorageService _authStorageService = Get.find<AuthStorageService>();
  int _navigateScreenRefreshKey = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (!Get.isRegistered<LoadController>()) {
      LoadBinding().dependencies();
    }
    
    // Fetch profile and company-specific loads
    Future.delayed(const Duration(milliseconds: 200), () async {
      final accountController = Get.find<AccountController>();
      accountController.fetchProfile();
      
      // Fetch company-specific loads for dispatcher
      await _fetchDispatcherLoads();
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
  
  void _refreshCurrentPage() async {
    final accountController = Get.find<AccountController>();
    
    switch (_currentIndex) {
      case 0: // Home
        accountController.fetchProfile();
        await _fetchDispatcherLoads();
        break;
      case 1: // Activity/Navigate
        await _fetchDispatcherLoads();
        // Force rebuild of DispatcherNavigateScreen by incrementing key
        setState(() => _navigateScreenRefreshKey++);
        break;
      case 2: // Messages
        // Messages screen has its own controller that auto-fetches on init
        break;
      case 3: // Profile
        accountController.fetchProfile();
        break;
    }
  }

  Future<void> _fetchDispatcherLoads() async {
    try {
      final loadController = Get.find<LoadController>();
      final companyId = await _authStorageService.getCompanyId();
      
      DPrint.log('========== DISPATCHER HOME SCREEN ==========');
      DPrint.log('📦 Company ID: ${companyId ?? "null"}');
      
      if (companyId != null && companyId.isNotEmpty) {
        DPrint.log('🔄 Fetching loads for dispatcher company...');
        await loadController.fetchLoadsByCompany(companyId);
        DPrint.log('✅ Dispatcher loads fetched successfully');
      } else {
        DPrint.log('⚠️ No company ID, fetching all loads...');
        await loadController.fetchLoads();
      }
      DPrint.log('============================================');
    } catch (e) {
      DPrint.error('❌ Error fetching dispatcher loads: $e');
    }
  }

  Widget _buildHomePage() {
    final accountController = Get.find<AccountController>();
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderSection(),
            const SizedBox(height: 20),
            // Observe userInfo for dashboard data
            Obx(() {
              final dashboard = accountController.userInfo.value?.dashboard;
              
              // Show loading or default values while data is being fetched
              if (dashboard == null) {
                return const StatsSection(
                  pendingRequests: 0,
                  readyToLoad: 0,
                  availableDrivers: 0,
                );
              }
              
              // Show real data from API
              return StatsSection(
                pendingRequests: dashboard.pendingRequests,
                readyToLoad: dashboard.readyToLoad,
                availableDrivers: dashboard.availableDrivers,
              );
            }),
            const SizedBox(height: 24),
            const RecentSection(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomePage(),
      DispatcherNavigateScreen(key: ValueKey(_navigateScreenRefreshKey)),
      MessagesScreen(),
      AccountsScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Refresh data when switching to a different tab
          if (index != _currentIndex) {
            setState(() => _currentIndex = index);
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
