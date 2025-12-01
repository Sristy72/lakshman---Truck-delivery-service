import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/load_remote_datasource.dart';
import '../../data/repositories/load_repository_impl.dart';
import '../../domain/repositories/load_repository.dart';
import '../controllers/load_controller.dart';

class LoadBinding extends Bindings {
  @override
  void dependencies() {
    // API Client - already registered in setupCore(), so don't re-register it
    
    // Data source - use fenix: true to recreate if disposed
    Get.lazyPut<LoadRemoteDataSource>(
      () => LoadRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // Repository - use fenix: true to recreate if disposed
    Get.lazyPut<LoadRepository>(
      () => LoadRepositoryImpl(
        remoteDataSource: Get.find<LoadRemoteDataSource>(),
        apiClient: Get.find<ApiClient>(),
      ),
      fenix: true,
    );

    // Controller - use fenix: true to recreate if disposed
    Get.lazyPut<LoadController>(
      () => LoadController(repository: Get.find<LoadRepository>()),
      fenix: true,
    );
  }
}
