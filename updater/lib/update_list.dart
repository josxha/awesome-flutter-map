import 'package:awesome_flutter_map/markdown_service.dart';
import 'package:awesome_flutter_map/pub_dev_service.dart';
import 'package:awesome_flutter_map/yaml_service.dart';
import 'package:pub_semver/pub_semver.dart';

Future<void> main() async {
  final markdown = await MarkdownService.load();
  final pubDev = await PubDevService.load();
  final yaml = await YamlService.load();

  final flutterMapVersion = Version.parse(pubDev.flutterMap.version);

  for (final section in yaml.data.entries) {
    final sectionName = section.key;
    markdown.addSection(sectionName);
    for (final packageName in section.value) {
      print(packageName);
      final data = await pubDev.getData(packageName);
      if (flutterMapVersion.major - data.version.major > 1) continue;
      markdown.addPackage(data);
    }
    markdown.removeSectionIfEmpty();
  }
  await markdown.save();
}
