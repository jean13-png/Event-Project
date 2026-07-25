import 'package:flutter_test/flutter_test.dart';

import 'package:eventbj/app.dart';

void main() {
  testWidgets('EventBJ app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EventBjApp());

    expect(find.text('EventBJ'), findsWidgets);
  });
}
