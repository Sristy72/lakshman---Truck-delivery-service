import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import 'package:get/get.dart';

import '../../features/auth/users/presentation/controller/auth_controller.dart';


void setupController() {
  // Auth Controller
  Get.lazyPut<AuthController>(() => AuthController(Get.find(), Get.find()), fenix: true);
  Get.lazyPut<AccountController>(() => AccountController(Get.find()), fenix: true);
  

}
