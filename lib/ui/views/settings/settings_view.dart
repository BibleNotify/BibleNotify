import 'package:biblenotify/common/constants.dart';
import 'package:biblenotify/ui/views/settings/widgets/rounded_btn_item/rounded_btn_item.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'settings_viewmodel.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(SettingsViewModel viewModel) async {
    super.onViewModelReady(viewModel);
    await viewModel.onInit();
  }

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          viewModel.s.settings__title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'Merriweather',
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              ListTile(
                leading: Image.asset(
                  'assets/icons/book.png',
                  width: 22.0,
                ),
                title: Text(viewModel.s.settings__bibleTranslation),
                subtitle: Text(Const.bibleTranslationOptions[viewModel.bibleTranslation]!),
                onTap: viewModel.showBibleTranslationBottomSheet,
              ),
              ListTile(
                leading: Image.asset(
                  'assets/icons/translate.png',
                  width: 22.0,
                ),
                title: Text(viewModel.s.settings__interfaceLanguage),
                subtitle: Text(Const.interfaceLanguageOptions[viewModel.interfaceLanguage]!),
                onTap: () => viewModel.showInterfaceLanguageBottomSheet(context),
              ),

              const Opacity(opacity: 0.5, child: Divider()),

              ListTile(
                leading: Image.asset(
                  'assets/icons/c-circle.png',
                  width: 22.0,
                ),
                title: Text(viewModel.s.settings__licenseAndContributors),
                onTap: viewModel.showAboutDialog,
              ),

              ListTile(
                leading: Image.asset(
                  'assets/icons/info-square.png',
                  width: 22.0,
                ),
                title: const Text('Bible Notify'),
                subtitle: Text(viewModel.appInfo),
              ),

              // Social
              Container(
                margin: const EdgeInsets.symmetric(vertical: 26.0),
                child: Row(
                  spacing: 10.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Website
                    RoundedBtnItem(
                      icon: 'assets/icons/globe2.png',
                      tooltip: 'Visit Website',
                      onTap: viewModel.onVisitWebsite,
                    ),
                    // GitHub
                    RoundedBtnItem(
                      icon: 'assets/icons/github.png',
                      tooltip: 'Visit GitHub repository',
                      onTap: viewModel.onVisitGitHub,
                    ),
                    // Element chat
                    RoundedBtnItem(
                      icon: 'assets/icons/element.png',
                      tooltip: 'Visit Website',
                      onTap: viewModel.onVisitElementChat,
                    ),
                  ],
                ),
              ),

              // Bottom text
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 40.0),
                  child: Text(
                    '© 2026 Bible Notify Contributors.\nLicensed under the open-source GPL-3.0 license.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.0,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SettingsViewModel();
}
