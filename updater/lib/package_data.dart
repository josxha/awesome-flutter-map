class PackageData {
  final String name;
  final String version;
  final String description;
  final String? homepage;
  final String? repository;
  final DateTime lastUpdate;
  final String flutterMapVersion;
  final bool? latestFlutterMapDependency;

  const PackageData({
    required this.name,
    required this.version,
    required this.description,
    required this.homepage,
    required this.lastUpdate,
    required this.flutterMapVersion,
    required this.latestFlutterMapDependency,
    required this.repository,
  });

  String get pubDevUrl => 'https://pub.dev/packages/$name';

  String get pubLikesShield =>
      '![Pub Likes](https://img.shields.io/pub/likes/$name)';

  String get pubPointsShield =>
      '![Pub Points](https://img.shields.io/pub/points/$name)';

  String get pubPopularityShield =>
      '![Pub Popularity](https://img.shields.io/pub/popularity/$name)';
}
