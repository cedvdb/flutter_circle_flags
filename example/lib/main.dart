import 'package:flutter/material.dart';
import 'package:circle_flags/circle_flags.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future<List<ScalableImage>> preloadedImages;

  @override
  void initState() {
    super.initState();
    final isoCodes = IsoCode.values.map((isoCode) => isoCode.name);
    preloadedImages = CircleFlag.preload(isoCodes);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const isoCodes = IsoCode.values;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flags'),
        ),
        body: FutureBuilder(
            future: preloadedImages,
            builder: (ctx, snap) {
              return snap.hasData
                  ? ListView.builder(
                      itemCount: snap.requireData.length,
                      itemBuilder: (ctx, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleFlag.fromPreloadedImage(
                            snap.requireData[index],
                            size: 32,
                          ),
                          title: Text(isoCodes[index].name),
                        ),
                      ),
                    )
                  : const CircularProgressIndicator();
            }),
      ),
    );
  }
}
