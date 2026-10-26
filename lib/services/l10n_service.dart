import 'package:biblenotify/L10n/generated/app_localizations.dart';
import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/services/settings_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:stacked/stacked.dart';

class L10nService with ListenableServiceMixin {
  final _settingsService = locator<SettingsService>();

  AppLocalizations? _strings;
  AppLocalizations get s => _strings!;

  Locale? _currentLocale;
  Locale? get currentLocale => _currentLocale;

  Locale _getSafeSupportedLocale(Locale inputLocale) {
    // Check if the base language code exists
    for (Locale supportedLocale in AppLocalizations.supportedLocales) {
      if (supportedLocale.languageCode == inputLocale.languageCode) {
        return supportedLocale;
      }
    }
    // Default fallback language if the device is set to an unsupported language
    return const Locale('en');
  }

  /// Initialize and load the saved locale
  Future<void> init() async {
    String? localeCode = await _settingsService.getCurrentInterfaceLanguage();

    final Locale rawTargetLocale = Locale(localeCode);
    final Locale safeLocale = _getSafeSupportedLocale(rawTargetLocale);
    _currentLocale = safeLocale;

    _strings = await AppLocalizations.delegate.load(safeLocale);
    notifyListeners();
  }

  /// Context-free initialization used exclusively by background isolates (the alarmCallback function)
  Future<void> initBackground() async {
    String? localeCode = await _settingsService.getCurrentInterfaceLanguage();

    final Locale rawTargetLocale = Locale(localeCode);
    final Locale safeLocale = _getSafeSupportedLocale(rawTargetLocale);
    _currentLocale = safeLocale;

    // Load the standard AppLocalizations bundle directly from the generated delegate
    _strings = await AppLocalizations.delegate.load(_currentLocale!);
  }

  /// Change and persist the locale
  Future<void> changeLocale(String languageCode) async {
    final Locale rawTargetLocale = Locale(languageCode);

    final Locale safeLocale = _getSafeSupportedLocale(rawTargetLocale);

    _currentLocale = safeLocale;

    _strings = await AppLocalizations.delegate.load(safeLocale);
    await _settingsService.setCurrentInterfaceLanguage(languageCode);
    notifyListeners();
  }
}
