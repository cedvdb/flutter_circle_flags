# circle_flags

A collection of circular country flags optimized for list rendering.

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
CircleFlag('es');

```

# Preloading

To preload flags before displaying a list, `PreloadedFlagLoader` can be used

```dart
    preloadedLoaders = Future.wait(['fr', 'us']
        .map((isoCode) => PreloadedFlagLoader.create(isoCode)));
```
and then used those preloaders can be passed to circle flag

```dart
FutureBuilder(
  future: preloadedLoaders,
  builder: (ctx, snapshot) => snapshot.hasData
      ? ListView.builder(
          itemCount: IsoCode.values.length,
          itemBuilder: (ctx, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleFlag.fromLoader(
                snapshot.requireData[index],
              ),
            ),
          ),
        )
      : const CircularProgressIndicator(),
),
```


# Issues & Contributing

This package uses flags from https://github.com/HatScripts/circle-flags

If a change is required to one of the flag the issue should be opened in that repository.

The icons are converted to an optimized binary format with the [`vector_graphics_compiler`](https://pub.dev/packages/vector_graphics_compiler)
After adding or updating an icon, run the script 
```shell
dart tool/compile_svgs.dart
```
to convert the icon to the `.vec` format.