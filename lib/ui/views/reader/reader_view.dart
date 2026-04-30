import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'reader_viewmodel.dart';

class ReaderView extends StackedView<ReaderViewModel> {
  const ReaderView({Key? key}) : super(key: key);

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
      backgroundColor: Theme.of(context).colorScheme.surface,
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
