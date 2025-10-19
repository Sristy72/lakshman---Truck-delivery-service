import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/appTexts.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/constants/custom_text_field.dart';
import 'package:flutter_lakshman1020/core/constants/signup_text_field.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class SignupForm extends StatefulWidget {
  final String role;
  final VoidCallback onSignup;
  final VoidCallback onSignin;

  const SignupForm({super.key, required this.onSignup, required this.onSignin, required this.role});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

      final AuthController authController = Get.find<AuthController>();

  bool rememberMe = false;
  void _submit() {
    // if (!_formKey.currentState!.validate()) return;
    authController.register(nameController.text, emailController.text, passwordController.text, confirmPasswordController.text, widget.role );

    
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                appTexts.Name,
                style: TextStyle(
                  fontSize: 14,
                  color: TColors.titleColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
              const Text(
                " *",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// NAME
          SignUpTextField(
            controller: nameController,

            // label: "",
            hintText: "Spark Delivery",
            keyboardType: TextInputType.name,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Text(
                appTexts.Email,
                style: TextStyle(
                  fontSize: 14,
                  color: TColors.titleColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
              const Text(
                " *",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),

          // const Text(
          //   appTexts.Email,
          //   style: TextStyle(
          //     fontSize: 14,
          //     color: TColors.titleColor,
          //     fontWeight: FontWeight.w500,
          //   ),
          //   textAlign: TextAlign.start,
          // ),
          const SizedBox(height: 8),

          SignUpTextField(
            controller: emailController,

            // label: "",
            hintText: "example@gmail.com",
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              const Text(
                appTexts.password,
                style: TextStyle(
                  fontSize: 14,
                  color: TColors.titleColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
              const Text(
                " *",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),

          const SizedBox(height: 8),

          SignUpTextField(
            controller: passwordController,

            hintText: "••••••••",
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),

          const SizedBox(height: 16),

          const Text(
            appTexts.confirmPassword,
            style: TextStyle(
              fontSize: 14,
              color: TColors.titleColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 8),
          SignUpTextField(
            controller: confirmPasswordController,

            hintText: "••••••••",
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),

          const SizedBox(height: 16),

          /// REMEMBER ME
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: (val) {
                  setState(() {
                    rememberMe = val ?? false;
                  });
                },
                // fillColor: MaterialStateProperty.all(TColors.subtitleColor),
                checkColor: TColors.subtitleColor, // check mark color
              ),
              const Text(
                "Remember me",
                style: TextStyle(
                  fontSize: 12,
                  color: TColors.subtitleColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 12,
                color: TColors.titleColor,
                fontWeight: FontWeight.w400,
              ),
              children: [
                const TextSpan(
                  text: "Please make sure to fill in all required (",
                ),
                const TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Colors.red, // only the asterisk is red
                  ),
                ),
                const TextSpan(text: ") fields \naccurately"),
              ],
            ),
          ),

          /// INFO TEXT
          // const Text(
          //   "Please make sure to fill in all required (*) fields \n accurately",
          //   style: TextStyle(fontSize: 12, color: TColors.titleColor),
          // ),
          const SizedBox(height: 32),

          /// SIGN UP BUTTON
          context.primaryButton(
            text: "Sign up",
            width: double.infinity,
            height: 51,
            backgroundColor: TColors.primary,
            textColor: TColors.account,
            borderRadius: 8.0,
            onPressed: () {
              _submit();
            },
          ),

          const SizedBox(height: 32),

          /// ALREADY HAVE ACCOUNT
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account? "),
              GestureDetector(
                onTap: widget.onSignin,
                child: const Text(
                  "Sign in",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
