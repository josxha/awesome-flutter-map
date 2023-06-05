import 'package:awesome_flutter_map/markdown_service.dart';
import 'package:awesome_flutter_map/pub_dev_service.dart';
import 'package:awesome_flutter_map/yaml_service.dart';

Future<void> main() async {
  final markdown = await MarkdownService.load();
  final pubDev = await PubDevService.load();
  final yaml = await YamlService.load();

  for (final section in yaml.data.entries) {
    final sectionName = section.key;
    markdown.addSection(sectionName);
    for (final packageName in section.value) {
      print(packageName);
      final data = await pubDev.getData(packageName);
      if (data.discontinued) continue;
      markdown.addPackage(data);
    }
    markdown.removeSectionIfEmpty();
  }
  await markdown.save();
}
