import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(HomeViewModel viewModel) async {
    super.onViewModelReady(viewModel);
    await viewModel.onInit();
  }

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bible Notify',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: const ImageIcon(
              AssetImage('assets/icons/gear.png'),
            ),
            padding: const EdgeInsets.all(0.0),
            iconSize: 24.0,
            onPressed: viewModel.onSettingsBtn,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      spacing: 8.0,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.randomVerseText,
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          viewModel.randomVerseReference,
                          style: const TextStyle(fontSize: 14.0),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      spacing: 12.0,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.s.home__dailyVerseNotificationAt.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          viewModel.currentNotificationTime.format(context),
                          style: const TextStyle(fontSize: 60.0, height: 0.85, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Switch(
                              value: viewModel.notificationsEnabled,
                              onChanged: viewModel.onToggleNotificationsEnabled,
                            ),
                            IconButton(
                              onPressed: () async {
                                final TimeOfDay? selectedTime = await showTimePicker(
                                  context: context,
                                  initialTime: viewModel.currentNotificationTime,
                                );

                                if (selectedTime != null) {
                                  viewModel.updateNotificationTime(selectedTime);
                                }
                              },
                              icon: Image.asset(
                                'assets/icons/pencil-square.png',
                                width: 22.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
