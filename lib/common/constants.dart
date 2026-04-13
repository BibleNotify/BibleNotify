import 'package:biblenotify/common/enums.dart';

class Const {
  /// The default notification datetime. (We're only concerned with the time, in this case 12:00AM.)
  static final defaultNotificationDateTime = DateTime(2026, 1, 1, 12, 0).toString();

  /// The total number of verses in bible_verses.json (see info.txt)
  static const int numberOfVerses = 158;

  /// The available Bible translations
  static const Map<BibleTranslationOption, String> bibleTranslationOptions = {
    BibleTranslationOption.rkjv: 'RKJV (English)',
    BibleTranslationOption.aelf: 'AELF (Français)',
    BibleTranslationOption.svd: 'SVD (عَرَبِيّ)',
  };

  /// The available interface languages
  static const Map<InterfaceLanguageOption, String> interfaceLanguageOptions = {
    InterfaceLanguageOption.en: 'English',
    InterfaceLanguageOption.fr: 'Français',
    InterfaceLanguageOption.ar: 'عَرَبِيّ',
  };
}
