library circle_flags;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final BytesLoader loader;
  final double size;

  CircleFlag(String isoCode, {super.key, this.size = 48})
      : loader = FlagLoader(isoCode);

  CircleFlag.fromLoader(this.loader, {super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SvgPicture(
        loader,
        width: size,
        height: size,
      ),
    );
  }
}

class FlagLoader extends SvgAssetLoader {
  final String isoCode;
  FlagLoader(this.isoCode, {super.assetBundle})
      : super(computeAssetName(isoCode));

  static String computeAssetName(String isoCode) {
    return 'packages/circle_flags/assets/svg/${isoCode.toLowerCase()}.svg';
  }

  static Future<ByteData> loadAsset(String assetName,
      [BuildContext? context, AssetBundle? assetBundle]) {
    final bundle = FlagLoader._resolveBundle(assetBundle, context);
    return bundle
        .load(assetName)
        // if any error loading a flag try to show the "?" flag
        .catchError((e) => rootBundle.load(FlagLoader.computeAssetName('xx')));
  }

  static AssetBundle _resolveBundle(
      AssetBundle? assetBundle, BuildContext? context) {
    if (assetBundle != null) {
      return assetBundle;
    }
    if (context != null) {
      return DefaultAssetBundle.of(context);
    }
    return rootBundle;
  }

  @override
  Future<ByteData?> prepareMessage(BuildContext? context) {
    final bundle = _resolveBundle(assetBundle, context);
    return bundle
        .load(computeAssetName(isoCode))
        // load "?" on error
        .catchError((e) => bundle.load(computeAssetName('xx')));
  }

  @override
  String provideSvg(ByteData? message) =>
      utf8.decode(message!.buffer.asUint8List(), allowMalformed: true);
}

class PreloadedFlagLoader extends SvgBytesLoader {
  PreloadedFlagLoader._(
    super.bytes,
  );

  static Future<PreloadedFlagLoader> create(String isoCode,
      [BuildContext? context, AssetBundle? assetBundle]) async {
    final assetName = FlagLoader.computeAssetName(isoCode);
    final byteData =
        await FlagLoader.loadAsset(assetName, context, assetBundle);
    final loader = PreloadedFlagLoader._(Uint8List.sublistView(byteData));

    return loader;
  }
}
