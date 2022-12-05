library circle_flags;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jovial_svg/jovial_svg.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final String countryCode;
  final double? size;
  late final String assetName;

  CircleFlag(this.countryCode, {Key? key, this.size}) : super(key: key) {
    assetName =
    'packages/circle_flags/assets/jovial/${countryCode.toLowerCase()}.si';
  }

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? 48;

    return SizedBox(
      width: size,
      height: size,
      child: ScalableImageWidget.fromSISource(
        si: ScalableImageSource.fromSI(rootBundle, assetName),
        onLoading: (context) => _Loading(size: size),
        onError: (context) => _Error(size: size, countryCode: countryCode),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  final double size;

  const _Loading({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(),
    );
  }
}

class _Error extends StatelessWidget {
  final double size;
  final String countryCode;

  const _Error({Key? key, required this.size, required this.countryCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: Text(
        countryCode,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}