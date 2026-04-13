// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedBottomsheetGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/bottom_sheets/bible_translation/bible_translation_sheet.dart';
import '../ui/bottom_sheets/interface_language/interface_language_sheet.dart';

enum BottomSheetType {
  interfaceLanguage,
  bibleTranslation,
}

void setupBottomSheetUi() {
  final bottomsheetService = locator<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.interfaceLanguage: (context, request, completer) =>
        InterfaceLanguageSheet(request: request, completer: completer),
    BottomSheetType.bibleTranslation: (context, request, completer) =>
        BibleTranslationSheet(request: request, completer: completer),
  };

  bottomsheetService.setCustomSheetBuilders(builders);
}
