import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:biblenotify/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:biblenotify/services/settings_service.dart';
import 'package:biblenotify/services/notifications_service.dart';
import 'package:biblenotify/services/json_service.dart';
import 'package:biblenotify/services/verse_and_chapter_service.dart';
import 'package:biblenotify/services/l10n_service.dart';
import 'package:biblenotify/services/app_info_service.dart';
import 'package:biblenotify/services/web_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<SettingsService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<NotificationsService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<JsonService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<VerseAndChapterService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<L10nService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<AppInfoService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<WebService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
  ],
)
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterSettingsService();
  getAndRegisterNotificationsService();
  getAndRegisterJsonService();
  getAndRegisterVerseAndChapterService();
  getAndRegisterL10nService();
  getAndRegisterAppInfoService();
  getAndRegisterWebService();
// @stacked-mock-register
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(
    service.showCustomSheet<T, T>(
      enableDrag: anyNamed('enableDrag'),
      enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
      exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
      ignoreSafeArea: anyNamed('ignoreSafeArea'),
      isScrollControlled: anyNamed('isScrollControlled'),
      barrierDismissible: anyNamed('barrierDismissible'),
      additionalButtonTitle: anyNamed('additionalButtonTitle'),
      variant: anyNamed('variant'),
      title: anyNamed('title'),
      hasImage: anyNamed('hasImage'),
      imageUrl: anyNamed('imageUrl'),
      showIconInMainButton: anyNamed('showIconInMainButton'),
      mainButtonTitle: anyNamed('mainButtonTitle'),
      showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
      secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
      showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
      takesInput: anyNamed('takesInput'),
      barrierColor: anyNamed('barrierColor'),
      barrierLabel: anyNamed('barrierLabel'),
      customData: anyNamed('customData'),
      data: anyNamed('data'),
      description: anyNamed('description'),
    ),
  ).thenAnswer(
    (realInvocation) => Future.value(showCustomSheetResponse ?? SheetResponse<T>()),
  );

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockSettingsService getAndRegisterSettingsService() {
  _removeRegistrationIfExists<SettingsService>();
  final service = MockSettingsService();
  locator.registerSingleton<SettingsService>(service);
  return service;
}

MockNotificationsService getAndRegisterNotificationsService() {
  _removeRegistrationIfExists<NotificationsService>();
  final service = MockNotificationsService();
  locator.registerSingleton<NotificationsService>(service);
  return service;
}

MockJsonService getAndRegisterJsonService() {
  _removeRegistrationIfExists<JsonService>();
  final service = MockJsonService();
  locator.registerSingleton<JsonService>(service);
  return service;
}

MockVerseAndChapterService getAndRegisterVerseAndChapterService() {
  _removeRegistrationIfExists<VerseAndChapterService>();
  final service = MockVerseAndChapterService();
  locator.registerSingleton<VerseAndChapterService>(service);
  return service;
}

MockL10nService getAndRegisterL10nService() {
  _removeRegistrationIfExists<L10nService>();
  final service = MockL10nService();
  locator.registerSingleton<L10nService>(service);
  return service;
}

MockAppInfoService getAndRegisterAppInfoService() {
  _removeRegistrationIfExists<AppInfoService>();
  final service = MockAppInfoService();
  locator.registerSingleton<AppInfoService>(service);
  return service;
}

MockWebService getAndRegisterWebService() {
  _removeRegistrationIfExists<WebService>();
  final service = MockWebService();
  locator.registerSingleton<WebService>(service);
  return service;
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
