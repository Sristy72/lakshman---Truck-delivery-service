import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_lakshman1020/core/base/base_controller.dart';
import 'package:flutter_lakshman1020/core/network/services/auth_storage_service.dart';
import 'package:flutter_lakshman1020/core/utils/debug_print.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/Reset_PassWord_Screen.dart';
import 'package:flutter_lakshman1020/features/auth/users/data/model/forgot_pass_request_model.dart';
import 'package:flutter_lakshman1020/features/auth/users/data/model/refresh_token_request_model.dart';
import 'package:flutter_lakshman1020/features/auth/users/data/model/set_password_request_model.dart';
import 'package:flutter_lakshman1020/features/auth/users/data/model/verify_otp_request-model.dart';
import 'package:flutter_lakshman1020/features/auth/users/domain/repo/auth_repo.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/screens/LogIn_screen.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/screens/Otp_verify_screen.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/screens/SignInRoleScreen.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/screens/set_new_password_screen.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/screens/sign_up_screen.dart';
import 'package:flutter_lakshman1020/features/company_subscription_plans/presentation/screens/subscription_screen.dart';
import 'package:flutter_lakshman1020/features/home/presentations/screens/user_home_screen.dart';
import 'package:flutter_lakshman1020/features/others/presentation/screen/dashboard_overview_scren.dart';
import 'package:get/get.dart';

import '../../data/model/login_request_model.dart';
import '../../data/model/register_request_model.dart';

class AuthController extends BaseController {
  final AuthRepository _authRepository;
  final AuthStorageService _authStorageService;

  // final String selectedRole;
  bool _isSuccess = false;

  AuthController(this._authRepository, this._authStorageService);

  Future<void> login(String email, String password) async {
    setLoading(true);
    setError("");

    final request = LoginRequestModel(email: email, password: password);

    final result = await _authRepository.login(request);

    result.fold(
      (fail) {
        debugPrint("❌ API Error: ${fail.message}");
        setError(fail.message);

        // Show Snackbar on failure
        Get.snackbar(
          "Login Failed",
          fail.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        setLoading(false);
      },
      (success) async {
        String role = success.data.role;

        debugPrint("✅ API Hit Successful!");
        final user = success.data.user;
        if (user.role == 'user' || user.role == 'company') {
          await _authStorageService.storeAuthData(
            accessToken: success.data.accessToken,
            refreshToken: success.data.refreshToken,
            userId: success.data.user.id,
            role: success.data.role,
          );
        }

        // await _authStorageService.storeAuthData(
        //   accessToken: success.data.accessToken,
        //   refreshToken: success.data.refreshToken,
        //   userId: success.data.user.id,
        //   role: success.data.role,
        // );

        // Optional: show success Snackbar
        Get.snackbar(
          "Success",
          "Logged in successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );

        if (user.role == 'user') {
          Get.offAll(() => UserHomeScreen());
        } else if (user.role == 'company') {
          Get.offAll(() => DashboardScreen());
        }

        setLoading(false);

        // if(role == UserRole.user.value) {
        Get.to(() => UserHomeScreen());
        // }
      },
    );
  }

  // Future<void> login(String email, String password) async {
  //   setLoading(true);
  //   setError("");

  //   final request = LoginRequestModel(email: email, password: password);

  //   final result = await _authRepository.login(request);

  //   result.fold(
  //     (fail) {
  //       debugPrint("❌ API Error: ${fail.message}");
  //       setError(fail.message);
  //       setLoading(false);
  //     },
  //     (success) async {
  //       debugPrint("✅ API Hit Successful!");
  //       await _authStorageService.storeAuthData(
  //         accessToken: success.data.accessToken,
  //         refreshToken: success.data.refreshToken,
  //         userId: success.data.user.id,
  //       );
  //       Get.to(() => UserHomeScreen());

  //       setLoading(false);
  //     },
  //   );
  // }

  // Future<void> register(
  //   String name,
  //   String email,
  //   String password,

  //   String confirmPassword,
  //   String role,
  // ) async {
  //   setLoading(true);
  //   setError('');

  //   final request = RegisterRequestModel(
  //     name: name,
  //     email: email,
  //     password: password,
  //     confirmPassword: confirmPassword,
  //     role: role,
  //   );

  //   final result = await _authRepository.register(request);

  //   result.fold(
  //     (fail) {
  //       setError(fail.message);
  //       DPrint.log("Register success result : ${fail.message}");
  //       setLoading(false);
  //     },
  //     (success) {
  //       DPrint.log("Register success result : ${success.data.id}");
  //       // Get.to(OtpVerificationToCompleteRegister(email: email));
  //       // Get.to(() => LoginRoleScreen(selectedRole: selectedRole,));
  //       Get.off(() => LoginRoleScreen());
  //       setLoading(false);
  //     },
  //   );
  // }

  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPassword,
    String role,
  ) async {
    setLoading(true);
    setError('');

    // Local validation first
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all required fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      setLoading(false);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        "Error",
        "Password and Confirm Password do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      setLoading(false);
      return;
    }

    final request = RegisterRequestModel(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      role: role,
    );

    final result = await _authRepository.register(request);

    result.fold(
      (fail) {
        setError(fail.message);

        // Show Snackbar for API error
        Get.snackbar(
          "Error",
          fail.message.contains("email")
              ? "Email already exists"
              : fail.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        DPrint.log("Register failed: ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("Register success: ${success.data.id}");

        Get.snackbar(
          "Success",
          "Account created successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );

        // Navigate to login screen after signup
        Get.off(() => LoginRoleScreen());
        setLoading(false);
      },
    );
  }

  Future forgotPassword(String email) async {
    setLoading(true);
    setError('');

    final request = ForgotPassRequestModel.fromJson({'email': email});
    final result = await _authRepository.forgotPassword(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("reset pass success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("reset pass success result : ${success.data.message}");
        Get.offAll(() => OtpVerificationScreen(email: email));
        setLoading(false);
      },
    );
  }

  Future verifyOTP(String email, String otp) async {
    setLoading(true);
    setError("");

    final request = VerifyMailOtpRequest(email: email, otp: otp);
    final result = await _authRepository.verifyOtp(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("verify otp success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("verify otp success result : ${success.data.message}");
        Get.to(SetNewPasswordScreen(email: email, otp: otp));
        setLoading(false);
      },
    );
  }

  Future setNewPass(String email, String otp, String newPassword) async {
    setLoading(true);
    setError("");

    final request = ResetPasswordRequestModel(
      email: email,
      otp: otp,
      password: newPassword,
    );
    final result = await _authRepository.setNewPassword(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("New Password set failed result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log(
          "New Password set successfully result : ${success.data.message}",
        );
        Get.to(LoginRoleScreen());
        setLoading(false);
      },
    );
  }

  Future refreshToken() async {
    setLoading(true);

    final refreshToken = await _authStorageService.getRefreshToken();
    DPrint.log("🐞 DEBUG: Got refresh token: $refreshToken");

    if (refreshToken == null || refreshToken.isEmpty) {
      DPrint.log("❌ No refresh token stored");
      setLoading(false);
      Get.offAll(() => LoginRoleScreen());
      return;
    }

    final request = RefreshTokenRequestModel(refreshToken: refreshToken);
    final result = await _authRepository.refreshToken(request);

    result.fold(
      (fail) async {
        DPrint.log("❌ Refresh token failed: ${fail.message}");
        await _authStorageService.clearAuthData(); // clear invalid token
        setLoading(false);
        Get.offAll(() => SignInRoleScreen()); // go to login
      },
      (success) async {
        DPrint.log("✅ Refresh token success: ${success.message}");
        await _authStorageService.storeAccessToken(success.data.accessToken);
        await _authStorageService.storeRefreshToken(success.data.refreshToken);
        setLoading(false);

        // Navigate automatically based on role
        final role = await _authStorageService.getRole();
        if (role == "user") {
          Get.offAll(() => UserHomeScreen());
        } else if (role == "company") {
          Get.offAll(() => DashboardScreen());
        } else {
          Get.offAll(() => SignInRoleScreen());
        }
      },
    );
  }

  Future<void> logout() async {
    await _authStorageService.clearAuthData();
    Get.offAll(() => LoginRoleScreen());
  }
}
