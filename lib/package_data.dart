class PackageData {
  final String name;
  final String version;
  final String description;
  final String? homepage;
  final Duration lastUpdate;

  const PackageData({
    required this.name,
    required this.version,
    required this.description,
    required this.homepage,
    required this.lastUpdate,
  });
}
