import 'package:flutter_test/flutter_test.dart';
import 'package:simpro/main.dart';

void main() {
  testWidgets('Auth page loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SimproApp());
    expect(find.text('SIMPRO'), findsWidgets);
  });
}
