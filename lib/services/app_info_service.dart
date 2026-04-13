import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> getVersionString() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return 'v${packageInfo.version}';
  }
}
