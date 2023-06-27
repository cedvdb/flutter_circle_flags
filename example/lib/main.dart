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
  late final FlagCache _cache = FlagCache();
  late Future<void> preloading;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isoCodes = IsoCode.values.map((iso) => iso.name);
    preloading = _cache.preload(isoCodes);
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
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.done
                  ? ListView.builder(
                      itemCount: IsoCode.values.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleFlag(
                            IsoCode.values[index].name,
                            size: 32,
                            cache: _cache,
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
