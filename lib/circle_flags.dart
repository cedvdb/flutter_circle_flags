library circle_flags;

import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final String countryCode;
  final double size;

  final Widget Function(BuildContext)? onLoading;

  final Color? placeholderBackgroundColor;
  final Color? placeholderTextColor;

  const CircleFlag(this.countryCode,
      {Key? key,
      this.size = 48,
      this.onLoading,
      this.placeholderBackgroundColor,
      this.placeholderTextColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ScalableImageWidget.fromSISource(
        si: ScalableImageSource.fromSI(
            DefaultAssetBundle.of(context),
            'packages/circle_flags/assets/jovial/${countryCode.toLowerCase()}.si'
        ),
        onLoading: onLoading ?? _buildPlaceholder,
        onError: _buildPlaceholder,
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return _Placeholder(
      size: size,
      countryCode: countryCode,
      backgroundColor: placeholderBackgroundColor,
      textColor: placeholderTextColor,
    );
  }
}

class _Placeholder extends StatelessWidget {
  final double size;
  final String countryCode;
  final Color? backgroundColor;
  final Color? textColor;

  const _Placeholder({Key? key, required this.size, required this.countryCode, this.backgroundColor, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Text(
        countryCode,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor ?? Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}