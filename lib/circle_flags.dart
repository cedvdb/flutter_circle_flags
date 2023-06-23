library circle_flags;

import 'package:flutter/material.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final String isoCode;
  final double size;

  CircleFlag(this.isoCode, {Key? key, this.size = 48}) : super(key: key);

  static computeUrl(String isoCode) {
    return 'https://raw.githubusercontent.com/cedvdb/flutter_circle_flags/png_test/assets/${isoCode.toLowerCase()}.png';
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.network(
          computeUrl(isoCode),
          width: size,
          height: size,
        ),
      ),
    );
  }
}
