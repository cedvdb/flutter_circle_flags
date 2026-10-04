## [7.0.0]
* [Breaking] removed the public `CircleFlag.cache` field, preloading goes through
  `CircleFlag.preload` instead. `CircleFlag.preload` is now typed `Future<void>`
  (it was untyped) and accepts an optional `context`/`assetBundle` to preload
  from another asset bundle
* iso codes are now case insensitive, `CircleFlag('US')` shows the same flag as
  `CircleFlag('us')` and `CircleFlag.preload(['US'])` preloads that same flag
* added `excludeFromSemantics` and `semanticsLabel` options
* the "?" fallback of unknown flags no longer relies on `Future.catchError`,
  which never completes inside the fake async zone of widget tests
* a flag is cached under a package namespaced svg cache key, so the decoded flag
  can not collide with the svg cache key of another loader
* added analysis_options.yaml and extended the test suite
* moved the flag generator to `tool/generate_flag.dart` (pub layout convention)
* the flag generator now refuses flag file names that can not be exposed as a
  `Flag` constant, see CONTRIBUTING.md
* added CONTRIBUTING.md, it documents how flags are added and regenerated
* the `assets/svg_hatscripts` working copy is no longer published, see
  `assets/.pubignore`
* removed the unused `build_runner` dev dependency

## [6.0.0]
* upgrade to material_ui

## [5.0.1]
* Fix for build runner issue

## [5.0.0]
* Use latest files from hatscripts
* Remove unnecessary files 
* Add note in readme on how to add your own flags
* [Breaking] renamed Flags in Flag

## [4.0.2]
* Exclude from semantics

## [4.0.1]
* Accept iterable in preloading method

## [4.0.0]
* [Breaking] Use `CircleFlag.preload([isoCode])` to preload a flag. FlagCache is no longer exported. 

## [3.0.1]
* made it easier to use cache, some breaking changes to just introduced cache api
  (doesn't warrant upgrade due to it just being introduced)

## [3.0.0]

* unknown flags display "?"
* revert to assets with preloading mechanism
* allow usage of other asset bundles

## [2.0.9]
* recreate loader when iso code changes

## [2.0.8]
* Change just introduced caching api

## [2.0.7]
* Fix issue with network flags not correctly loaded
* improve caching

## [2.0.0]

* use network image to reduce size
* added ability to preload images

## [1.0.4]

* increase `package:flutter_svg` version
* fix redering issue on some platforms

## [1.0.3]

* (Re)-added netherlands antilla's flag

## [1.0.2]

* add clipOval around flag for better rendering of svgs on the web

## [1.0.1]

* use sensible defaults for svgs placeholders

## [1.0.0]

* use svg for smaller memory footprint

## [0.0.3]

* added 3 missing flags

## [0.0.2]

* fix casing problems in country code

## [0.0.1] - 22/03/2021

* initial release
