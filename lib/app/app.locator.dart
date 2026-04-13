// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../services/app_info_service.dart';
import '../services/json_service.dart';
import '../services/l10n_service.dart';
import '../services/notifications_service.dart';
import '../services/settings_service.dart';
import '../services/verse_and_chapter_service.dart';
import '../services/web_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({String? environment, EnvironmentFilter? environmentFilter}) async {
// Register environments
  locator.registerEnvironment(environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SettingsService());
  locator.registerLazySingleton(() => NotificationsService());
  locator.registerLazySingleton(() => JsonService());
  locator.registerLazySingleton(() => VerseAndChapterService());
  locator.registerLazySingleton(() => L10nService());
  locator.registerLazySingleton(() => AppInfoService());
  locator.registerLazySingleton(() => WebService());
}
