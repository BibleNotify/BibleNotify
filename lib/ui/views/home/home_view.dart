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
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Determine if we need 1 or 2 columns
                      final isSmall = constraints.maxWidth < 600;
                      final columns = isSmall ? 1 : 2;

                      // Calculate width for each card
                      const spacing = 5.0;
                      final cardWidth = (constraints.maxWidth - (spacing * (columns + 1))) / columns;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: [
                          SizedBox(
                            width: cardWidth,
                            child: Card(
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
                          ),
                          const SizedBox(height: spacing, width: spacing),
                          SizedBox(
                            width: cardWidth,
                            child: Card(
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  spacing: 12.0,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Opacity(
                                      opacity: viewModel.notificationsEnabled == true ? 1.0 : 0.5,
                                      child: Column(
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
                                            style: const TextStyle(
                                                fontSize: 60.0, height: 0.85, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
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
                          ),
                        ],
                      );
                    },
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
