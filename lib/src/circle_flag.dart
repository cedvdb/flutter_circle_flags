import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A flag of a country, rounded by default.
///
/// The first positional argument is the ISO 3166-1 alpha-2 code of the
/// country, either as a plain string or through one of the `Flag` constants:
///
/// ```dart
/// CircleFlag('us');
/// CircleFlag(Flag.US);
/// ```
///
/// Codes are case insensitive, `CircleFlag('US')` and `CircleFlag('us')` show
/// the same flag.
class CircleFlag extends StatelessWidget {
  /// Holds the loaders of the flags that were preloaded through [preload].
  static final _FlagCache _cache = _FlagCache();

  /// The loader used to render the flag.
  final BytesLoader loader;

  /// The width and height of the flag, in logical pixels.
  final double size;

  /// [Clip] option for widget [ClipPath].
  ///
  /// This option have no effect if [shape] == null.
  final Clip clipBehavior;

  /// Clip the flag by [ShapeBorder], default: [CircleBorder].
  ///
  /// If null, return square flag.
  final ShapeBorder? shape;

  /// Whether to hide the flag from assistive technologies, default: true.
  final bool excludeFromSemantics;

  /// The semantic label of the flag, default: null.
  ///
  /// Only used when [excludeFromSemantics] is false.
  final String? semanticsLabel;

  CircleFlag(
    String isoCode, {
    super.key,
    this.size = 48,
    this.shape = const CircleBorder(eccentricity: 0),
    this.clipBehavior = Clip.antiAlias,
    this.excludeFromSemantics = true,
    this.semanticsLabel,
  }) : loader = _createLoader(isoCode);

  /// Normalizes [isoCode] so that `'us'`, `'US'` and `'uS'` refer to the same
  /// asset, the same cached image and the same preloaded loader.
  static String _normalize(String isoCode) => isoCode.toLowerCase();

  /// Returns the preloaded loader of [isoCode] if it was preloaded, a loader
  /// that resolves the flag lazily otherwise.
  static BytesLoader _createLoader(String isoCode) {
    final normalized = _normalize(isoCode);
    return _cache._loaders[normalized] ?? _FlagAssetLoader(normalized);
  }

  /// Preloads the flags of [isoCodes], so that they don't have to be fetched
  /// and decoded on their first paint.
  ///
  /// The flags are read from [assetBundle], or from the [DefaultAssetBundle]
  /// of [context] when there is one, or from [rootBundle] otherwise.
  ///
  /// Completes once every flag has been read from the bundle and decoded.
  ///
  /// ```dart
  /// // preload the flags of the countries of a list
  /// await CircleFlag.preload(countryCodes);
  ///
  /// // preload from an asset bundle of your own
  /// await CircleFlag.preload(['us', 'fr'], assetBundle: myAssetBundle);
  /// ```
  static Future<void> preload(
    Iterable<String> isoCodes, {
    BuildContext? context,
    AssetBundle? assetBundle,
  }) {
    return _cache.preload(
      isoCodes.map(_normalize),
      context: context,
      assetBundle: assetBundle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final svg = SvgPicture(loader, width: size, height: size);

    final clipped = shape == null
        ? svg
        : ClipPath(
            clipper: ShapeBorderClipper(
              shape: shape!,
              textDirection: Directionality.maybeOf(context),
            ),
            clipBehavior: clipBehavior,
            child: svg,
          );

    return ExcludeSemantics(
      excluding: excludeFromSemantics,
      child: semanticsLabel == null
          ? clipped
          : Semantics(image: true, label: semanticsLabel, child: clipped),
    );
  }
}

/// An [SvgAssetLoader] pointing at the flag assets of this package.
///
/// When the requested flag can not be loaded the "?" (`xx`) flag is shown.
class _FlagAssetLoader extends SvgAssetLoader {
  _FlagAssetLoader(this.isoCode) : super(computeAssetName(isoCode));

  /// The normalized (lowercase) ISO code of the flag to display.
  final String isoCode;

  /// The ISO code of the flag shown when [isoCode] can not be loaded.
  static const String fallbackIsoCode = 'xx';

  /// The bundle path of the flag asset of [isoCode].
  static String computeAssetName(String isoCode) =>
      'packages/circle_flags/assets/svg/${isoCode.toLowerCase()}.svg';

  /// Reads the asset at [assetName], falling back to the "?" flag when it can
  /// not be loaded.
  ///
  /// A `try`/`catch` is used instead of `Future.catchError`: the future
  /// returned by `catchError` never completes in the fake async zone that
  /// `testWidgets` runs in, which would make [CircleFlag.preload] impossible to
  /// await from a test.
  static Future<ByteData> loadAsset(
    String assetName, [
    BuildContext? context,
    AssetBundle? assetBundle,
  ]) async {
    final bundle = _resolveBundle(assetBundle, context);
    try {
      return await bundle.load(assetName);
    } catch (_) {
      // if any error loading a flag try to show the "?" flag
      return rootBundle.load(computeAssetName(fallbackIsoCode));
    }
  }

  static AssetBundle _resolveBundle(
    AssetBundle? assetBundle,
    BuildContext? context,
  ) {
    if (assetBundle != null) {
      return assetBundle;
    }
    if (context != null) {
      return DefaultAssetBundle.of(context);
    }
    return rootBundle;
  }

  @override
  Future<ByteData?> prepareMessage(BuildContext? context) {
    return loadAsset(computeAssetName(isoCode), context, assetBundle);
  }

  @override
  SvgCacheKey cacheKey(BuildContext? context) {
    // Key on the flag itself rather than on the resolved asset or the bundle,
    // so that the decoded svg is shared between `'US'`, `'us'` and every
    // asset bundle.
    return SvgCacheKey(
      keyData: 'circle_flags/$isoCode',
      theme: theme,
      colorMapper: colorMapper,
    );
  }
}

/// Caches the loaders of the flags that were preloaded through
/// [CircleFlag.preload].
///
/// Every other flag is loaded lazily by [_FlagAssetLoader], flutter_svg takes
/// care of caching those itself.
class _FlagCache {
  final _loaders = <String, SvgBytesLoader>{};

  /// Reads and decodes every flag of [isoCodes].
  ///
  /// The flags are read from [assetBundle], or from the [DefaultAssetBundle]
  /// of [context] when there is one, or from [rootBundle] otherwise.
  Future<void> preload(
    Iterable<String> isoCodes, {
    BuildContext? context,
    AssetBundle? assetBundle,
  }) async {
    await Future.wait(
      isoCodes.map(
        (isoCode) =>
            _preload(isoCode, context: context, assetBundle: assetBundle),
      ),
    );
  }

  Future<void> _preload(
    String isoCode, {
    BuildContext? context,
    AssetBundle? assetBundle,
  }) async {
    final assetName = _FlagAssetLoader.computeAssetName(isoCode);
    final byteData = await _FlagAssetLoader.loadAsset(
      assetName,
      context,
      assetBundle,
    );
    final loader = SvgBytesLoader(Uint8List.sublistView(byteData));
    // Decoding is the expensive part, take care of it now instead of on the
    // first paint. The context is not passed on: the asset bundle has already
    // been resolved above and the context may be unmounted by the time the read
    // completes.
    await loader.loadBytes(null);
    _loaders[isoCode] = loader;
  }
}
