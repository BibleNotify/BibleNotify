// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get notification__title => 'كملة من الكتاب المقدس';

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

  @override
  String get permissions__alarmPermissionIsRequired =>
      'Alarm permission is required';

  @override
  String get permissions__okay => 'Okay';

  @override
  String get about__contributors => 'Bible Notify Contributors';

  @override
  String get about__license => 'Bible Notify License';
}
