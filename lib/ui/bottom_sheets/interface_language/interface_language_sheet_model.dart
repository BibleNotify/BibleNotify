import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/common/enums.dart';
import 'package:biblenotify/services/settings_service.dart';
import 'package:stacked/stacked.dart';

class InterfaceLanguageSheetModel extends BaseViewModel {
  final _settingsService = locator<SettingsService>();

  InterfaceLanguageOption get interfaceLanguage =>
      InterfaceLanguageOption.values.byName(_settingsService.currentInterfaceLanguage);

  void onChange(InterfaceLanguageOption value) {
    _settingsService.setCurrentInterfaceLanguage(value.name);
    rebuildUi();
  }
}
