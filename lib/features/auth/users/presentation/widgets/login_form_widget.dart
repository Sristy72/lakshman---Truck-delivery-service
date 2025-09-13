// import 'package:flutter/material.dart';
// import 'package:flutter_lakshman1020/core/constants/Login_text_field.dart';

// import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
// import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';

// class LoginForm extends StatefulWidget {
//   const LoginForm({super.key});

//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscureText = true;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Email field
//         CustomLogInTextField(
//           controller: _emailController,
//           hintText: "example@gmail.com",
//           prefixIcon: const Icon(Icons.email_outlined),
//         ),

//         const SizedBox(height: 15),

//         // Password field
//         CustomLogInTextField(
//           controller: _passwordController,
//           hintText: "••••••••",
//           obscureText: _obscureText,
//           prefixIcon: const Icon(Icons.lock_outline),
//         ),

//         const SizedBox(height: 10),

//         // Forgot password
//         Align(
//           alignment: Alignment.centerRight,
//           child: GestureDetector(
//             onTap: () {
//               // Navigate to forgot password
//             },
//             child: const Text(
//               "Forgot password?",
//               style: TextStyle(color: Colors.blue),
//             ),
//           ),
//         ),

//         const SizedBox(height: 20),

//         context.primaryButton(
//           text: "Login",
//           width: double.infinity,
//           height: 51,
//           backgroundColor: TColors.primary,
//           textColor: TColors.account,
//           borderRadius: 8.0,
//           onPressed: () {},
//         ),

//         // Login button
//         // SizedBox(
//         //   width: double.infinity,
//         //   height: 48,
//         //   child: ElevatedButton(
//         //     style: ElevatedButton.styleFrom(
//         //       backgroundColor: Colors.blue,
//         //       shape: RoundedRectangleBorder(
//         //         borderRadius: BorderRadius.circular(8),
//         //       ),
//         //     ),
//         //     onPressed: () {
//         //       // Handle login
//         //       debugPrint("Email: ${_emailController.text}");
//         //       debugPrint("Password: ${_passwordController.text}");
//         //     },
//         //     child: const Text(
//         //       "Login",
//         //       style: TextStyle(fontSize: 16, color: Colors.white),
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/Login_text_field.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:get/get.dart';

import '../../../../home/presentations/screens/user_home_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

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
            onTap: () {},
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
            debugPrint("Email: ${_emailController.text}");
            debugPrint("Password: ${_passwordController.text}");
            Get.to(UserHomeScreen());
          },
        ),
      ],
    );
  }
}
