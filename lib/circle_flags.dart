library circle_flags;

import 'package:flutter/material.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final String countryCode;
  final double? size;

  CircleFlag(String countryCode, {this.size})
      : countryCode = countryCode.toLowerCase();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/png/$countryCode.png',
        package: 'circle_flags',
      ),
    );
  }
}
