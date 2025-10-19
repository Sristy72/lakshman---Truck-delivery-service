import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/custom_text_field.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/constants/texts.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AccountController _accountController = Get.find<AccountController>();
  final _formKey = GlobalKey<FormState>();

  void _submit(){
    _accountController.changePassword(_passwordController.text, _confirmPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        title: "Reset Password",
        titleCenter: true,
        onBack: Get.back,
      ),
      body: Column(
        children: [
          const SizedBox(height: 48),
          const Text(
            "Your new password must be different from previous used password.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: TColors.deliveryDetails,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 48),

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  appTexts.password,
                  style: TextStyle(
                    fontSize: 16,
                    color: TColors.deliveryDetails,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
                // Password field
                CustomTextField(
                  label: '',
                  controller: _passwordController,
                  obscureText: true,
                  helperText: "Must be at least 8 characters",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password field
                const Text(
                  appTexts.confirmPassword,
                  style: TextStyle(
                    fontSize: 16,
                    color: TColors.deliveryDetails,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
                CustomTextField(
                  label: '',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  helperText: "Both password must match",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm password cannot be empty';
                    }
                    // if (value != _passwordController.text) {
                    //   return 'Passwords do not match';
                    // }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Save Button
                context.primaryButton(
                  text: "Save",
                  width: double.infinity,
                  height: 51,
                  backgroundColor: TColors.primary,
                  textColor: TColors.account,
                  borderRadius: 8.0,
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                     _submit();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
