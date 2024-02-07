import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool preloaded = false;
  bool showFlags = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // preloading flags so they how instantly (mostly useful for web)
    if (!preloaded) {
      CircleFlag.preload(Flags.values);
      preloaded = true;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flags'),
        ),
        body: showFlags
            ? ListView.builder(
                itemCount: Flags.values.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleFlag(
                      Flags.values[index],
                      size: 32,
                    ),
                    title: Text(Flags.values[index]),
                    onTap: () {},
                  ),
                ),
              )
            : Center(
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showFlags = true;
                      });
                    },
                    child: const Text('show')),
              ),
      ),
    );
  }
}
