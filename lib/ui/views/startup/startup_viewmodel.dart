import 'package:biblenotify/services/notifications_service.dart';
import 'package:biblenotify/services/settings_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stacked/stacked.dart';
import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _settingsService = locator<SettingsService>();
  final _navigationService = locator<NavigationService>();
  final _notificationsService = locator<NotificationsService>();

  // Place anything here that needs to happen before we get into the application
  Future<void> runStartupLogic() async {
    // Initialize settings
    await _settingsService.init();

    // Make sure the home view is in the stack so that when a notification
    // is tapped and the user is sent to the reader view the back button works.
    _navigationService.replaceWithHomeView();

    // Check if a notification launched the app
    final notificationPlugin = FlutterLocalNotificationsPlugin();
    NotificationAppLaunchDetails? launchDetails = await notificationPlugin.getNotificationAppLaunchDetails();

    // If launched from notification, navigate
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final String? payload = launchDetails?.notificationResponse?.payload;
      if (payload != null) {
        // Small delay to ensure the navigator is ready
        Future.delayed(Duration.zero, () {
          _navigationService.navigateTo(Routes.readerView);
        });
      }
    }

    await _notificationsService.init();
    await _notificationsService.requestNotificationPermission();
    await _notificationsService.requestExactAlarmPermission();
  }
}
