import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/screens/LogIn_screen.dart';
import 'package:flutter_lakshman1020/features/company_subscription_plans/presentation/screens/subscription_screen.dart';
import 'package:flutter_lakshman1020/features/dispatcher_company_page/presentation/screens/company_dispatcher_screen.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/presentation/screens/company_driver_screen.dart';
import 'package:flutter_lakshman1020/features/others/presentation/screen/pending_req_screen.dart';
import 'package:flutter_lakshman1020/features/others/presentation/screen/running_load_screen.dart';
import 'package:get/get.dart';

import '../screen/company_setting_screen.dart';
import '../screen/dashboard_overview_scren.dart';

class CompanyDrawer extends StatelessWidget {
  const CompanyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: TColors.white),
            child: Row(
              children: [
                Image(image: AssetImage("assets/images/spark_icon.png")),
                const SizedBox(width: 4),
                Text(
                  "Spark Delivery",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image(
              height: 18,
              width: 18,
              image: AssetImage("assets/images/dashboard_icon.png"),
            ),
            title: Text("Dashboard", style: TextStyle(color: TColors.grey)),
            onTap: () {
              Get.to(
                () => const DashboardScreen(),
                transition: Transition.rightToLeft,
              );
            },
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Image(
              height: 18,
              width: 18,
              image: AssetImage("assets/images/running_load_icon.png"),
            ),
            title: Text("Running load", style: TextStyle(color: TColors.grey)),
            onTap: () {
              Get.to(
                () => const RunningLoadScreen(),
                transition: Transition.rightToLeft,
              );
            },
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Image(
              height: 18,
              width: 18,
              image: AssetImage("assets/images/running_load_icon.png"),
            ),
            title: Text(
              "Pneding Request",
              style: TextStyle(color: TColors.grey),
            ),
            onTap: () {
              Get.to(
                () => const PendingReqScreen(),
                transition: Transition.rightToLeft,
              );
            },
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Image(
              image: AssetImage("assets/images/driver_icon.png"),
              height: 18,
              width: 18,
            ),
            title: Text("Driver", style: TextStyle(color: TColors.grey)),
            onTap: () {
              Get.to(
                () => const CompanyDriverScreen(),
                transition: Transition.rightToLeft,
              );
            },
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Image(
              image: AssetImage("assets/images/dispatcher_icon.png"),
              height: 18,
              width: 18,
            ),
            title: Text("Dispatcher", style: TextStyle(color: TColors.grey)),
            onTap: () {
              Get.to(
                () => const CompanyDispatcherScreen(),
                transition: Transition.rightToLeft,
              );
            },
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Image(
              image: AssetImage("assets/images/message_icon.png"),
              height: 18,
              width: 18,
            ),
            title: Text("Message", style: TextStyle(color: TColors.grey)),
            onTap: () {},
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Image(
              image: AssetImage("assets/images/subscription_icon.png"),
              height: 18,
              width: 18,
            ),
            title: Text("Subscription", style: TextStyle(color: TColors.grey)),
            onTap: () {
              Get.to(
                () => const SubscriptionScreen(),
                transition: Transition.rightToLeft,
              );
            },
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Image(
              image: AssetImage("assets/images/dispatcher_icon.png"),
              height: 18,
              width: 18,
            ),
            title: Text("Settings", style: TextStyle(color: TColors.grey)),
            onTap: () {
              Get.to(
                () => CompanySettingScreen(),
                transition: Transition.rightToLeft,
              );
            },
          ),
          Spacer(),

          ListTile(
            tileColor: Color(0xFFF2E9E8),
            leading: Image(
              image: AssetImage("assets/images/logout_icon.png"),
              height: 24,
              width: 24,
            ),
            title: Text("Log out", style: TextStyle(color: TColors.grey)),
            onTap: () {
              Get.offAll(LoginRoleScreen());
            },
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
