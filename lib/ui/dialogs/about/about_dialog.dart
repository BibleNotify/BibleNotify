import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'about_dialog_model.dart';

class AboutDialog extends StackedView<AboutDialogModel> {
  final DialogRequest<dynamic> request;
  final Function(DialogResponse<dynamic>) completer;

  const AboutDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AboutDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Image.asset(
                                'assets/images/banner.png',
                                width: 110.0,
                              ),
                            ),
                            Text(
                              'Bible Notify Contributors',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                              'Noah Rahm (@Correct-Syntax)\nSundry Code (@sundrycode)\nChepycou (@Chepycou)\n Diaa Hanna (@drnull03)\nPoussinou (@Poussinou)\n',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              softWrap: true,
                            ),
                            Text(
                              'Bible Notify License',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              """Bible Notify © 2026 Bible Notify contributors.\n\n${"""
                      This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program.  If not, see [https://www.gnu.org/licenses]. If you release an app based on the Bible Notify open source project, you must remove all references to "Bible Notify" to not create confusion. This includes the app's package name, as this is reserved for the official app.
                          """.trim()}""",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => completer(DialogResponse(confirmed: true)),
                icon: const ImageIcon(
                  AssetImage('assets/icons/x-lg.png'),
                  size: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  AboutDialogModel viewModelBuilder(BuildContext context) => AboutDialogModel();
}
