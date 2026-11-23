
import 'package:flutter_test/flutter_test.dart';
import 'package:dentasuite/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DentaSuiteApp());

    expect(find.byType(DentaSuiteApp), findsOneWidget);
  });
}
