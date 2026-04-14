import 'package:biblenotify/L10n/generated/app_localizations.dart';
import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/services/l10n_service.dart';
import 'package:stacked/stacked.dart';

class AboutDialogModel extends BaseViewModel {
  final _l10nService = locator<L10nService>();

  AppLocalizations get s => _l10nService.s;

}
