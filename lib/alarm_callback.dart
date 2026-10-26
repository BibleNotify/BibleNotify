import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/services/l10n_service.dart';
import 'package:biblenotify/services/notifications_service.dart';
import 'package:biblenotify/services/settings_service.dart';
import 'package:material_ui/material_ui.dart';

@pragma('vm:entry-point')
void alarmCallback() async {
  WidgetsFlutterBinding.ensureInitialized();

  final locatorInstance = locator;
  await locatorInstance.reset();

  await setupLocator();
  await locator<SettingsService>().init();
  await locator<L10nService>().initBackground();

  final notificationsService = locator<NotificationsService>();
  await notificationsService.showBackgroundNotification();
}
