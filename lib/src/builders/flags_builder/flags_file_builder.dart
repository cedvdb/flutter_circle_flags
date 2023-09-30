import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:path/path.dart';

class FlagsFileBuilder implements Builder {
  FlagsFileBuilder();

  static AssetId _allFileOutput(BuildStep buildStep) {
    return AssetId(
      buildStep.inputId.package,
      join('lib', 'src', 'flags.dart'),
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': const ['src/flags.dart']
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final output = _allFileOutput(buildStep);

    print("Writing ${output.path}");
    final fileHeader = '''
// GENERATED FILE

import 'package:circle_flags/circle_flags.dart';

/// List of available flags(iso codes) for [CircleFlag].
abstract class Flags {
''';

    var newFileContent = '';
    for (final file
        in Directory(".dart_tool/build/generated/circle_flags/assets/svg/")
            .listSync()
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path))) {
      if (file is File) {
        newFileContent += file.readAsStringSync();
      }
    }

    newFileContent += "}\n";
    return buildStep.writeAsString(output, fileHeader + newFileContent);
  }
}
