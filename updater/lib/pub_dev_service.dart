import 'package:awesome_flutter_map/package_data.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec/pubspec.dart';

class PubDevService {
  final PubClient _client;
  final PubPackage flutterMap;

  PubDevService(this._client, this.flutterMap);

  static Future<PubDevService> load() async {
    final client = PubClient();
    final flutterMap = await client.packageInfo('flutter_map');
    return PubDevService(client, flutterMap);
  }

  Future<PackageData> getData(String packageName) async {
    final info = await _client.packageInfo(packageName);
    final flutterMapDependency = info.latestPubspec.dependencies['flutter_map'];
    final dependencyVersion = flutterMapDependency?.dependencyVersion;
    bool? latestFlutterMapDependency;
    if (dependencyVersion != null) {
      final fmVersion = Version.parse(flutterMap.version);
      final fmVersionConstraint = VersionConstraint.parse(dependencyVersion);
      latestFlutterMapDependency = fmVersionConstraint.allows(fmVersion);
    }
    return PackageData(
      name: packageName,
      version: Version.parse(info.version),
      description: info.description,
      homepage: info.latestPubspec.homepage,
      repository: info.latestPubspec.unParsedYaml?['repository'],
      lastUpdate: info.latest.published,
      flutterMapVersion: dependencyVersion == null
          ? null
          : VersionConstraint.parse(dependencyVersion),
      latestFlutterMapDependency: latestFlutterMapDependency,
    );
  }
}

extension DependencyReferenceExt on DependencyReference {
  String get dependencyVersion => toString().replaceAll('"', '');
}
