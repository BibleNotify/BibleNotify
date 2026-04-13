import 'dart:convert';
import 'dart:developer';

import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/services/settings_service.dart';
import 'package:biblenotify/services/verse_and_chapter_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class ReaderViewModel extends BaseViewModel {
  final _settingsService = locator<SettingsService>();
  final _versesAndChaptersService = locator<VerseAndChapterService>();

  String title = '';

  late WebViewController webviewController;

  Future<void> onInit() async {
    webviewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            rebuildUi();
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {
            log('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
            ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    await AndroidWebViewController.enableDebugging(kDebugMode);

    // Get the verse
    int verseIndex = await _settingsService.getCurrentRandomVerseIndex();
    Map<String, dynamic> verseJson = await _versesAndChaptersService.getVerseJsonFromIndex(verseIndex);
    String highlightVerseNumber = verseJson['place'].split(':')[1].replaceAll(' (story)', '') as String;

    // Get the chapter html content
    Map<String, dynamic> chapterJson = await _versesAndChaptersService.getChapterJsonFromIndex(verseIndex);
    String chapterContent = chapterJson['text'] as String;

    chapterContent = chapterContent.replaceAll(
        "<p><sup>$highlightVerseNumber</sup>", "<p class='hv'><sup>$highlightVerseNumber</sup>");

    // Assign the title
    title = chapterJson['chapter'] as String;

    Uri htmlUri = Uri.dataFromString('''
<!DOCTYPE html>
<html lang="en">
<head>
  <title></title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
</head>
<body>
<style>

body {
margin: 40px 10% 100px 10%;
color: #000;
}

p {
font-size: 18px;
font-family:  'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
color: #000;
}

.hv {
color: black;
font-weight: bold;
}

@media (min-width: 768px) {

p {
font-size: 19px;
}

sup {
font-weight: bold;
}

}

</style>

$chapterContent

</body>
</html>
''', mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));

    await webviewController.loadRequest(htmlUri);

    rebuildUi();
  }

  Future<void> onDispose() async {
    await webviewController.clearCache();
  }
}
