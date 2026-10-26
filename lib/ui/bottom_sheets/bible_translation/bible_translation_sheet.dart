import 'package:biblenotify/common/constants.dart';
import 'package:biblenotify/common/enums.dart';
import 'package:material_ui/material_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'bible_translation_sheet_model.dart';

class BibleTranslationSheet extends StackedView<BibleTranslationSheetModel> {
  final Function(SheetResponse<dynamic> response) completer;
  final SheetRequest<dynamic> request;
  const BibleTranslationSheet({
    super.key,
    required this.completer,
    required this.request,
  });

  @override
  Widget builder(
    BuildContext context,
    BibleTranslationSheetModel viewModel,
    Widget? child,
  ) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      builder: (context, scrollController) {
        return Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 30.0, left: 10.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          width: 32.0,
                          height: 4.0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      RadioGroup<BibleTranslationOption>(
                        groupValue: viewModel.bibleTranslation,
                        onChanged: (value) => viewModel.onChange,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (BibleTranslationOption item in Const.bibleTranslationOptions.keys)
                              ListTile(
                                leading: Radio<BibleTranslationOption>(
                                  value: item,
                                ),
                                title: Text(Const.bibleTranslationOptions[item]!),
                                onTap: () {
                                  viewModel.onChange(item);
                                  completer(SheetResponse());
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  BibleTranslationSheetModel viewModelBuilder(BuildContext context) => BibleTranslationSheetModel();
}
