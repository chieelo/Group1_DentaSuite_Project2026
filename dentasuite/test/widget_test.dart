
import 'package:flutter_test/flutter_test.dart';
import 'package:dentasuite/main.dart';

void main() {
  testWidgets('DentaSuite app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DentaSuite());

    expect(find.byType(DentaSuite), findsOneWidget);
  });
}
