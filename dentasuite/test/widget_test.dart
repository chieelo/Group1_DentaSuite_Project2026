
import 'package:flutter_test/flutter_test.dart';
import 'package:dentasuite/main.dart';

void main() {
<<<<<<< HEAD
  testWidgets('DentaSuite app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DentaSuite());
=======
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DentaSuiteApp());
>>>>>>> d1684099a4346b80290548f7a934617f60adf2f7

    expect(find.byType(DentaSuite), findsOneWidget);
  });
}
