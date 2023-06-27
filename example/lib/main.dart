import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
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
  late Future<List<PreloadedFlagLoader>> preloadedLoaders;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isoCodes = IsoCode.values.map((iso) => iso.name);
    preloadedLoaders = Future.wait(
      isoCodes.map((isoCode) => PreloadedFlagLoader.create(isoCode, context)),
    );
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
          future: preloadedLoaders,
          builder: (ctx, snapshot) => snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.requireData.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleFlag.fromLoader(
                        snapshot.requireData[index],
                        size: 32,
                      ),
                      title: Text(IsoCode.values[index].name),
                    ),
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
