import 'package:biblenotify/common/constants.dart';
import 'package:biblenotify/common/enums.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'interface_language_sheet_model.dart';

class InterfaceLanguageSheet extends StackedView<InterfaceLanguageSheetModel> {
  final Function(SheetResponse<dynamic> response) completer;
  final SheetRequest<dynamic> request;
  const InterfaceLanguageSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    InterfaceLanguageSheetModel viewModel,
    Widget? child,
  ) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
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
                    RadioGroup<InterfaceLanguageOption>(
                      groupValue: viewModel.interfaceLanguage,
                      onChanged: (value) {
                        viewModel.onChange(value!);
                        completer(SheetResponse());
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (InterfaceLanguageOption item in Const.interfaceLanguageOptions.keys)
                            ListTile(
                              leading: Radio<InterfaceLanguageOption>(
                                value: item,
                              ),
                              title: Text(Const.interfaceLanguageOptions[item]!),
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
        );
      },
    );
  }

  @override
  InterfaceLanguageSheetModel viewModelBuilder(BuildContext context) => InterfaceLanguageSheetModel();
}
