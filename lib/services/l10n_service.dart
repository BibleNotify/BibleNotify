import 'package:biblenotify/L10n/generated/app_localizations.dart';
import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class L10nService with ListenableServiceMixin {
  final _settingsService = locator<SettingsService>();

  AppLocalizations? _strings;
  AppLocalizations get s => _strings!;

  Locale? _currentLocale;
  Locale? get currentLocale => _currentLocale;

  /// Initialize and load the saved locale
  Future<void> init() async {
    String localeCode = await _settingsService.getCurrentInterfaceLanguage();

    _currentLocale = Locale(localeCode);
    notifyListeners();
  }

  /// Captures the context so that the app localizations can be accessed.
  void capture(BuildContext context) {
    _strings = AppLocalizations.of(context);
  }

  /// Change and persist the locale
  Future<void> changeLocale(String languageCode) async {
    _currentLocale = Locale(languageCode);

    await _settingsService.setCurrentInterfaceLanguage(languageCode);

    notifyListeners();
  }
}
