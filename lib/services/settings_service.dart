import 'package:biblenotify/common/constants.dart';
import 'package:biblenotify/common/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class SettingsService with ListenableServiceMixin {
  SettingsService() {
    listenToReactiveValues([
      _currentBibleTranslation,
      _currentInterfaceLanguage,
    ]);
  }

  static const _kCurrentBibleTranslation = 'CURRENT_BIBLE_TRANSLATION';
  static const _kCurrentInterfaceLanguage = 'CURRENT_INTERFACE_LANGUAGE';

  static const _kCurrentRandomVerseIndex = 'CURRENT_RANDOM_VERSE_INDEX';
  static const _kCurrentNotificationTime = 'CURRENT_NOTIFICATION_TIME';

  static const _kNotificationsEnabled = 'NOTIFICATIONS_ENABLED';

  String _currentBibleTranslation = BibleTranslationOption.rkjv.name;
  String get currentBibleTranslation => _currentBibleTranslation;

  String _currentInterfaceLanguage = InterfaceLanguageOption.en.name;
  String get currentInterfaceLanguage => _currentInterfaceLanguage;

  int _currentRandomVerseIndex = 0;
  int get currentRandomVerseIndex => _currentRandomVerseIndex;

  String _currentNotificationTime = Const.defaultNotificationDateTime;
  String get currentNotificationTime => _currentNotificationTime;

  bool _notificationsEnabled = false;
  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> init() async {
    _currentBibleTranslation = await getCurrentBibleTranslation();
    _currentInterfaceLanguage = await getCurrentInterfaceLanguage();
    _currentRandomVerseIndex = await getCurrentRandomVerseIndex();
    _currentNotificationTime = await getCurrentNotificationTime();
    _notificationsEnabled = await getNotificationsEnabled();

    await setCurrentBibleTranslation(_currentBibleTranslation);
    await setCurrentInterfaceLanguage(_currentInterfaceLanguage);
    await setCurrentRandomVerseIndex(_currentRandomVerseIndex);
    await setCurrentNotificationTime(_currentNotificationTime);
    await setNotificationsEnabled(_notificationsEnabled);
  }

  // Bible translation
  Future<void> setCurrentBibleTranslation(String value) async {
    _currentBibleTranslation = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kCurrentBibleTranslation, value);
    notifyListeners();
  }

  Future<String> getCurrentBibleTranslation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentBibleTranslation = prefs.getString(_kCurrentBibleTranslation) ?? BibleTranslationOption.rkjv.name;
    return _currentBibleTranslation;
  }

  // Interface language
  Future<void> setCurrentInterfaceLanguage(String value) async {
    _currentInterfaceLanguage = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kCurrentInterfaceLanguage, value);
    notifyListeners();
  }

  Future<String> getCurrentInterfaceLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentInterfaceLanguage = prefs.getString(_kCurrentInterfaceLanguage) ?? InterfaceLanguageOption.en.name;
    return _currentInterfaceLanguage;
  }

  // Random verse index
  Future<void> setCurrentRandomVerseIndex(int value) async {
    _currentRandomVerseIndex = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_kCurrentRandomVerseIndex, value);
    notifyListeners();
  }

  Future<int> getCurrentRandomVerseIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentRandomVerseIndex = prefs.getInt(_kCurrentRandomVerseIndex) ?? 0;
    return _currentRandomVerseIndex;
  }

  // Notification time
  Future<void> setCurrentNotificationTime(String value) async {
    _currentNotificationTime = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kCurrentNotificationTime, value);
    notifyListeners();
  }

  Future<String> getCurrentNotificationTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentNotificationTime = prefs.getString(_kCurrentNotificationTime) ?? Const.defaultNotificationDateTime;
    return _currentNotificationTime;
  }

  // Whether notifications are enabled
  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kNotificationsEnabled, value);
    notifyListeners();
  }

  Future<bool> getNotificationsEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool(_kNotificationsEnabled) ?? false;
    return _notificationsEnabled;
  }
}
