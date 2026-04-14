import 'dart:async';
import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/app/app.router.dart';
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
    if (_notificationsPermissionsGranted == false) return;
    await configureLocalTimeZone();
    configureOnTapNotification();

    // Generate the random verse
    int verseIndex = await _versesAndChaptersService.generateRandomVerseIndex();
    // Set the current index
    await _settingsService.setCurrentRandomVerseIndex(verseIndex);
    Map<String, dynamic> verseJson = await _versesAndChaptersService.getVerseJsonFromIndex(verseIndex);
    String verseText = verseJson['verse'] as String;
    String verseReference = verseJson['place'] as String;

    // Notification title
    String notificationTitle = _l10nService.s.notification__title;

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 0,
      title: notificationTitle,
      body: verseText,
      payload: '',
      scheduledDate: await nextInstanceOfTimeInterval(),
      // tz.TZDateTime.now(
      //   tz.local,
      // ).add(const Duration(seconds: 10)),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          icon: 'notification_icon',
          'bible_notify_id',
          'bible_notify_daily_notification_channel',
          channelDescription: 'Bible Notify Daily Notification',
          styleInformation: BigTextStyleInformation(
            verseText,
            summaryText: verseReference,
          ),
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
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
