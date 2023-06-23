import 'package:flutter/material.dart';
import 'package:circle_flags/circle_flags.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var isoCode in IsoCode.values) {
      CircleFlagLoader.load(isoCode.name);
    }
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
        body: ListView(
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
        ),
      ),
    );
  }
}
