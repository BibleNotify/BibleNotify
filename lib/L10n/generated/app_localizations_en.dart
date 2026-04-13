// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get notification__title => 'A Word from the Scriptures';

  @override
  String get home__dailyVerseNotificationAt => 'Daily verse notification at';

  @override
  String get settings__title => 'Settings';

  @override
  String get settings__bibleTranslation => 'Bible translation';

  @override
  String get settings__interfaceLanguage => 'Interface language';

  @override
  String get settings__licenseAndContributors => 'License and contributors';
}
