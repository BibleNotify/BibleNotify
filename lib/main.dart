import 'package:biblenotify/L10n/generated/app_localizations.dart';
import 'package:biblenotify/app_viewmodel.dart';
import 'package:biblenotify/services/l10n_service.dart';
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
            //7DD273
            //242424
            colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF7DD273)),
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
