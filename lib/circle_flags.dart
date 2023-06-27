library circle_flags;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final double size;
  final BytesLoader loader;

  CircleFlag(String isoCode, {super.key, this.size = 48})
      : loader = FlagLoader(isoCode);

  CircleFlag.fromLoader(this.loader, {super.key, this.size = 48});

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
  final String isoCode;
  FlagLoader(this.isoCode) : super(computeAssetName(isoCode));

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

  Object cacheKey(BuildContext? context) {
    return isoCode;
  }
}

class PreloadedFlagLoader extends FlagLoader {
  final ByteData data;
  PreloadedFlagLoader._(
    super.isoCode,
    this.data,
  );

  @override
  Future<ByteData> loadBytes(BuildContext? context) {
    return SynchronousFuture(data);
  }

  static Future<PreloadedFlagLoader> create(String isoCode) async {
    final assetName = FlagLoader.computeAssetName(isoCode);
    final data = await loadAsset(assetName);
    return PreloadedFlagLoader._(isoCode, data);
  }

  static loadAsset(String assetName, [BuildContext? context]) {
    final bundle = __resolveBundle(context);
    return bundle
        .load(assetName)
        // if any error loading a flag try to show the "?" flag
        .catchError((e) => rootBundle.load(FlagLoader.computeAssetName('xx')));
  }

  static AssetBundle __resolveBundle(BuildContext? context) {
    if (context != null) {
      return DefaultAssetBundle.of(context);
    }
    return rootBundle;
  }
}
