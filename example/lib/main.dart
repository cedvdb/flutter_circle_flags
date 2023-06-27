import 'dart:typed_data';

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
  late Future<List<Uint8List>> preloadedFlags;

  @override
  void initState() {
    super.initState();
    final isoCodes = IsoCode.values.map((iso) => iso.name);
    preloadedFlags = CircleFlag.preload(isoCodes);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
          future: preloadedFlags,
          builder: (ctx, snapshot) => snapshot.hasData
              ? ListView(
                  cacheExtent: 100,
                  children: [
                    for (var isoCode in IsoCode.values)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleFlag(
                            isoCode.name,
                            size: 32,
                          ),
                          title: Text(isoCode.name),
                        ),
                      )
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
