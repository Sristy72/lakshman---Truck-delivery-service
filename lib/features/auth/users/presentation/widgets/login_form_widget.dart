import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/Login_text_field.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
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

        // Login button
        context.primaryButton(
          text: "Login",
          width: double.infinity,
          height: 51,
          backgroundColor: TColors.primary,
          textColor: TColors.account,
          borderRadius: 8.0,
          onPressed: () {
            _submit();
            // authController.login(
            //   _emailController.text,
            //   _passwordController.text,
            // );
            debugPrint("Email: ${_emailController.text}");
            debugPrint("Password: ${_passwordController.text}");
          },
        ),
      ],
    );
  }
}
