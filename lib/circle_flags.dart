library circle_flags;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final String countryCode;
  final double? size;
  final SvgParser svgParser = SvgParser();
  late final String assetName;

  CircleFlag(this.countryCode, {Key? key, this.size}) : super(key: key) {
    assetName =
    'packages/circle_flags/assets/svg/${countryCode.toLowerCase()}.svg';
  }

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? 48;

    return SizedBox(
      width: size,
      height: size,
      child: FutureBuilder(
        future: _isAssetNameValidSvg(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return SvgPicture.asset(
              assetName,
              width: size,
              height: size,
            );
          }

          if (snapshot.hasError) {
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

          return SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<bool> _isAssetNameValidSvg() async {
    try {
      final svgString = await rootBundle.loadString(assetName);
      await svgParser.parse(svgString);
      return true;
    } catch (e) {
      throw Exception('Error loading asset $assetName');
    }
  }
}