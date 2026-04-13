import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/services/l10n_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AppViewModel extends ReactiveViewModel {
  final _l10nService = locator<L10nService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_l10nService];

  Locale? get currentLocale => _l10nService.currentLocale;
}
