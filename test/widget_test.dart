import 'package:flutter_test/flutter_test.dart';

import 'package:mymood/app.dart';

void main() {
  testWidgets('MyMood app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyMoodApp());

    expect(find.text('MyMood'), findsWidgets);
  });
}
