import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../../data/models/notification_model.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository _repository;

  NotificationController({required NotificationRepository repository})
      : _repository = repository;

  // Observable lists
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't auto-fetch on init to avoid unnecessary API calls
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log("========== FETCH NOTIFICATIONS ==========");

      final result = await _repository.getAllNotifications();

      result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch notifications: ${failure.message}");
          errorMessage.value = failure.message;
          notifications.clear();
        },
        (success) {
          DPrint.log("✅ Successfully fetched ${success.data.length} notifications");
          // Sort notifications by creation date (newest first)
          final sortedNotifications = success.data..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          notifications.value = sortedNotifications;
          errorMessage.value = '';
        },
      );
    } catch (e) {
      DPrint.error("💥 Unexpected error in NotificationController: $e");
      errorMessage.value = 'An unexpected error occurred';
      notifications.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  /// Get notification by ID
  NotificationModel? getNotificationById(String id) {
    try {
      return notifications.firstWhere((notification) => notification.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get unread notifications count
  int get unreadCount {
    return notifications.where((notification) => !notification.isRead).length;
  }

  /// Get unread notifications
  List<NotificationModel> get unreadNotifications {
    return notifications.where((notification) => !notification.isRead).toList();
  }

  /// Get read notifications
  List<NotificationModel> get readNotifications {
    return notifications.where((notification) => notification.isRead).toList();
  }

  /// Filter notifications by type
  List<NotificationModel> getNotificationsByType(String type) {
    return notifications.where((notification) => 
      notification.type.toLowerCase() == type.toLowerCase()).toList();
  }

  /// Get recent notifications (last 24 hours)
  List<NotificationModel> get recentNotifications {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return notifications.where((notification) => 
      notification.createdAt.isAfter(yesterday)).toList();
  }

  /// Mark notification as read (placeholder for future API call)
  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((notification) => notification.id == notificationId);
    if (index != -1) {
      // Create a new notification with updated read status
      final updatedNotification = NotificationModel(
        id: notifications[index].id,
        user: notifications[index].user,
        company: notifications[index].company,
        dispatcher: notifications[index].dispatcher,
        title: notifications[index].title,
        message: notifications[index].message,
        type: notifications[index].type,
        isRead: true, // Mark as read
        createdAt: notifications[index].createdAt,
        updatedAt: DateTime.now(),
      );
      notifications[index] = updatedNotification;
    }
  }

  /// Clear all notifications (placeholder for future API call)
  void clearAllNotifications() {
    notifications.clear();
  }
}