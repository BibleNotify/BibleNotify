import 'package:flutter_test/flutter_test.dart';
import 'package:biblenotify/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('WebServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
