import 'package:dartz/dartz.dart';
import 'package:flutx_core/flutx_core.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<Either<NetworkFailure, NetworkSuccess<List<NotificationModel>>>> getAllNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Either<NetworkFailure, NetworkSuccess<List<NotificationModel>>>> getAllNotifications() async {
    try {
      DPrint.log("🔔 Fetching all notifications from API...");
      
      final result = await _apiClient.get<List<NotificationModel>>(
        ApiConstants.notification.getAllNotifications,
        fromJsonT: (json) {
          DPrint.log("📦 Raw Notifications Response: $json");
          
          if (json is List) {
            return json.map((notificationJson) => 
              NotificationModel.fromJson(notificationJson as Map<String, dynamic>)
            ).toList();
          } else if (json is Map && json['data'] is List) {
            // Handle case where response is wrapped in a data object
            final notifications = json['data'] as List;
            return notifications.map((notificationJson) => 
              NotificationModel.fromJson(notificationJson as Map<String, dynamic>)
            ).toList();
          }
          
          // Fallback to empty list if structure is unexpected
          DPrint.log("⚠️ Unexpected response structure for notifications");
          return <NotificationModel>[];
        },
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch notifications: ${failure.message}");
          return Left(failure);
        },
        (success) {
          final notifications = success.data;
          DPrint.log("✅ Successfully fetched ${notifications.length} notifications");
          
          for (var notification in notifications) {
            DPrint.log("   - ${notification.title}: ${notification.message} (${notification.type})");
          }
          
          return Right(NetworkSuccess<List<NotificationModel>>(
            data: notifications,
            message: 'Notifications fetched successfully',
            statusCode: 200,
          ));
        },
      );
    } catch (e) {
      DPrint.error("💥 Unexpected error fetching notifications: $e");
      return Left(
        NetworkFailure(
          message: 'Failed to fetch notifications: $e',
          statusCode: 0,
        ),
      );
    }
  }
}