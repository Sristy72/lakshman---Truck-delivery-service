import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/Login_text_field.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/screens/forgot_email_screen.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  bool _obscureText = true;


  void _submit() {
    // if (!_formKey.currentState!.validate()) return;
    authController.login(_emailController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email
        CustomLogInTextField(
          controller: _emailController,
          hintText: "example@gmail.com",
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined),
        ),
        const SizedBox(height: 15),

        // Password
        CustomLogInTextField(
          controller: _passwordController,
          hintText: "••••••••",
          obscureText: _obscureText,
          keyboardType: TextInputType.visiblePassword,
          prefixIcon: GestureDetector(
            onTap: () => setState(() => _obscureText = !_obscureText),
            child: Icon(
              _obscureText ? Icons.lock : Icons.visibility,
              color: TColors.grey2,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Forgot password
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Get.to(()=>EmailVerifyScreen());
            },
            child: const Text(
              "Forgot password?",
              style: TextStyle(color: TColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Login button with loading indicator
        Obx(() {
          final isLoading = authController.isLoading.value;
          return SizedBox(
            width: double.infinity,
            height: 51,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0,
              ),
              onPressed: isLoading ? null : () {
                _submit();
                debugPrint("Email: ${_emailController.text}");
                debugPrint("Password: ${_passwordController.text}");
              },
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      "Login",
                      style: TextStyle(
                        color: TColors.account,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          );
        }),
      ],
    );
  }
}
