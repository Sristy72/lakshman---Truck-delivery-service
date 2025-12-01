import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/company_remote_datasource.dart';
import '../../data/repositories/company_repository_impl.dart';
import '../../domain/repositories/company_repository.dart';
import '../controllers/company_controller.dart';

class CompanyBinding extends Bindings {
  @override
  void dependencies() {
    // API Client - already registered in setupCore(), so don't re-register it

    // Data source - use fenix: true to recreate if disposed
    Get.lazyPut<CompanyRemoteDataSource>(
      () => CompanyRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // Repository - use fenix: true to recreate if disposed
    Get.lazyPut<CompanyRepository>(
      () => CompanyRepositoryImpl(
        remoteDataSource: Get.find<CompanyRemoteDataSource>(),
      ),
      fenix: true,
    );

    // Controller - use fenix: true to recreate if disposed
    Get.lazyPut<CompanyController>(
      () => CompanyController(repository: Get.find<CompanyRepository>()),
      fenix: true,
    );
  }
}