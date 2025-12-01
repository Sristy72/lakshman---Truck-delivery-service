import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../../data/services/notification_preferences_service.dart';
import '../screens/notification_list.dart';
import 'notification_controller.dart';

class NotificationAlertController extends GetxController {
  late final NotificationPreferencesService _prefsService;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializePrefsService();
  }

  Future<void> _initializePrefsService() async {
    _prefsService = await NotificationPreferencesService.getInstance();
  }

  /// Check if notification alert should be shown
  bool shouldShowNotificationAlert() {
    return _prefsService.shouldShowNotificationAlert();
  }

  /// Handle "Later" button press
  Future<void> handleLaterPressed() async {
    try {
      isLoading.value = true;
      
      DPrint.log("🔔 User selected 'Later' for notification alert");
      
      // Save preference to show alert again
      await _prefsService.handleLaterSelected();
      
      DPrint.log("✅ Notification preferences saved - will show alert again");
      
      // Navigate back or to previous screen
      Get.back();
      
    } catch (e) {
      DPrint.error("💥 Error handling 'Later' selection: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle "Get Notified" button press
  Future<void> handleGetNotifiedPressed() async {
    try {
      isLoading.value = true;
      
      DPrint.log("🔔 User selected 'Get Notified' for notification alert");
      
      // Save preference to not show alert again
      await _prefsService.handleNotificationEnabled();
      
      DPrint.log("✅ Notification preferences saved - won't show alert again");
      
      // Initialize notification controller and fetch notifications
      final notificationController = Get.find<NotificationController>();
      await notificationController.fetchNotifications();
      
      // Navigate directly to notification list
      Get.off(() => const NotificationListScreen());
      
    } catch (e) {
      DPrint.error("💥 Error handling 'Get Notified' selection: $e");
      
      // Fallback: just navigate to notifications even if fetch fails
      Get.off(() => const NotificationListScreen());
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if user has already granted notification permission
  bool get hasNotificationPermission {
    return _prefsService.hasGrantedNotificationPermission;
  }

  /// Check if this is first time showing alert
  bool get isFirstTimeAlert {
    return !_prefsService.hasShownNotificationAlert;
  }

  /// Reset notification preferences (for testing/debugging)
  Future<void> resetPreferences() async {
    await _prefsService.resetPreferences();
    DPrint.log("🔄 Notification preferences reset");
  }
}