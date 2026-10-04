# circle_flags

A collection of circular country flags. 

## Demo

to view all flags https://hatscripts.github.io/circle-flags/gallery

<img src="https://hatscripts.github.io/circle-flags/flags/br.svg" width="48">
<img src="https://hatscripts.github.io/circle-flags/flags/cn.svg" width="48">
<img src="https://hatscripts.github.io/circle-flags/flags/gb.svg" width="48">
<img src="https://hatscripts.github.io/circle-flags/flags/id.svg" width="48">
<img src="https://hatscripts.github.io/circle-flags/flags/in.svg" width="48">
<img src="https://hatscripts.github.io/circle-flags/flags/ng.svg" width="48">
<img src="https://hatscripts.github.io/circle-flags/flags/ru.svg" width="48">
<img src="https://hatscripts.github.io/circle-flags/flags/us.svg" width="48">

## Usage

```dart

// use a valid country code
CircleFlag('us');
CircleFlag('fr');
CircleFlag(Flag.US);
```

# Preloading

You might want to preload images for a smoother list scrolling experience:

```dart
CircleFlag.preload(['fr', 'us']);

// or await it to know when the flags are ready to be painted
await CircleFlag.preload(Flag.values);
```

Flags are read from the `DefaultAssetBundle` of the given `context`, or from
`rootBundle` when there is none. To preload from a bundle of your own, pass it:

```dart
await CircleFlag.preload(['fr', 'us'], assetBundle: myAssetBundle);
```

Iso codes are case insensitive, `'us'`, `'US'` and `Flag.US` all show the same
flag.

# Overwriting or adding custom flags

Some users have expressed their need to change some flags due to political reasons, or stylistic reasons. You might also wish to add your own flags. To do so refer to this issue: https://github.com/cedvdb/phone_form_field/issues/222

# Contributing & issues

Bugs and feature requests go to <https://github.com/cedvdb/flutter_circle_flags/issues>,
see [CONTRIBUTING.md](CONTRIBUTING.md) for how to set up the project, run the
checks and release.

Flags live in `assets/svg/`, one `<code>.svg` file per flag; that directory is
the source of truth and `lib/src/flag.dart` is generated from it. Never edit
`lib/src/flag.dart` by hand, instead add or change the asset and run:

```bash
dart run tool/generate_flag.dart
```
