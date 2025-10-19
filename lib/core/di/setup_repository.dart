import 'package:flutter_lakshman1020/features/accounts/data/repo/account_repo_impl.dart';
import 'package:flutter_lakshman1020/features/accounts/domain/repo/account_repo.dart';
import 'package:get/get.dart';

import '../../features/auth/users/data/repo/auth_repo_impl.dart';
import '../../features/auth/users/domain/repo/auth_repo.dart';


void setupRepository() {
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(apiClient: Get.find()),fenix: true);
  Get.lazyPut<AccountRepository>(() => AccountRepositoryImpl(apiClient: Get.find()), fenix: true);
  

}
