import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/material.dart';
import 'package:circle_flags/circle_flags.dart';

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
      precacheImage(NetworkImage(CircleFlag.computeUrl(isoCode.name)), context,
          size: const Size(32, 32));
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
