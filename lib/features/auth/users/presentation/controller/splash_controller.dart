import 'package:flutter_lakshman1020/features/auth/users/presentation/controller/auth_controller.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/screens/LogIn_screen.dart';
import 'package:flutter_lakshman1020/core/network/services/auth_storage_service.dart';
import 'package:flutter_lakshman1020/core/utils/debug_print.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final AuthStorageService _authStorageService = Get.find<AuthStorageService>();

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Small splash delay
    await Future.delayed(const Duration(seconds: 2));

    final refreshToken = await _authStorageService.getRefreshToken();
    final role = await _authStorageService.getRole();

    DPrint.log("💾 Stored refresh token: $refreshToken");
    DPrint.log("💾 Stored role: $role");

    // ✅ If no token found → go to login
    if (refreshToken == null || refreshToken.isEmpty) {
      DPrint.log("❌ No refresh token found. Redirecting to LoginRoleScreen.");
      _goToLogin();
      return;
    }

    // ✅ Token found → auto-login via refresh token API
    DPrint.log("🔄 Refresh token found. Refreshing session...");
    // AuthController.refreshToken() handles navigation and does not return a boolean.
    await _authController.refreshToken();

  }

  void _goToLogin() {
    Get.offAll(() => LoginRoleScreen());
  }
}


// import 'package:flutter_lakshman1020/features/auth/users/presentation/controller/auth_controller.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';


// // import '../screens/home_screen.dart';


// class SplashController extends GetxController {
//   final _authController = Get.find<AuthController>();


//   @override
//   void onInit() {
//     super.onInit();
//     Future.delayed(const Duration(seconds: 2), () async {
//       final success = await _authController.refreshToken();

//       if (success) {
//         Get.offAll(() => HomeScreen()); // clears stack
//       } else {
//         Get.offAll(() => LoginScreen());
//       }
//     });
//   }
// }
