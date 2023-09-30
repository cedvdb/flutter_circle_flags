import 'dart:async';

import 'package:build/build.dart';

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

    final outputId = inputId.changeExtension('.part.txt');
    return buildStep.writeAsString(outputId, mapEntry);
  }
}
