import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/services/l10n_service.dart';
import 'package:biblenotify/services/notifications_service.dart';
import 'package:biblenotify/services/settings_service.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
void alarmCallback() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Clear the under-the-hood locator cache using Stacked's framework properties.
  // This safely removes all registered singletons (like BottomSheetService)
  // from the reused memory thread before setupLocator runs again.
  final locatorInstance = locator;
  await locatorInstance.reset();

  await setupLocator();
  await locator<SettingsService>().init();
  await locator<L10nService>().initBackground();

  final notificationsService = locator<NotificationsService>();
  await notificationsService.showBackgroundNotification();
}
