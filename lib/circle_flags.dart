library circle_flags;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final String countryCode;
  final double? size;
  final String assetName;

  CircleFlag(this.countryCode, {Key? key, this.size})
      : assetName =
            'packages/circle_flags/assets/svg/${countryCode.toLowerCase()}.svg',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? 48;

    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        assetName,
        width: size,
        height: size,
      ),
    );
  }
}
