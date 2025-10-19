import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/screens/LogIn_screen.dart';

import 'package:flutter_lakshman1020/features/auth/users/presentation/widgets/signup_form_widget.dart';
import 'package:get/get.dart';

import '../../../../home/presentations/screens/user_home_screen.dart';

class SignupScreen extends StatelessWidget {
  final String? selectedRole;
  const SignupScreen({super.key,  this.selectedRole});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => LoginRoleScreen());
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// IMAGE
              Center(
                child: Container(
                  height: 120,
                  width: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/authUser.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// SIGNUP FORM
              // SignupForm(onSignup: () {
              //   Get.to(() => UserHomeScreen());
              // }, onSignin: () {
              //   Get.to(() => LoginRoleScreen());
              // }),
               SignupForm(
                role: selectedRole?? "", // 👈 Pass the selected role here
                onSignup: () {
                  Get.to(() => UserHomeScreen());
                },
                onSignin: () {
                  Get.to(() => LoginRoleScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
