import 'dart:io';

import 'package:path/path.dart' as p;

/// Regenerates `lib/src/flag.dart` from the flags committed in `assets/svg`.
///
/// `assets/svg` is the source of truth: every `.svg` file in that directory is
/// exposed as a flag. To add, override or remove a flag, change the files in
/// `assets/svg` and run this script.
///
/// A file name has to be lower case, because `CircleFlag` lower cases the code
/// it is given before resolving `assets/svg/<code>.svg`, and it has to be a
/// valid Dart identifier once upper cased, because it becomes a `Flag`
/// constant. Upstream names such as `us-in.svg` therefore have to be renamed
/// (`us_in.svg`, used as `Flag.US_IN` or `CircleFlag('us_in')`).
///
/// Run:
/// ```bash
/// dart run tool/generate_flag.dart
/// ```
void main(List<String> arguments) {
  const svgDirPath = 'assets/svg';
  const outputFilePath = 'lib/src/flag.dart';

  final svgDir = Directory(svgDirPath);
  if (!svgDir.existsSync()) {
    stderr.writeln('❌ Source directory "$svgDirPath" not found.');
    exit(1);
  }

  final svgFiles =
      svgDir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.svg'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  if (svgFiles.isEmpty) {
    stderr.writeln('⚠️ No SVG files found in $svgDirPath');
    exit(1);
  }

  // See the documentation of [main]: a lower case, identifier safe file name is
  // what makes `CircleFlag(code)` and `Flag.CODE` resolve the same asset.
  final invalidNames = [
    for (final svg in svgFiles)
      if (!_assetNamePattern.hasMatch(p.basenameWithoutExtension(svg.path)))
        p.basename(svg.path),
  ];
  if (invalidNames.isNotEmpty) {
    stderr
      ..writeln('❌ Invalid flag file name(s) in $svgDirPath:')
      ..writeln('   ${invalidNames.join(', ')}')
      ..writeln(
        '   File names have to match ${_assetNamePattern.pattern}: lower case '
        'and, once upper cased, a valid Dart identifier.',
      )
      ..writeln('   Rename e.g. `us-in.svg` to `us_in.svg`.');
    exit(1);
  }

  stdout.writeln(
    '🌀 Generating ${svgFiles.length} flag constants from $svgDirPath...',
  );

  final buffer = StringBuffer();
  buffer.writeln('// GENERATED FILE. DO NOT MODIFY BY HAND.');
  buffer.writeln('// Run `dart run tool/generate_flag.dart` to regenerate.');
  // Constant names are upper case on purpose, `Flag.US` reads better than
  // `Flag.us`.
  buffer.writeln('// ignore_for_file: constant_identifier_names\n');
  buffer.writeln('/// List of available flags (ISO codes) for [CircleFlag].');
  buffer.writeln('abstract class Flag {');

  // List of all values
  buffer.writeln('  static const values = <String>[');
  for (final svg in svgFiles) {
    final constName = p.basenameWithoutExtension(svg.path).toUpperCase();
    buffer.writeln('    $constName,');
  }
  buffer.writeln('  ];\n');

  // Constants
  for (final svg in svgFiles) {
    final baseName = p.basenameWithoutExtension(svg.path);
    final constName = baseName.toUpperCase();
    buffer.writeln("  static const String $constName = '$baseName';");
  }

  buffer.writeln('}');

  final outputFile = File(outputFilePath)
    ..createSync(recursive: true)
    ..writeAsStringSync(buffer.toString());

  stdout.writeln('✅ Done! Generated ${outputFile.path}');
}

/// Flag file names that are lower case and, once upper cased, a valid Dart
/// identifier: `us.svg` is exposed as `Flag.US`, `us_in.svg` as `Flag.US_IN`.
final _assetNamePattern = RegExp(r'^[a-z][a-z0-9_]*$');
