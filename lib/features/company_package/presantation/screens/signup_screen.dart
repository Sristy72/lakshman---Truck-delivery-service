import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/constants/app_icons.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/screens/LogIn_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../core/constants/appTexts.dart';
import '../../../home/models/app_text_styles.dart';

class SignUpCompanyScreen extends StatelessWidget {
  const SignUpCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(appTexts.signUp,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company name
              _buildTextField(
                label: appTexts.companyName,
                hint: appTexts.sparkDelivery,
                required: true,
              ),
              const SizedBox(height: 16),

              // Company mail
              _buildTextField(
                label: appTexts.companyMail,
                hint: "example@gmail.com",
                required: true,
              ),
              const SizedBox(height: 16),

              // Company logo and Unique code
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(appTexts.companyLogo),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {

                          },
                          child: DottedBorder(
                            color: Colors.grey,
                            strokeWidth: 1,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(20),
                            dashPattern: const [6, 4],
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(AppIcons.link,
                                      width: 18, height: 18),
                                  const SizedBox(width: 6),
                                  const Text(
                                    "Choose a file",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: _buildTextField(
                      label: appTexts.uniqueCode,
                      hint: "567a56b",
                      required: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Password
              _buildTextField(
                label: appTexts.password,
                hint: "••••••••",
                required: true,
                obscure: true,
              ),
              const SizedBox(height: 16),

              // Confirm Password
              _buildTextField(
                label: appTexts.confirmPassword,
                hint: "••••••••",
                obscure: true,
              ),
              const SizedBox(height: 12),

              // Remember me
              Row(
                children: [
                  Checkbox(value: false, onChanged: (_) {}),
                  const Text("Remember me"),
                ],
              ),
              const SizedBox(height: 12),

              // Info
              const Text(
                "Please make sure to fill in all required (*) fields accurately",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              const SizedBox(height: 24),

              // Sign up button
              context.primaryButton(
                text: appTexts.signUp,
                onPressed: () {
                  Get.to(LoginRoleScreen());
                },
              ),
              const SizedBox(height: 16),

              // Already account
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TTextStyles.subtitle,
                    children: [
                      const TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "Sign in",
                        style: const TextStyle(
                          color: TColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {

                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable TextField
  Widget _buildTextField({
    required String label,
    required String hint,
    bool required = false,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label, required: required),
          const SizedBox(height: 6),
          TextField(
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Color(0xFFDCE4F5),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Color(0xFFDCE4F5),
                  width: 1,
                ),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

// Label with required mark
  Widget _buildLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        if (required)
          const Text(
            "*",
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
