import 'package:flutter_lakshman1020/features/accounts/data/repo/account_repo_impl.dart';
import 'package:flutter_lakshman1020/features/accounts/domain/repo/account_repo.dart';
import 'package:flutter_lakshman1020/features/company_subscription_plans/data/repo/payment_repo_impl.dart';
import 'package:flutter_lakshman1020/features/company_subscription_plans/data/repo/subscription_repo_impl.dart';
import 'package:flutter_lakshman1020/features/company_subscription_plans/domain/payment_repo.dart';
import 'package:flutter_lakshman1020/features/company_subscription_plans/domain/subscription_repo.dart';
import 'package:flutter_lakshman1020/features/home/domain/repositories/load_repository.dart';
import 'package:flutter_lakshman1020/features/others/data/repo/load_repo_impl.dart';
import 'package:flutter_lakshman1020/features/others/domain/load_repo.dart';
import 'package:get/get.dart';

import '../../features/auth/users/data/repo/auth_repo_impl.dart';
import '../../features/auth/users/domain/repo/auth_repo.dart';


void setupRepository() {
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(apiClient: Get.find()),fenix: true);
  Get.lazyPut<AccountRepository>(() => AccountRepositoryImpl(apiClient: Get.find(),authStorageService: Get.find()), fenix: true);
  Get.lazyPut<SubscriptionRepository>(() => SubscriptionRepositoryImpl(apiClient: Get.find()), fenix: true);
  Get.lazyPut<PaymentRepository>(() => PaymentRepositoryImpl(apiClient: Get.find()), fenix: true);
  Get.lazyPut<AskPriceRepository>(() => LoadRepositoryImpl(apiClient: Get.find()), fenix: true);

  

}
