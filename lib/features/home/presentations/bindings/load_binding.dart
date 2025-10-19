import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/load_remote_datasource.dart';
import '../../data/repositories/load_repository_impl.dart';
import '../../domain/repositories/load_repository.dart';
import '../controllers/load_controller.dart';

class LoadBinding extends Bindings {
  @override
  void dependencies() {
    // Data source
    Get.lazyPut<LoadRemoteDataSource>(
      () => LoadRemoteDataSourceImpl(apiClient: ApiClient()),
    );

    // Repository
    Get.lazyPut<LoadRepository>(
      () => LoadRepositoryImpl(
        remoteDataSource: Get.find<LoadRemoteDataSource>(),
      ),
    );

    // Controller
    Get.lazyPut<LoadController>(
      () => LoadController(repository: Get.find<LoadRepository>()),
    );
  }
}
