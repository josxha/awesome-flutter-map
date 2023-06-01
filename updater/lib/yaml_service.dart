import 'dart:io';

import 'package:yaml/yaml.dart';

class YamlService {
  static final file = File('..${Platform.pathSeparator}list_data.yml');
  final Map<String, List<String>> data;

  const YamlService._(this.data);

  static Future<YamlService> load() async {
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
