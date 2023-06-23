library circle_flags;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// a rounded flag
class CircleFlag extends StatefulWidget {
  final String isoCode;
  final double size;
  final String url;

  CircleFlag(this.isoCode, {Key? key, this.size = 48})
      : url = computeUrl(isoCode),
        super(key: key);

  @override
  State<CircleFlag> createState() => _CircleFlagState();

  static preload(String countryCode) {
    return DefaultCacheManager().getSingleFile(computeUrl(countryCode));
  }

  static computeUrl(String countryCode) {
    return 'https://hatscripts.github.io/circle-flags/flags/${countryCode.toLowerCase()}.svg';
  }
}

class _CircleFlagState extends State<CircleFlag> {
  late FlagLoader loader;

  @override
  void initState() {
    super.initState();
    loader = FlagLoader(widget.url);
  }

  Future<Uint8List> fetchFileContent() async {
    final file = await DefaultCacheManager().getSingleFile(widget.url);
    return file.readAsBytes();
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

class FlagLoader extends SvgLoader {
  final String url;

  FlagLoader(this.url);

  @override
  Future<Uint8List?> prepareMessage(BuildContext? context) async {
    final file = await DefaultCacheManager().getSingleFile(url);
    return file.readAsBytes();
  }

  @override
  String provideSvg(bytes) {
    return utf8.decode(bytes ?? [], allowMalformed: true);
  }
}
