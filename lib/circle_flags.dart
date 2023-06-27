library circle_flags;

import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final String isoCode;
  final double size;
  final String assetName;

  CircleFlag(this.isoCode, {super.key, this.size = 48})
      : assetName =
            'packages/circle_flags/assets/optimized/${isoCode.toLowerCase()}.svg.vec';

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: VectorGraphic(
        loader: AssetBytesLoader(assetName),
        width: size,
        height: size,
      ),
    );
  }
}
