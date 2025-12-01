import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/category_remote_datasource.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/repositories/category_repository.dart';
import '../controllers/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    // API Client - already registered in setupCore(), so don't re-register it

    // Data source - use fenix: true to recreate if disposed
    Get.lazyPut<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // Repository - use fenix: true to recreate if disposed
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepositoryImpl(
        remoteDataSource: Get.find<CategoryRemoteDataSource>(),
      ),
      fenix: true,
    );

    // Controller - use fenix: true to recreate if disposed
    Get.lazyPut<CategoryController>(
      () => CategoryController(repository: Get.find<CategoryRepository>()),
      fenix: true,
    );
  }
}