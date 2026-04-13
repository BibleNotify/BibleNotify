import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/services.dart';

import 'package:flutter/services.dart' show rootBundle;

const String basePath = 'assets/bibles';

class JsonService {
  /// [place] is a String "bookCode/number" like "Psa/2"
  Future<Map<String, dynamic>> loadChaptersJson(String bibleTranslation, String place) async {
    return loadJsonFromAssets('$basePath/$bibleTranslation/$place.json');
  }

  Future<Map<String, dynamic>> loadVersesJson(String bibleTranslation) async {
    return loadJsonFromAssets('$basePath/$bibleTranslation/Verses/bible_verses.json');
  }

  Future<Map<String, dynamic>> loadJsonFromAssets(String path) async {
    final String data = await rootBundle.loadString(path);
    return await Isolate.run<Map<String, dynamic>>(() {
      return json.decode(data) as Map<String, dynamic>;
    });
  }
}
