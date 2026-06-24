import 'dart:async';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/app/app.router.dart';
import 'package:biblenotify/alarm_callback.dart';
import 'package:biblenotify/services/l10n_service.dart';
import 'package:biblenotify/services/settings_service.dart';
import 'package:biblenotify/services/verse_and_chapter_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

final StreamController<NotificationResponse> selectNotificationStream =
    StreamController<NotificationResponse>.broadcast();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.payload != null) {
    locator<NavigationService>().navigateTo(Routes.readerView);
  }
}

class NotificationsService with ListenableServiceMixin {
  final _navigationService = locator<NavigationService>();
  final _l10nService = locator<L10nService>();
  final _versesAndChaptersService = locator<VerseAndChapterService>();
  final _settingsService = locator<SettingsService>();

  bool _notificationsPermissionsGranted = false;
  bool get notificationsPermissionsGranted => _notificationsPermissionsGranted;

  Future<void> init() async {
    InitializationSettings initializationSettings = const InitializationSettings(
      android: AndroidInitializationSettings('notification_icon'),
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: selectNotificationStream.add,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  void dispose() {
    //selectNotificationStream.close();
  }

  Future<bool> checkIfAndroidPermissionsGranted() async {
    bool grantedNotificationPermission = await androidImplementation?.areNotificationsEnabled() ?? false;
    bool grantedExactAlarmPermission = await androidImplementation?.canScheduleExactNotifications() ?? false;

    _notificationsPermissionsGranted = grantedNotificationPermission == true && grantedExactAlarmPermission == true;
    notifyListeners();
    return _notificationsPermissionsGranted;
  }

  Future<void> requestExactAlarmPermission() async {
    await androidImplementation?.requestExactAlarmsPermission();
  }

  Future<void> requestNotificationPermission() async {
    await androidImplementation?.requestNotificationsPermission();
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();

    final TimezoneInfo timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
  }

  void configureOnTapNotification() {
    selectNotificationStream.stream.listen((NotificationResponse? response) async {
      _navigationService.navigateToReaderView();
    });
  }

  Future<void> scheduleDailyNotification() async {
    if (await checkIfAndroidPermissionsGranted() == false) {
      await _navigationService.navigateToPermissionsView();
      return;
    }
    await scheduleNextAlarm();
  }

  Future<void> scheduleNextAlarm() async {
    DateTime notificationDateTime = DateTime.parse(await _settingsService.getCurrentNotificationTime());

    final now = DateTime.now();
    var targetDate = DateTime(now.year, now.month, now.day, notificationDateTime.hour, notificationDateTime.minute);

    if (targetDate.isBefore(now)) {
      targetDate = targetDate.add(const Duration(days: 1));
    }

    await AndroidAlarmManager.periodic(
      const Duration(days: 1),
      999,
      alarmCallback,
      startAt: targetDate,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  Future<void> showBackgroundNotification() async {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('notification_icon'),
    );
    await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);

    int verseIndex = await _versesAndChaptersService.generateRandomVerseIndex();
    await _settingsService.setCurrentRandomVerseIndex(verseIndex);

    Map<String, dynamic> verseJson = await _versesAndChaptersService.getVerseJsonFromIndex(verseIndex);
    String verseText = verseJson['verse'] as String;
    String verseReference = verseJson['place'] as String;

    String notificationTitle = _l10nService.s.notification__title;

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: notificationTitle,
      body: verseText,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'bible_notify_channel',
          'Bible Daily Notifications',
          channelDescription: 'Bible Notify Daily Notification Channel',
          icon: 'notification_icon',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            verseText,
            summaryText: verseReference,
          ),
        ),
      ),
      payload: verseIndex.toString(),
    );
  }

  Future<tz.TZDateTime> nextInstanceOfTimeInterval() async {
    DateTime notificationDateTime = DateTime.parse(await _settingsService.getCurrentNotificationTime());

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      notificationDateTime.hour,
      notificationDateTime.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
