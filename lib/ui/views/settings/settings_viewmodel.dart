import 'package:biblenotify/L10n/generated/app_localizations.dart';
import 'package:biblenotify/app/app.bottomsheets.dart';
import 'package:biblenotify/app/app.dialogs.dart';
import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/common/enums.dart';
import 'package:biblenotify/services/app_info_service.dart';
import 'package:biblenotify/services/l10n_service.dart';
import 'package:biblenotify/services/settings_service.dart';
import 'package:biblenotify/services/web_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsViewModel extends ReactiveViewModel {
  final _settingsService = locator<SettingsService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _l10nService = locator<L10nService>();
  final _dialogService = locator<DialogService>();
  final _appInfoService = locator<AppInfoService>();
  final _webService = locator<WebService>();

  AppLocalizations get s => _l10nService.s;

  BibleTranslationOption get bibleTranslation =>
      BibleTranslationOption.values.byName(_settingsService.currentBibleTranslation);
  InterfaceLanguageOption get interfaceLanguage =>
      InterfaceLanguageOption.values.byName(_settingsService.currentInterfaceLanguage);

  // About
  String appInfo = '';

  Future<void> onInit() async {
    // About
    appInfo = await getAppVersion();

    rebuildUi();
  }

  Future<String> getAppVersion() async {
    return await _appInfoService.getVersionString();
  }

  void showBibleTranslationBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.bibleTranslation,
    );
  }

  void showInterfaceLanguageBottomSheet(BuildContext context) async {
    SheetResponse<dynamic>? response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.interfaceLanguage,
    );
    if (response != null) {
      _l10nService.changeLocale(interfaceLanguage.name);
    }
    rebuildUi();
  }

  void showAboutDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.about,
    );
  }

  Future<void> onVisitWebsite() async {
    await _webService.launchWebUrl('https://biblenotify.github.io', false);
  }

  Future<void> onVisitGitHub() async {
    await _webService.launchWebUrl('https://github.com/BibleNotify/BibleNotify', false);
  }

  Future<void> onVisitElementChat() async {
    await _webService.launchWebUrl('https://matrix.to/#/#bible-notify:matrix.org', false);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_settingsService, _l10nService];
}
