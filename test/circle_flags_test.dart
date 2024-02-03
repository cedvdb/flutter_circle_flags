import 'package:circle_flags/circle_flags.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders all flags', (tester) async {
    for (final isoCode in Flags.values) {
      await tester.pumpWidget(CircleFlag(isoCode));
    }
  });
}
