import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import 'package:flutter_lakshman1020/features/notification/presentations/screens/notification_alert.dart';
import 'package:get/get.dart';

class CompanyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CompanyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Obx(() {
        try {
          final accountController = Get.find<AccountController>();
          final companyName = accountController.userInfo.value?.name ?? 'Company';
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage("assets/images/spark_icon.png")),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  companyName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        } catch (e) {
          // Fallback if AccountController not available
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage("assets/images/spark_icon.png")),
              const SizedBox(width: 6),
              const Text(
                "Company",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          );
        }
      }),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              // Handle notification tap
              Get.to(
                () => const NotificationAlertScreen(),
                transition: Transition.rightToLeft,
              );
            },
            child: Image(
              height: 30,
              width: 30,
              image: AssetImage("assets/images/notification_square.png"),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
