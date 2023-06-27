library circle_flags;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final double size;
  final SvgLoader loader;

  CircleFlag(String isoCode, {super.key, this.size = 48})
      : loader = SvgAssetLoader(isoCode);

  CircleFlag.fromLoader(this.loader, {super.key, this.size = 48});

  static Future<List<Uint8List>> preload(Iterable<String> isoCodes) {
    final imagesBytes = <Future<Uint8List>>[];
    // for (final isoCode in isoCodes) {
    //   final assetName = computeAssetName(isoCode);
    //   final loader = SvgAssetLoader(assetName);
    //   svg.cache
    //       .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    // }
    return Future.wait(imagesBytes);
  }

  static Future<List<Uint8List>> preload2(Iterable<String> isoCodes) {
    final imagesBytes = <Future<Uint8List>>[];
    for (final isoCode in isoCodes) {
      final assetName = computeAssetName(isoCode);
      // final bytes = loadAsset(assetName);
      imagesBytes.add(bytes);
    }
    return Future.wait(imagesBytes);
  }

  static String computeAssetName(String isoCode) {
    return 'packages/circle_flags/assets/svg/${isoCode.toLowerCase()}.svg';
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

// library circle_flags;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// /// a rounded flag
// class CircleFlag extends StatelessWidget {
//   final double size;
//   final SvgLoader loader;

//   @Deprecated('use CircleFlag.fromAsset')
//   factory CircleFlag(String isoCode, {Key? key, double size}) =
//       CircleFlag.fromAsset;

//   CircleFlag.fromAsset(String isoCode, {super.key, this.size = 48})
//       : loader = SvgAssetLoader(computeAssetName(isoCode));

//   CircleFlag.fromLoader(this.loader, {super.key, this.size = 48});

//   CircleFlag.fromMemory(Uint8List bytes, {super.key, this.size = 48})
//       : loader = SvgBytesLoader(bytes);

//   static Future<List<Uint8List>> preload(Iterable<String> isoCodes) {
//     final imagesBytes = <Future<Uint8List>>[];
//     for (final isoCode in isoCodes) {
//       final assetName = computeAssetName(isoCode);
//       final loader = SvgAssetLoader(assetName);
//       svg.cache
//           .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
//     }
//     return Future.wait(imagesBytes);
//   }



//   @override
//   Widget build(BuildContext context) {
//     return ClipOval(
//       child: SvgPicture(
//         loader,
//         width: size,
//         height: size,
//       ),
//     );
//   }
// }
