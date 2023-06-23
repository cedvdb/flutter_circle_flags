library circle_flags;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;

/// a rounded flag
class CircleFlag extends StatefulWidget {
  final String isoCode;
  final double size;

  CircleFlag(this.isoCode, {Key? key, this.size = 48}) : super(key: key);

  @override
  State<CircleFlag> createState() => _CircleFlagState();
}

class _CircleFlagState extends State<CircleFlag> {
  late CircleFlagLoader loader;

  @override
  void initState() {
    super.initState();
    loader = CircleFlagLoader(widget.isoCode);
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: SvgPicture(
          loader,
          width: widget.size,
          height: widget.size,
        ),
      ),
    );
  }
}

class CircleFlagLoader extends SvgLoader {
  final String isoCode;
  static final _cache = <String, Future<Uint8List>>{};

  CircleFlagLoader(this.isoCode);

  static load(String countryCode) {
    final url = computeUrl(countryCode);
    _cache[countryCode] =
        http.get(Uri.parse(url)).then((response) => response.bodyBytes);
  }

  static computeUrl(String countryCode) {
    return 'https://hatscripts.github.io/circle-flags/flags/${countryCode.toLowerCase()}.svg';
  }

  @override
  Future<Uint8List?> prepareMessage(BuildContext? context) async {
    if (_cache[isoCode] == null) {
      print('not found');
      load(isoCode);
    }
    return _cache[isoCode];
  }

  @override
  String provideSvg(bytes) {
    return utf8.decode(bytes ?? [], allowMalformed: true);
  }
}
