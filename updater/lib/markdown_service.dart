import 'dart:io';

import 'package:awesome_flutter_map/package_data.dart';
import 'package:intl/intl.dart';

class MarkdownService {
  static final file = File('README.md');
  final List<String> lines;

  const MarkdownService._(this.lines);

  static Future<MarkdownService> load() async {
    final lines = await file.readAsLines();
    var index = 0;
    while (!lines[index].startsWith('## ')) {
      index++;
    }
    final header = lines.sublist(0, index - 1);
    return MarkdownService._(header);
  }

  void removeSectionIfEmpty() {
    if (lines.last.startsWith('## ')) {
      lines.removeRange(lines.length - 2, lines.length);
    }
  }

  void addSection(String sectionName) {
    lines.addAll([
      '',
      '## $sectionName',
    ]);
  }

  void addPackage(PackageData data) {
    lines.addAll([
      // name
      '### ${data.name}',
      // description
      data.description,
      '',
      // shields
      '${data.pubLikesShield} ${data.pubPointsShield} ${data.pubPopularityShield}',
      '',
      // pubspec.yaml
      '```yaml',
      '${data.name}: ^${data.version}',
      '```',
      // meta data
      '| Last update | Links | flutter_map version |',
      '| ----------- | ----- | ------------------- |',
    ]);
    // table content
    var content = '| ${DateFormat.yMMMEd().format(data.lastUpdate)} ';
    content += '| [pub.dev](${data.pubDevUrl}) ';
    if (data.homepage != null) {
      if (data.homepage!.contains('://github.com/')) {
        content += ' [GitHub](${data.homepage}) ';
      } else {
        content += ' [Homepage](${data.homepage}) ';
      }
    }
    if (data.repository != null && data.repository != data.homepage) {
      final isGithub = data.repository!.contains('://github.com/');
      content +=
          ' [${isGithub ? 'GitHub' : 'Source-code'}](${data.repository}) ';
    }
    if (data.latestFlutterMapDependency == null) {
      content += '| - |';
    } else if (data.latestFlutterMapDependency!) {
      content += '| ${data.flutterMapVersion} |';
    } else {
      // show red text
      content +=
          '| <span style="color:red">${data.flutterMapVersion} (not latest)</span> |';
    }
    lines.add(content);
  }

  Future<void> save() async {
    final string = lines.join('\n');
    file.writeAsString(string);
  }
}
