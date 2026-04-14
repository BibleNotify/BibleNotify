import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'permissions_viewmodel.dart';

class PermissionsView extends StackedView<PermissionsViewModel> {
  const PermissionsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PermissionsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 75.0),
                child: Column(
                  spacing: 8.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      viewModel.s.permissions__alarmPermissionIsRequired,
                      style: const TextStyle(
                        fontSize: 21.0,
                      ),
                    ),
                    FilledButton.tonal(
                      onPressed: viewModel.onOkay,
                      child: Text(viewModel.s.permissions__okay),
                    ),
                    Image.asset(
                      'assets/images/alarm_permission_gif.gif',
                      height: 220.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  PermissionsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PermissionsViewModel();
}
