library circle_flags;

import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final String countryCode;
  final double size;
  final String assetName;

  CircleFlag(this.countryCode, {Key? key, this.size = 48})
      : assetName = 'assets/optimized/${countryCode.toLowerCase()}.svg.vec',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: VectorGraphic(
        loader: AssetBytesLoader(assetName, packageName: 'circle_flags'),
        width: size,
        height: size,
      ),
    );
  }
}
