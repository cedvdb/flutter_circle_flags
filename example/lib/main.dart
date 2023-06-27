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
  late Future preloading;

  @override
  void initState() {
    super.initState();
    preloading = CircleFlag.preload(IsoCode.values.map((e) => e.name));
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
          future: preloading,
          builder: (ctx, snapshot) => ListView.builder(
            itemCount: IsoCode.values.length,
            itemBuilder: (ctx, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleFlag(
                  IsoCode.values[index].name,
                  size: 32,
                ),
                title: Text(IsoCode.values[index].name),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
