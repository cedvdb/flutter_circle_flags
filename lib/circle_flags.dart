library circle_flags;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final double size;
  final BytesLoader loader;

  CircleFlag(String isoCode, {super.key, this.size = 48})
      : loader = FlagLoader(isoCode);

  CircleFlag.fromLoader(this.loader, {super.key, this.size = 48});

  static Future<List<Uint8List>> preload2(Iterable<String> isoCodes) {
    final imagesBytes = <Future<Uint8List>>[];
    for (final isoCode in isoCodes) {
      final assetName = computeAssetName(isoCode);
      final bytes = loadAsset(assetName);
      imagesBytes.add(bytes);
    }
    return Future.wait(imagesBytes);
  }

  static loadAsset(String assetName) {
    return rootBundle
        .load(assetName)
        .then((data) => Uint8List.sublistView(data))
        // on error try to use the question mark flag
        .catchError((e) => rootBundle
            .load(computeAssetName('xx'))
            .then((data) => Uint8List.sublistView(data)));
  }

  static String computeAssetName(String isoCode) {
    return 'packages/circle_flags/assets/optimized/${isoCode.toLowerCase()}.svg.vec';
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: VectorGraphic(
        loader: loader,
        width: size,
        height: size,
      ),
    );
  }
}

class FlagLoader extends AssetBytesLoader {
  FlagLoader(String isoCode) : super(computeAssetName(isoCode));

  static String computeAssetName(String isoCode) {
    return 'packages/circle_flags/assets/optimized/${isoCode.toLowerCase()}.svg.vec';
  }

  @override
  Future<ByteData> loadBytes(BuildContext? context) {
    return _resolveBundle(context)
        .load(assetName)
        // if any error loading a flag try to show the "?" flag
        .catchError(
            (e) => _resolveBundle(context).load(computeAssetName('xx')));
  }

  AssetBundle _resolveBundle(BuildContext? context) {
    if (assetBundle != null) {
      return assetBundle!;
    }
    if (context != null) {
      return DefaultAssetBundle.of(context);
    }
    return rootBundle;
  }
}
