import 'package:url_launcher/url_launcher.dart';

class WebService {
  Future<void> launchWebUrl(String url, bool external) async {
    if (external) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(Uri.parse(url));
    }
  }
}
