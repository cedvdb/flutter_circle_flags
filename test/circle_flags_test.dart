import 'dart:convert';

import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CircleFlag', () {
    testWidgets('renders the flag as an SvgPicture', (tester) async {
      await tester.pumpWidget(CircleFlag('us'));

      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('resolves flags case insensitively', (tester) async {
      await tester.pumpWidget(CircleFlag('US'));

      final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(
        (picture.bytesLoader as SvgAssetLoader).assetName,
        endsWith('assets/svg/us.svg'),
      );
    });

    testWidgets('clips the flag to a circle by default', (tester) async {
      await tester.pumpWidget(CircleFlag('us'));

      expect(find.byType(ClipPath), findsOneWidget);
    });

    testWidgets('renders a square flag when shape is null', (tester) async {
      await tester.pumpWidget(CircleFlag('us', shape: null));

      expect(find.byType(ClipPath), findsNothing);
    });

    testWidgets('is excluded from semantics by default', (tester) async {
      await tester.pumpWidget(CircleFlag('us'));

      final exclude = tester.widget<ExcludeSemantics>(
        find.descendant(
          of: find.byType(CircleFlag),
          matching: find.byType(ExcludeSemantics),
        ),
      );
      expect(exclude.excluding, isTrue);
    });

    testWidgets('exposes a semantic label when not excluded', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CircleFlag(
            'us',
            excludeFromSemantics: false,
            semanticsLabel: 'United States',
          ),
        ),
      );

      final exclude = tester.widget<ExcludeSemantics>(
        find.descendant(
          of: find.byType(CircleFlag),
          matching: find.byType(ExcludeSemantics),
        ),
      );
      expect(exclude.excluding, isFalse);
      expect(
        tester
            .widgetList<Semantics>(find.byType(Semantics))
            .any((widget) => widget.properties.label == 'United States'),
        isTrue,
      );
    });

    testWidgets('renders every value of Flag', (tester) async {
      for (final isoCode in Flag.values) {
        await tester.pumpWidget(CircleFlag(isoCode));

        expect(find.byType(SvgPicture), findsOneWidget, reason: isoCode);
      }
    });

    testWidgets('falls back to the "?" flag for an unknown code', (
      tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: CircleFlag('zz')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('reuses preloaded flags, regardless of case', (tester) async {
      await CircleFlag.preload(['FR']);
      await tester.pumpWidget(CircleFlag('fr'));

      final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(picture.bytesLoader, isA<SvgBytesLoader>());
    });
  });

  group('Flag', () {
    test('codes are lower case and identifier safe', () {
      // `CircleFlag` lower cases the code it is given before resolving
      // `assets/svg/<code>.svg`, and the generator upper cases the file name
      // into a `Flag` constant, see tool/generate_flag.dart.
      for (final isoCode in Flag.values) {
        expect(isoCode, matches(RegExp(r'^[a-z][a-z0-9_]*$')), reason: isoCode);
      }
    });

    test('constants mirror the code of their asset', () {
      expect(Flag.US, 'us');
      expect(Flag.FR, 'fr');
      expect(Flag.XX, 'xx');
    });
  });

  group('Flag loading', () {
    test('every value of Flag is bundled as an svg', () async {
      for (final isoCode in Flag.values) {
        // Flag assets are lower case, see tool/generate_flag.dart.
        final data = await rootBundle.load(
          'packages/circle_flags/assets/svg/${isoCode.toLowerCase()}.svg',
        );

        expect(data.lengthInBytes, greaterThan(0), reason: isoCode);
      }
    });

    test('an unknown iso code falls back to the "?" flag', () async {
      final unknown = await CircleFlag('zz').loader.loadBytes(null);
      final fallback = await CircleFlag('xx').loader.loadBytes(null);

      expect(
        unknown.buffer.asUint8List(
          unknown.offsetInBytes,
          unknown.lengthInBytes,
        ),
        fallback.buffer.asUint8List(
          fallback.offsetInBytes,
          fallback.lengthInBytes,
        ),
      );
    });

    test('preloads from a custom asset bundle', () async {
      final bundle = _TestAssetBundle({
        'packages/circle_flags/assets/svg/us.svg': _customUsSvg,
      });

      await CircleFlag.preload(['US'], assetBundle: bundle);

      final loader = CircleFlag('us').loader;
      expect(loader, isA<SvgBytesLoader>());
      expect((loader as SvgBytesLoader).bytes, _customUsSvg);
    });
  });
}

/// A minimal square svg, used to prove that a custom asset bundle is read.
final _customUsSvg = Uint8List.fromList(
  utf8.encode(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1">'
    '<rect width="1" height="1"/></svg>',
  ),
);

/// An [AssetBundle] that serves its assets from memory.
class _TestAssetBundle extends CachingAssetBundle {
  _TestAssetBundle(this.assets);

  /// The assets of this bundle, keyed by bundle path.
  final Map<String, Uint8List> assets;

  @override
  Future<ByteData> load(String key) async {
    final bytes = assets[key];
    if (bytes == null) {
      throw FlutterError('Unable to load asset: $key');
    }
    return ByteData.sublistView(bytes);
  }

  @override
  Future<ImmutableBuffer> loadBuffer(String key) async {
    final data = await load(key);
    return ImmutableBuffer.fromUint8List(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
  }
}
