import 'dart:io';

import 'package:yaml/yaml.dart';

class YamlService {
  static final file = File('list_data.yml');
  final Map<String, List<String>> data;

  const YamlService._(this.data);

  static Future<YamlService> load() async {
    final rawString = await file.readAsString();
    final YamlMap yaml = loadYaml(rawString);
    final parsed = <String, List<String>>{};
    for (final category in yaml.values) {
      final categoryName = category['name'];
      final YamlList yamlList = category['entries'];
      final packages = parsed[categoryName] = yamlList.toList().cast<String>();
      packages.sort((a, b) => a.compareTo(b));
      parsed[categoryName] = packages;
    }
    return YamlService._(parsed);
  }
}
