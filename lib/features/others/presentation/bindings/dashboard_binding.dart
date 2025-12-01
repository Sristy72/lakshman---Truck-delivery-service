import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/dashboard_repository.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Data Source
    Get.lazyPut<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(
        apiClient: Get.find<ApiClient>(),
      ),
    );

    // Repository
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(
        remoteDataSource: Get.find<DashboardRemoteDataSource>(),
      ),
    );

    // Controller
    Get.lazyPut<DashboardController>(
      () => DashboardController(
        repository: Get.find<DashboardRepository>(),
      ),
    );
  }
}
