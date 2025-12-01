import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/driver_remote_datasource.dart';
import '../../data/repositories/driver_repository_impl.dart';
import '../../domain/driver_repository.dart';
import '../controllers/driver_controller.dart';

class DriverBinding extends Bindings {
  @override
  void dependencies() {
    // Data Source
    Get.lazyPut<DriverRemoteDataSource>(
      () => DriverRemoteDataSourceImpl(
        apiClient: Get.find<ApiClient>(),
      ),
    );

    // Repository
    Get.lazyPut<DriverRepository>(
      () => DriverRepositoryImpl(
        remoteDataSource: Get.find<DriverRemoteDataSource>(),
      ),
    );

    // Controller
    Get.lazyPut<DriverController>(
      () => DriverController(
        repository: Get.find<DriverRepository>(),
      ),
    );
  }
}
