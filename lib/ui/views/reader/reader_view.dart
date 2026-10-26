import 'package:biblenotify/ui/common/app_colors.dart';
import 'package:material_ui/material_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'reader_viewmodel.dart';

class ReaderView extends StackedView<ReaderViewModel> {
  const ReaderView({super.key});

  @override
  void onViewModelReady(ReaderViewModel viewModel) async {
    super.onViewModelReady(viewModel);
    await viewModel.onInit();
  }

  @override
  void onDispose(ReaderViewModel viewModel) async {
    await viewModel.onDispose();
    super.onDispose(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    ReaderViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: darkGrayColor,
      appBar: AppBar(
        title: Text(
          viewModel.title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'Merriweather',
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: WebViewWidget(
                  controller: viewModel.webviewController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ReaderViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReaderViewModel();
}
