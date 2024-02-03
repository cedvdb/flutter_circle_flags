library builder;

import 'package:build/build.dart';

import 'src/assets_to_cache_builder.dart';
import 'src/flags_file_builder.dart';

Builder assetsToCache([BuilderOptions? options]) {
  return AssetToCacheBuilder();
}

Builder combineFlagFile([BuilderOptions? options]) {
  return FlagsFileBuilder();
}
