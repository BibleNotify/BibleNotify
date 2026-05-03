import 'dart:typed_data';

import 'package:url_launcher/url_launcher.dart';

class WebService {
  Future<void> launchWebUrl(String url, bool external) async {
    if (external) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(Uri.parse(url));
    }
  }

  String getFontUri(ByteData data, String mime) {
    final buffer = data.buffer;
    return Uri.dataFromBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes), mimeType: mime).toString();
  }
}
