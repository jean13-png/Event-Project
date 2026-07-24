import 'package:flutter_test/flutter_test.dart';
import 'package:event_bj/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('EventBJ UI shell se monte', (tester) async {
    // Teste le shell UI sans init Firebase (évite les plugins natifs).
    await tester.pumpWidget(const EventBjApp());
    await tester.pump();

    expect(find.text('EventBJ'), findsWidgets);
  });
}
