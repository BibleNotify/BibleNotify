// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/about/about_dialog.dart';

enum DialogType {
  about,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.about: (context, request, completer) => AboutDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
