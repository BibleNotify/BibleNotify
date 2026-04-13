import 'package:biblenotify/L10n/generated/app_localizations.dart';
import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/app/app.router.dart';
import 'package:biblenotify/services/l10n_service.dart';
import 'package:biblenotify/services/notifications_service.dart';
import 'package:biblenotify/services/settings_service.dart';
import 'package:biblenotify/services/verse_and_chapter_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends ReactiveViewModel {
  final _navigationService = locator<NavigationService>();
  final _l10nService = locator<L10nService>();
  final _notificationsService = locator<NotificationsService>();
  final _settingsService = locator<SettingsService>();
  final _versesAndChaptersService = locator<VerseAndChapterService>();

  bool get notificationsEnabled => _settingsService.notificationsEnabled;

  TimeOfDay get currentNotificationTime =>
      TimeOfDay.fromDateTime(DateTime.parse(_settingsService.currentNotificationTime));

  AppLocalizations get s => _l10nService.s;

  String randomVerseText = '';
  String randomVerseReference = '';

  Future<void> onInit() async {
    Map<String, dynamic> verseJson = await _versesAndChaptersService
        .getVerseJsonFromIndex(await _versesAndChaptersService.generateRandomVerseIndex());
    randomVerseText = verseJson['verse'] as String;
    randomVerseReference = verseJson['place'] as String;

    rebuildUi();
  }

  void onSettingsBtn() {
    _navigationService.navigateToSettingsView();
  }

  Future<void> onToggleNotificationsEnabled(bool value) async {
    _settingsService.setNotificationsEnabled(value);
    if (value == true) {
      await _notificationsService.scheduleDailyNotification();
    }
    rebuildUi();
  }

  Future<void> updateNotificationTime(TimeOfDay selectedTime) async {
    _settingsService.setCurrentNotificationTime(DateTime(1, 1, 1, selectedTime.hour, selectedTime.minute).toString());
    await _notificationsService.scheduleDailyNotification();
    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_l10nService];
}
