import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/services/l10n_service.dart';
import 'package:biblenotify/services/notifications_service.dart';
import 'package:biblenotify/services/settings_service.dart';

@pragma('vm:entry-point')
Future<void> alarmCallback() async {
  // Re-initialize the locator and services
  await setupLocator();
  await locator<SettingsService>().init();
  await locator<L10nService>().init();

  final notificationsService = locator<NotificationsService>();
  await notificationsService.scheduleDailyNotification();

  // Automatically schedule tomorrow's alarm
  await scheduleNextAlarm();
}

Future<void> scheduleNextAlarm() async {
  DateTime notificationDateTime = DateTime.parse(await locator<SettingsService>().getCurrentNotificationTime());

  final now = DateTime.now();
  var targetDate = DateTime(now.year, now.month, now.day, notificationDateTime.hour, notificationDateTime.minute);

  if (targetDate.isBefore(now)) {
    targetDate = targetDate.add(const Duration(days: 1));
  }

  // ID 0 ensures we overwrite any existing alarm
  await AndroidAlarmManager.oneShotAt(
    targetDate,
    0,
    alarmCallback,
    exact: true,
    wakeup: true, // Forces CPU to wake up from deep sleep
    allowWhileIdle: true, // Bypasses Android Doze mode
  );
}

Future<void> rescheduleAlarmsAfterBoot() async {
  // Automatically schedule next alarm
  await scheduleNextAlarm();
}
