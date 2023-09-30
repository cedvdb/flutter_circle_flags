library builder;

import 'package:build/build.dart';
import 'package:circle_flags/src/builders/flags_builder/flags_file_builder.dart';

import 'flags_builder/assets_to_cache_builder.dart';

Builder assetsToCache([BuilderOptions? options = null]) {
  return AssetToCacheBuilder();
}

Builder combineFlagFile([BuilderOptions? options = null]) {
  return FlagsFileBuilder();
}
