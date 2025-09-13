import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/screens/LogIn_screen.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/screens/sign_up_screen.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/widgets/role_button.dart';
import 'package:flutter_lakshman1020/features/others/presentation/screen/dashboard_overview_scren.dart';
import 'package:get/get.dart';

class SignInRoleScreen extends StatefulWidget {
  const SignInRoleScreen({super.key});

  @override
  State<SignInRoleScreen> createState() => _SignInRoleScreenState();
}

class _SignInRoleScreenState extends State<SignInRoleScreen> {
  String selectedRole = "User"; // Default selection

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Center(
          // 🔑 Centers everything vertically + horizontally
          child: Column(
            // mainAxisSize: MainAxisSize.min, // shrink to fit content
            children: [
              const SizedBox(height: 200),

              /// IMAGE
              Container(
                height: 160,
                width: 240,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/authUser.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// TITLES
              const Text(
                "Log In As",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: TColors.userName,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Select your role to access your \naccount",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: TColors.subtitleName,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),

              /// ROLE BUTTONS
              RoleButton(
                title: "User",
                isSelected: selectedRole == "User",
                isUser: true,
                onTap: () {
                  setState(() => selectedRole = "User");
                  Get.to(() => const LoginRoleScreen());
                },
              ),
              RoleButton(
                title: "Company",
                isSelected: selectedRole == "Company",
                isUser: false,
                onTap: () {
                  Get.to(DashboardScreen());
                },
              ),
              const SizedBox(height: 110),

              /// NEXT BUTTON
              GestureDetector(
                onTap: () {
                  if (selectedRole == "User") {
                    Get.to(() => const SignupScreen());
                  } else {
                    // Navigate to company screen
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: TColors.userButton,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: TColors.userName,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
