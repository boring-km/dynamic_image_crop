import 'package:flutter_test/flutter_test.dart';

Future<void> waitAndPumpAndSettle(WidgetTester tester, Duration duration) async {
  await tester.runAsync(() async {
    await Future<void>.delayed(duration);
  });

  await tester.pumpAndSettle();
}
