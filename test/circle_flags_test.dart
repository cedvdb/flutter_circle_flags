import 'package:circle_flags/circle_flags.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders', (tester) async {
    await tester.pumpWidget(CircleFlag('US'));
  });
}
