library circle_flags;

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// a rounded flag
class CircleFlag extends StatefulWidget {
  final String countryCode;
  final double size;
  final String url;

  CircleFlag(this.countryCode, {Key? key, this.size = 48})
      : url =
            'https://hatscripts.github.io/circle-flags/flags/${countryCode.toLowerCase()}.svg',
        super(key: key);

  @override
  State<CircleFlag> createState() => _CircleFlagState();

  static preloadMany(Iterable<String> countryCodes) {
    return countryCodes.map((code) => CircleFlag.preload(code));
  }

  static preload(String countryCode) {
    return DefaultCacheManager().getSingleFile(countryCode);
  }
}

class _CircleFlagState extends State<CircleFlag> {
  late Future<File> fileFuture;

  @override
  void initState() {
    fileFuture = DefaultCacheManager().getSingleFile(widget.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: FutureBuilder<File>(
          future: fileFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SvgPicture.file(
                snapshot.requireData,
                width: widget.size,
                height: widget.size,
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
