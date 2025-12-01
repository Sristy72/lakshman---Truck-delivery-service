import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/company_subscription_plans/presentation/screens/subscription_screen.dart';
import 'package:flutter_lakshman1020/features/dispatcher_company_page/presentation/screens/company_dispatcher_screen.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/presentation/screens/company_driver_screen.dart';
import 'package:flutter_lakshman1020/features/notification/presentation/screens/messages_screen.dart';
import 'package:flutter_lakshman1020/features/others/presentation/screen/running_load_screen.dart';
import 'package:get/get.dart';

import '../../../accounts/controller/account_controller.dart';
import '../../../auth/users/presentation/controller/auth_controller.dart';
import '../screen/company_pending_req_screen.dart';
import '../screen/company_setting_screen.dart';
import '../screen/dashboard_overview_scren.dart';

class CompanyDrawer extends StatelessWidget {
  const CompanyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(color: TColors.white),
            child: Obx(() {
              try {
                final accountController = Get.find<AccountController>();
                final companyName = accountController.userInfo.value?.name ?? 'Company';
                final companyLogo = accountController.userInfo.value?.avatar.url ?? '';
                
                return Row(
                  children: [
                    // Company Logo
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: companyLogo.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                companyLogo,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.business,
                                      color: TColors.primary,
                                      size: 28,
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.business,
                                color: TColors.primary,
                                size: 28,
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            companyName,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Company',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } catch (e) {
                // Fallback if AccountController not available
                return Row(
                  children: [
                    Icon(Icons.business, color: TColors.primary, size: 50),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        "Company",
                        style: TextStyle(fontWeight: FontWeight.w900),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
          // Scrollable menu items
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDrawerItem(
                    context,
                    icon: "assets/images/dashboard_icon.png",
                    title: "Dashboard",
                    onTap: () {
                      Get.to(
                        () => const DashboardScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  SizedBox(height: isMobile ? 4 : 6),
                  _buildDrawerItem(
                    context,
                    icon: "assets/images/running_load_icon.png",
                    title: "Running load",
                    onTap: () {
                      Get.to(
                        () => const RunningLoadScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  SizedBox(height: isMobile ? 4 : 6),
                  _buildDrawerItem(
                    context,
                    icon: "assets/images/running_load_icon.png",
                    title: "Pneding Request",
                    onTap: () {
                      Get.to(
                        () => const CompanyPendingReqScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  SizedBox(height: isMobile ? 4 : 6),
                  _buildDrawerItem(
                    context,
                    icon: "assets/images/driver_icon.png",
                    title: "Driver",
                    onTap: () {
                      Get.to(
                        () => const CompanyDriverScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  SizedBox(height: isMobile ? 4 : 6),
                  _buildDrawerItem(
                    context,
                    icon: "assets/images/dispatcher_icon.png",
                    title: "Dispatcher",
                    onTap: () {
                      Get.to(
                        () => const CompanyDispatcherScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  SizedBox(height: isMobile ? 4 : 6),
                  _buildDrawerItem(
                    context,
                    icon: "assets/images/message_icon.png",
                    title: "Message",
                    onTap: () {
                      Get.to(
                        () => MessagesScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  SizedBox(height: isMobile ? 4 : 6),
                  _buildDrawerItem(
                    context,
                    icon: "assets/images/subscription_icon.png",
                    title: "Subscription",
                    onTap: () {
                      Get.to(
                        () => const SubscriptionScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  SizedBox(height: isMobile ? 4 : 6),
                  _buildDrawerItem(
                    context,
                    icon: "assets/images/dispatcher_icon.png",
                    title: "Settings",
                    onTap: () {
                      Get.to(
                        () => CompanySettingScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Fixed logout button at bottom
          _buildDrawerItem(
            context,
            icon: "assets/images/logout_icon.png",
            title: "Log out",
            backgroundColor: const Color(0xFFF2E9E8),
            onTap: () {
              // Properly logout and clear all data
              Get.find<AuthController>().logout();
            },
            isLogout: true,
          ),
          SizedBox(height: isMobile ? 8 : 12),
        ],
      ),
    );
  }

  /// Helper method to build drawer menu items with responsive sizing
  Widget _buildDrawerItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
    Color backgroundColor = Colors.transparent,
    bool isLogout = false,
  }) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final iconSize = isMobile ? 16.0 : 18.0;
    final fontSize = isMobile ? 13.0 : 14.0;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 0),
      decoration: isLogout
          ? BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: 4,
        ),
        leading: Image(
          image: AssetImage(icon),
          height: iconSize,
          width: iconSize,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: TColors.grey,
            fontSize: fontSize,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
      ),
    );
  }
}
