import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  widget(tester) => MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) {
            return Column(
              children: [
                CircleFlag('US'),
                OutlinedButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('CLICKED'),
                            ),
                          ),
                        ),
                    child: Text('CLICK ME'))
              ],
            );
          }),
        ),
      );

  testWidgets('renders', (tester) async {
    await tester.pumpWidget(CircleFlag('US'));
  });

  group('able to use in complex tests in async and non-async contexts', () {
    stepAsync(tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(widget(tester));
      });

      await tester.runAsync(() async {
        await tester.tap(find.text('CLICK ME'));
      });

      await tester.pumpAndSettle();
    }

    stepSync(tester) async {
      await tester.pumpWidget(widget(tester));
      await tester.tap(find.text('CLICK ME'));
      await tester.pumpAndSettle();
    }

    testWidgets('Async test 1', (tester) async {
      await stepAsync(tester);
      expect(find.text('CLICKED'), findsOneWidget,
          reason: 'OK in first async step');
    });

    testWidgets('Async test 2', (tester) async {
      await stepAsync(tester);
      expect(find.text('CLICKED'), findsOneWidget,
          reason: 'OK in second async step');
    });

    testWidgets('Sync test 1', (tester) async {
      await stepSync(tester);
      expect(find.text('CLICKED'), findsOneWidget,
          reason: 'OK in first sync step');
    });

    testWidgets('Sync test 2', (tester) async {
      await stepSync(tester);
      expect(find.text('CLICKED'), findsOneWidget,
          reason: 'OK in second sync step');
    });
  });
}
