import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:biblenotify/L10n/generated/app_localizations.dart';
import 'package:biblenotify/app_viewmodel.dart';
import 'package:biblenotify/background_worker.dart';
import 'package:biblenotify/services/l10n_service.dart';
import 'package:biblenotify/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:biblenotify/app/app.bottomsheets.dart';
import 'package:biblenotify/app/app.dialogs.dart';
import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();

  await AndroidAlarmManager.initialize();
  await rescheduleAlarmsAfterBoot();

  // Preload to avoid interface language flicker
  await locator<L10nService>().init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      viewModelBuilder: () => AppViewModel(),
      builder: (context, model, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: locator<L10nService>().currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar'), // Arabic
            Locale('en'), // English
            Locale('fr'), // French
          ],
          initialRoute: Routes.startupView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
          navigatorObservers: [StackedService.routeObserver],
          theme: ThemeData(
            fontFamily: 'MerriweatherSans',
            colorScheme: const ColorScheme.dark(
              primary: primaryColor,
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: grayColor,
            ),
            filledButtonTheme: FilledButtonThemeData(
                style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.white10;
                }
                return primaryColor;
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                return darkGrayColor;
              }),
            )),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: grayColor,
              entryModeIconColor: Colors.white,
              dialBackgroundColor: darkGrayColor,
              dialHandColor: primaryColor,
              dialTextColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.white70;
              }),
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: darkGrayColor,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                labelStyle: TextStyle(color: Colors.white),
                floatingLabelStyle: TextStyle(color: Colors.white),
                helperStyle: TextStyle(color: Colors.white70),
                hintStyle: TextStyle(color: Colors.white38),
                counterStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white10, width: 1.5),
                ),
              ),
              helpTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              hourMinuteColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return primaryColor.withAlpha(70);
                }
                return darkGrayColor;
              }),
              hourMinuteTextColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return primaryColor;
                }
                return Colors.white;
              }),
              dayPeriodColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return primaryColor;
                }
                return Colors.transparent;
              }),
              dayPeriodTextColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.white38;
              }),
              dayPeriodShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              dayPeriodBorderSide: const BorderSide(
                color: Colors.white10,
              ),
              confirmButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(primaryColor),
              ),
              cancelButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.white70),
              ),
            ),
          ),
          builder: (context, child) {
            locator<L10nService>().capture(context);
            return child!;
          },
        );
      },
    );
  }
}
