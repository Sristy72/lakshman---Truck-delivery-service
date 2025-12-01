import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';
import '../controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // API Client - already registered in setupCore(), so don't re-register it

    // Data source - use fenix: true to recreate if disposed
    Get.lazyPut<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // Repository - use fenix: true to recreate if disposed
    Get.lazyPut<NotificationRepository>(
      () => NotificationRepositoryImpl(
        remoteDataSource: Get.find<NotificationRemoteDataSource>(),
      ),
      fenix: true,
    );

    // Controller - use fenix: true to recreate if disposed
    Get.lazyPut<NotificationController>(
      () => NotificationController(repository: Get.find<NotificationRepository>()),
      fenix: true,
    );
  }
}