import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:circle_flags/src/builders/flags_builder/flags_file_builder.dart';

/// Generate one line of code for each .svg file, which will be used by [FlagsFileBuilder].
///
/// `build_runner` package watch changes in files and run `Builder` each time
/// file created(modified) - it call [AssetToCacheBuilder.build] for each
/// created(modified) file.
///
/// [AssetToCacheBuilder] executed then any *.svg file created/modified, and it create
/// *.part.txt file for each svg file (into cache dir .dart_tool/build/generated/).
///
/// Then *.svg file deleted - related *.part.txt file will also be deleted, but
/// unfortunately this didn't trigger [AssetToCacheBuilder]. Run: dart run build_runner build
class AssetToCacheBuilder implements Builder {
  AssetToCacheBuilder();

  @override
  Map<String, List<String>> get buildExtensions => {
        '.svg': const ['.part.txt']
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    print("Generating ${inputId.path}.part.txt");

    final baseName = inputId.pathSegments.last;
    final name = baseName.substring(0, baseName.length - 4); // cut .svg

    final mapEntry =
        "  static const String ${name.toUpperCase().replaceAll('-', '_')} = '$name';\n";

    try {
      File('lib/src/flags.dart')
          .deleteSync(); // force regeneration, didn't work than file just deleted((
    } on PathNotFoundException {}

    final outputId = inputId.changeExtension('.part.txt');
    return buildStep.writeAsString(outputId, mapEntry);
  }
}
