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
    final hasHomepage = data.homepage != null;
    final urlIsGitHub = data.homepage?.contains('://github.com/') ?? false;
    var line = '| ${data.name} ';
    line += '| [pub.dev](https://pub.dev/packages/${data.name}) ';
    if (hasHomepage) {
      line += '[${urlIsGitHub ? 'GitHub' : 'Homepage'}](${data.homepage}) ';
    }
    line += '| ${data.version} ';
    line += '| ${data.lastUpdate.inDays} days ago ';
    line += '| ![Pub Likes](https://img.shields.io/pub/likes/${data.name}) ';
    line += '![Pub Points](https://img.shields.io/pub/points/${data.name}) ';
    line +=
        '![Pub Popularity](https://img.shields.io/pub/popularity/${data.name}) ';
    line += '| ${data.description} |';
    lines.add(line);
  }

  Future<void> save() async {
    final string = lines.join('\n');
    file.writeAsString(string);
  }
}
