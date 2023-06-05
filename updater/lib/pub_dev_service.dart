import 'package:awesome_flutter_map/package_data.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec/pubspec.dart';

class PubDevService {
  final PubClient _client;
  final PubPackage fm;
  late final fmVersion = Version.parse(fm.version);

  PubDevService(this._client, this.fm);

  static Future<PubDevService> load() async {
    final client = PubClient();
    return PubDevService(
      client,
      await client.packageInfo('flutter_map'),
    );
  }

  Future<PackageData> getData(String packageName) async {
    final info = await _client.packageInfo(packageName);
    final packageVersion = Version.parse(info.version);
    final fmVersionConstraint = info.latestPubspec.fmDependencyConstraint;
    return PackageData(
      name: packageName,
      version: packageVersion,
      description: info.description,
      homepage: info.latestPubspec.homepage,
      repository: info.latestPubspec.repository,
      lastUpdate: info.latest.published,
      flutterMapVersion: fmVersionConstraint,
      latestFlutterMapDependency: fmVersionConstraint?.allows(fmVersion),
      discontinued: fmVersionConstraint != null &&
          !fmVersionConstraint.allows(fmVersion) &&
          !fmVersionConstraint.allows(Version(fmVersion.major - 1, 0, 0)),
    );
  }
}

extension PubspecExt on PubSpec {
  VersionConstraint? get fmDependencyConstraint {
    final fmDep = dependencies['flutter_map'];
    if (fmDep == null) return null;
    return VersionConstraint.parse(fmDep.toString().replaceAll('"', ''));
  }

  String? get repository => unParsedYaml?['repository'];
}
