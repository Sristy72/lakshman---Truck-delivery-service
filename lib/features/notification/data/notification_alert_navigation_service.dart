import 'package:get/get.dart';

import '../presentations/controllers/notification_alert_controller.dart';
import '../presentations/screens/notification_alert.dart';
import 'services/notification_preferences_service.dart';

class NotificationAlertNavigationService {
  static NotificationAlertNavigationService? _instance;
  NotificationAlertNavigationService._();

  static NotificationAlertNavigationService get instance {
    _instance ??= NotificationAlertNavigationService._();
    return _instance!;
  }

  /// Check and show notification alert if needed
  /// This should be called after user login or app launch
  Future<bool> checkAndShowNotificationAlert() async {
    try {
      final prefsService = await NotificationPreferencesService.getInstance();
      
      // Check if alert should be shown
      if (prefsService.shouldShowNotificationAlert()) {
        // Initialize the controller if not already done
        if (!Get.isRegistered<NotificationAlertController>()) {
          Get.put(NotificationAlertController());
        }
        
        // Show the notification alert screen
        Get.to(() => const NotificationAlertScreen());
        return true; // Alert was shown
      }
      
      return false; // Alert was not shown
    } catch (e) {
      // If there's an error, don't show alert to avoid app crashes
      print('Error checking notification alert: $e');
      return false;
    }
  }

  /// Force show notification alert (useful for settings or manual trigger)
  Future<void> showNotificationAlert() async {
    if (!Get.isRegistered<NotificationAlertController>()) {
      Get.put(NotificationAlertController());
    }
    
    Get.to(() => const NotificationAlertScreen());
  }

  /// Check if user has notification permission without showing alert
  Future<bool> hasNotificationPermission() async {
    final prefsService = await NotificationPreferencesService.getInstance();
    return prefsService.hasGrantedNotificationPermission;
  }

  /// Reset notification preferences (for testing or settings)
  Future<void> resetNotificationPreferences() async {
    final prefsService = await NotificationPreferencesService.getInstance();
    await prefsService.resetPreferences();
  }
}