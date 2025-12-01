import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/dispatcher_remote_datasource.dart';
import '../../data/repositories/dispatcher_repository_impl.dart';
import '../../domain/dispatcher_repository.dart';
import '../controllers/dispatcher_controller.dart';

class DispatcherBinding extends Bindings {
  @override
  void dependencies() {
    // Data Source
    Get.lazyPut<DispatcherRemoteDataSource>(
      () => DispatcherRemoteDataSourceImpl(
        apiClient: Get.find<ApiClient>(),
      ),
    );

    // Repository
    Get.lazyPut<DispatcherRepository>(
      () => DispatcherRepositoryImpl(
        remoteDataSource: Get.find<DispatcherRemoteDataSource>(),
      ),
    );

    // Controller
    Get.lazyPut<DispatcherController>(
      () => DispatcherController(
        repository: Get.find<DispatcherRepository>(),
      ),
    );
  }
}
