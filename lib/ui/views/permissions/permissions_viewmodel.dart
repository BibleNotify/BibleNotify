import 'package:biblenotify/L10n/generated/app_localizations.dart';
import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/app/app.router.dart';
import 'package:biblenotify/services/l10n_service.dart';
import 'package:biblenotify/services/notifications_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PermissionsViewModel extends BaseViewModel {
  final _l10nService = locator<L10nService>();
  final _notificationsService = locator<NotificationsService>();
  final _navigationService = locator<NavigationService>();

  AppLocalizations get s => _l10nService.s;

  void onOkay() async {
    await _notificationsService.requestNotificationPermission();

    await _notificationsService.requestExactAlarmPermission();

    if (await _notificationsService.checkIfAndroidPermissionsGranted() == true) {
      _navigationService.navigateToHomeView();
    }
  }
}
