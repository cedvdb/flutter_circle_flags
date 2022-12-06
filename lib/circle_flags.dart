library circle_flags;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:universal_io/io.dart';

/// a rounded flag
class CircleFlag extends StatefulWidget {
  final String countryCode;
  final double? size;
  late final String assetName;

  CircleFlag(this.countryCode, {Key? key, this.size}) : super(key: key) {
    assetName =
        'packages/circle_flags/assets/svg/${countryCode.toLowerCase()}.svg';
  }

  @override
  State<CircleFlag> createState() => _CircleFlagState();

  static String _utf8decode(ByteData data) =>
      utf8.decode(data.buffer.asUint8List());
}

class _CircleFlagState extends State<CircleFlag> {
  final SvgParser svgParser = SvgParser();

  late Future<bool> _future;

  @override
  void initState() {
    _future = _isAssetNameValidSvg();
    super.initState();
  }

  @override
  void dispose() {
    _future.ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = this.widget.size ?? 48;

    return SizedBox(
      width: size,
      height: size,
      child: FutureBuilder(
        future: _future,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return SvgPicture.asset(
              widget.assetName,
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
                widget.countryCode,
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
      // WORKAROUND: `rootBundle.loadString` commented because calling `compute(...)` in test context
      // causes deadlocks in some cases, including usage of CircularProgressIndicator:
      // https://github.com/flutter/flutter/issues/24703

      //await svgParser.parse(await rootBundle.loadString(widget.assetName));
      await svgParser.parse(await _loadString(widget.assetName));

      return true;
    } catch (e) {
      throw Exception('Error loading asset ${widget.assetName}');
    }
  }

  Future<String> _loadString(String key) async {
    final ByteData data = await rootBundle.load(key);

    if (data.lengthInBytes < 50 * 1024) {
      return utf8.decode(data.buffer.asUint8List());
    }

    return _testableCompute(CircleFlag._utf8decode, data,
        debugLabel: 'UTF8 decode for "$key"');
  }

  Future<R> _testableCompute<Q, R>(ComputeCallback<Q, R> callback, Q message,
      {String? debugLabel}) async {
    if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) {
      return await callback(message);
    }
    return await compute(callback, message, debugLabel: debugLabel);
  }
}
