import 'package:flutter_test/flutter_test.dart';
import 'package:event_bj/app.dart';

void main() {
  testWidgets('EventBJ démarre sur Accueil', (tester) async {
    await tester.pumpWidget(const EventBjRoot());
    await tester.pumpAndSettle();

    expect(find.text('EventBJ'), findsWidgets);
    expect(find.text('Accueil'), findsWidgets);
  });
}
