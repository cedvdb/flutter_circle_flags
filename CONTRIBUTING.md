# Contributing

Issues and pull requests are welcome at
<https://github.com/cedvdb/flutter_circle_flags>.

## Setup

- [Flutter](https://docs.flutter.dev/get-started/install): Dart 3.13 / Flutter
  3.47 or newer, see `pubspec.yaml`.
- `flutter pub get`

Before opening a pull request, make sure the following are clean:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

## Project layout

| Path | Description |
| --- | --- |
| `lib/circle_flags.dart` | Public API, exports `CircleFlag` and `Flag` |
| `lib/src/circle_flag.dart` | The `CircleFlag` widget and how it loads its asset |
| `lib/src/flag.dart` | **Generated**, the list of available ISO codes |
| `assets/svg/` | The flags that are bundled with the package and published |
| `assets/svg_hatscripts/` | Pristine upstream [hatscripts/circle-flags][upstream] copy, kept around to curate `assets/svg/` from. Not bundled and not published, see `assets/.pubignore` |
| `tool/generate_flag.dart` | Regenerates `lib/src/flag.dart` from `assets/svg/` |
| `test/` | Test suite, run with `flutter test` |
| `example/` | Small app that uses the package |

[upstream]: https://github.com/hatscripts/circle-flags

## Adding, overriding or removing a flag

`assets/svg/` is the source of truth: every `.svg` file in that directory is
exposed as a `Flag` constant and shipped with the package.

1. Add, replace or delete a file in `assets/svg/`.
2. Regenerate the constants:

   ```bash
   dart run tool/generate_flag.dart
   ```

3. Commit the asset together with the regenerated `lib/src/flag.dart`.

**File name rules.** A flag file name has to be lower case and, once upper
cased, a valid Dart identifier. That is what makes `CircleFlag('us')`,
`CircleFlag('US')` and `Flag.US` resolve the same asset:

| File | Constant | Code |
| --- | --- | --- |
| `us.svg` | `Flag.US` | `'us'` |
| `us_in.svg` | `Flag.US_IN` | `'us_in'` |

Upstream files with a `-` (`us-in.svg`, `gb-con.svg`, language flags such as
`northern_cyprus.svg`) have to be renamed when they are imported into
`assets/svg/`, hence `us-in.svg` becomes `us_in.svg`. The generator refuses to
run on names it cannot turn into a constant, since a `-` would generate invalid
Dart.

`xx.svg` is the fallback that is rendered for unknown codes. Removing a flag is
a breaking change: mention it in `CHANGELOG.md` and bump the major version.

## The generated file

`lib/src/flag.dart` starts with `// GENERATED FILE. DO NOT MODIFY BY HAND.`;
manual edits are overwritten the next time the generator runs. Running the
generator on a clean checkout produces no diff.

## Releasing

1. Bump `version:` in `pubspec.yaml` and add a matching section to
   `CHANGELOG.md`.
2. Run `flutter pub publish --dry-run` and fix anything it reports.
3. Run `flutter pub publish`.

The published archive is built from the files tracked by git, minus what the
ignore files exclude. Never add a `.pubignore` to the repository root: a
`.pubignore` *replaces* the `.gitignore` rules of the directory it is placed in
instead of adding to them, so a root one would start publishing
`example/build/`, `build/` and `*.log`. The `assets/.pubignore` works precisely
because it only overrides the rules of `assets/`.
