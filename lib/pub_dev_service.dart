import 'package:awesome_flutter_map/package_data.dart';
import 'package:pub_api_client/pub_api_client.dart';

class PubDevService {
  final _client = PubClient();

  Future<PackageData> getData(String packageName) async {
    final package = await _client.packageInfo(packageName);
    final now = DateTime.now();
    return PackageData(
      name: packageName,
      version: package.version,
      description: package.description,
      homepage: package.latestPubspec.homepage,
      lastUpdate: now.difference(package.latest.published),
    );
  }
}
