import 'dart:math';

import 'package:biblenotify/app/app.locator.dart';
import 'package:biblenotify/common/constants.dart';
import 'package:biblenotify/services/json_service.dart';
import 'package:biblenotify/services/settings_service.dart';

class VerseAndChapterService {
  final _jsonService = locator<JsonService>();
  final _settingsService = locator<SettingsService>();

  Future<int> generateRandomVerseIndex() async {
    Random random = Random();
    int randomInt = random.nextInt(Const.numberOfVerses - 1); // Int indexes start at 0
    return randomInt;
  }

  /// Get the random verse content from bible_verses.json
  Future<Map<String, dynamic>> getVerseJsonFromIndex(int verseIndex) async {
    String bibleTranslation = await _settingsService.getCurrentBibleTranslation();

    Map<String, dynamic> json = await _jsonService.loadVersesJson(bibleTranslation);

    Map<String, dynamic> verseJson = json['all'][verseIndex] as Map<String, dynamic>;
    return verseJson;
  }

  /// Get the chapter content based on the random verse
  Future<Map<String, dynamic>> getChapterJsonFromIndex(int verseIndex) async {
    String bibleTranslation = await _settingsService.getCurrentBibleTranslation();

    Map<String, dynamic> verseJson = await getVerseJsonFromIndex(verseIndex);
    String place = verseJson['data'] as String; // e.g: Gn/2

    Map<String, dynamic> json = await _jsonService.loadChaptersJson(bibleTranslation, place);

    Map<String, dynamic> chapterJson = json['read'][0] as Map<String, dynamic>;
    return chapterJson;
  }
}
