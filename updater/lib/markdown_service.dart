import 'dart:io';

import 'package:awesome_flutter_map/package_data.dart';

class MarkdownService {
  static final file = File('..${Platform.pathSeparator}README.md');
  final List<String> lines;

  const MarkdownService._(this.lines);

  static Future<MarkdownService> load() async {
    final lines = await file.readAsLines();
    var index = 0;
    while (!lines[index].startsWith('### ')) {
      index++;
    }
    final header = lines.sublist(0, index - 1);
    return MarkdownService._(header);
  }

  void addSection(String sectionName) {
    lines.addAll([
      '',
      '### $sectionName',
      '',
      '| Name | Links | Version | Last update | Meta | Description |',
      '|--|--|--|--|--|--|',
    ]);
  }

  void addPackage(PackageData data) {
    final homepageIsGithub = data.homepage?.contains('://github.com/') ?? false;
    lines.add('| ${data.name} '
        '| [pub.dev](https://pub.dev/packages/${data.name}) [${homepageIsGithub ? 'GitHub' : 'Homepage'}](${data.homepage}) '
        '| ${data.version} '
        '| ${data.lastUpdate.inDays} days ago '
        '| ![Pub Likes](https://img.shields.io/pub/likes/${data.name}) ![Pub Points](https://img.shields.io/pub/points/${data.name}) ![Pub Popularity](https://img.shields.io/pub/popularity/${data.name}) '
        '| ${data.description} |');
  }

  Future<void> save() async {
    final string = lines.join('\n');
    file.writeAsString(string);
  }
}
