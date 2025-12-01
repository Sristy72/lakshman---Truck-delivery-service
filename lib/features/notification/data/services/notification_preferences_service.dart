import 'package:get_storage/get_storage.dart';

class NotificationPreferencesService {
  static const String _keyNotificationAlertShown = 'notification_alert_shown';
  static const String _keyNotificationPermissionGranted = 'notification_permission_granted';
  static const String _keyShowAlertAgain = 'show_alert_again';

  static NotificationPreferencesService? _instance;
  static GetStorage? _storage;

  NotificationPreferencesService._();

  static Future<NotificationPreferencesService> getInstance() async {
    _instance ??= NotificationPreferencesService._();
    _storage ??= GetStorage();
    return _instance!;
  }

  /// Check if notification alert has been shown before
  bool get hasShownNotificationAlert {
    return _storage?.read(_keyNotificationAlertShown) ?? false;
  }

  /// Check if user granted notification permission
  bool get hasGrantedNotificationPermission {
    return _storage?.read(_keyNotificationPermissionGranted) ?? false;
  }

  /// Check if user wants to see alert again (selected "Later")
  bool get shouldShowAlertAgain {
    return _storage?.read(_keyShowAlertAgain) ?? false;
  }

  /// Mark that notification alert has been shown
  Future<void> setNotificationAlertShown() async {
    await _storage?.write(_keyNotificationAlertShown, true);
  }

  /// Set notification permission status
  Future<void> setNotificationPermission(bool granted) async {
    await _storage?.write(_keyNotificationPermissionGranted, granted);
  }

  /// Set whether to show alert again (for "Later" option)
  Future<void> setShouldShowAlertAgain(bool showAgain) async {
    await _storage?.write(_keyShowAlertAgain, showAgain);
  }

  /// Handle "Later" button press - show alert again next time
  Future<void> handleLaterSelected() async {
    await setNotificationAlertShown();
    await setShouldShowAlertAgain(true);
    await setNotificationPermission(false);
  }

  /// Handle "Get Notified" button press - don't show alert again
  Future<void> handleNotificationEnabled() async {
    await setNotificationAlertShown();
    await setShouldShowAlertAgain(false);
    await setNotificationPermission(true);
  }

  /// Check if should show notification alert based on user's previous choices
  bool shouldShowNotificationAlert() {
    // If never shown before, show it
    if (!hasShownNotificationAlert) {
      return true;
    }
    
    // If user selected "Later" before, show it again
    if (shouldShowAlertAgain) {
      return true;
    }
    
    // If user already granted permission, don't show
    return false;
  }

  /// Reset all preferences (useful for testing or user settings reset)
  Future<void> resetPreferences() async {
    await _storage?.remove(_keyNotificationAlertShown);
    await _storage?.remove(_keyNotificationPermissionGranted);
    await _storage?.remove(_keyShowAlertAgain);
  }
}