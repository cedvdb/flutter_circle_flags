import 'package:flutter/material.dart';
import 'countries.dart';
import 'package:circle_flags/circle_flags.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          title: Text('flags'),
        ),
        body: Container(
          // child: CircleFlag(
          //   'be',
          //   size: 25,
          // ),
          child: ListView(
            children: [
              for (var country in countries)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleFlag(
                      country.countryCode,
                      size: 32,
                    ),
                    title: Text(country.name),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
