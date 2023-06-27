library circle_flags;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jovial_svg/jovial_svg.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final String countryCode;
  final double size;
  final String assetName;

  CircleFlag(this.countryCode, {Key? key, this.size = 48})
      : assetName = 'assets/si/${countryCode.toLowerCase()}.si',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: size,
        width: size,
        child: ScalableImageWidget.fromSISource(
          si: ScalableImageSource.fromSI(
            rootBundle,
            'packages/circle_flags/$assetName',
          ),
        ),
      ),
    );
  }
}
