import 'dart:io';

import 'package:yaml/yaml.dart';

class YamlService {
  final Map<String, List<String>> data;

  const YamlService._(this.data);

  static Future<YamlService> load() async {
    final file = File('list_data.yml');
    final rawString = await file.readAsString();
    final YamlMap yaml = loadYaml(rawString);
    final parsed = <String, List<String>>{};
    for (final category in yaml.values) {
      final categoryName = category['name'];
      final YamlList packages = category['entries'];
      parsed[categoryName] = packages.toList().cast<String>();
    }
    return YamlService._(parsed);
  }
}
