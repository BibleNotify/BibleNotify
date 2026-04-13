import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/common/enums.dart';
import 'package:biblenotify/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class BibleTranslationSheetModel extends BaseViewModel {
  final _settingsService = locator<SettingsService>();

  BibleTranslationOption get bibleTranslation =>
      BibleTranslationOption.values.byName(_settingsService.currentBibleTranslation);

  void onChange(BibleTranslationOption value) {
    _settingsService.setCurrentBibleTranslation(value.name);
    rebuildUi();
  }
}
