library circle_flags;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jovial_svg/jovial_svg.dart';

export 'package:jovial_svg/jovial_svg.dart' show ScalableImage;

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final double size;
  final String? assetName;
  final ScalableImage? scalableImage;

  CircleFlag(String isoCode, {super.key, this.size = 48})
      : assetName = 'assets/si/${isoCode.toLowerCase()}.si',
        scalableImage = null;

  CircleFlag.fromPreloadedImage(this.scalableImage, {super.key, this.size = 48})
      : assetName = null;

  static Future<List<ScalableImage>> preload(Iterable<String> isoCodes) {
    final imagesFuture = isoCodes.map(
      (isoCode) => ScalableImage.fromSIAsset(
        rootBundle,
        'packages/circle_flags/assets/si/${isoCode.toLowerCase()}.si',
      ),
    );
    return Future.wait(imagesFuture);
  }

  @override
  Widget build(BuildContext context) {
    final scalableImage = this.scalableImage;
    return ClipOval(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: size,
        width: size,
        child: RepaintBoundary(
          child: scalableImage != null
              ? ScalableImageWidget(si: scalableImage)
              : ScalableImageWidget.fromSISource(
                  si: ScalableImageSource.fromSI(
                    rootBundle,
                    'packages/circle_flags/$assetName',
                  ),
                ),
        ),
      ),
    );
  }
}
