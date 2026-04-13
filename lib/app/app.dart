import 'package:biblenotify/ui/views/home/home_view.dart';
import 'package:biblenotify/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:biblenotify/ui/dialogs/about/about_dialog.dart';
import 'package:biblenotify/ui/views/settings/settings_view.dart';
import 'package:biblenotify/services/settings_service.dart';
import 'package:biblenotify/services/notifications_service.dart';
import 'package:biblenotify/ui/views/reader/reader_view.dart';
import 'package:biblenotify/ui/bottom_sheets/interface_language/interface_language_sheet.dart';
import 'package:biblenotify/ui/bottom_sheets/bible_translation/bible_translation_sheet.dart';
import 'package:biblenotify/services/json_service.dart';
import 'package:biblenotify/services/verse_and_chapter_service.dart';
import 'package:biblenotify/services/l10n_service.dart';
import 'package:biblenotify/services/app_info_service.dart';
import 'package:biblenotify/services/web_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: ReaderView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SettingsService),
    LazySingleton(classType: NotificationsService),
    LazySingleton(classType: JsonService),
    LazySingleton(classType: VerseAndChapterService),
    LazySingleton(classType: L10nService),
    LazySingleton(classType: AppInfoService),
    LazySingleton(classType: WebService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: InterfaceLanguageSheet),
    StackedBottomsheet(classType: BibleTranslationSheet),
// @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: AboutDialog),
// @stacked-dialog
  ],
)
class App {}
