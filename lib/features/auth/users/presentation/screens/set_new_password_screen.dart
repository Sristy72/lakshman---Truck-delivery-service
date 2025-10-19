import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/controller/auth_controller.dart';

class SetNewPasswordScreen extends StatelessWidget {
  final String email;
  final String otp;

  SetNewPasswordScreen({super.key, required this.email, required this.otp});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authController = Get.find<AuthController>();

  // Separate reactive toggles for each field
  final _obscurePassword = true.obs;
  final _obscureConfirm = true.obs;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _authController.setNewPass(email, otp, _passwordController.text);
  }

  InputDecoration _inputDecoration(String label, RxBool isObscure) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: label,
      hintStyle: const TextStyle(color: Colors.grey),
      suffixIcon: IconButton(
        icon: Icon(
          isObscure.value ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey.shade600,
        ),
        onPressed: () => isObscure.value = !isObscure.value,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.green, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Set New Password"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              RichText(
                text: const TextSpan(
                  text: 'New Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Obx(
                () => TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword.value,
                  decoration: _inputDecoration("", _obscurePassword),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Enter password";
                    }
                    if (val.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              RichText(
                text: const TextSpan(
                  text: 'Confirm Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Obx(
                () => TextFormField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm.value,
                  decoration: _inputDecoration("", _obscureConfirm),
                  validator: (val) {
                    if (val != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 40),

              Obx(
                () => context.primaryButton(
                  text: "Set Password",
                  isLoading: _authController.isLoading.value,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
