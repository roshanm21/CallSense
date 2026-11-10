import 'package:callsense/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('onboarding opens the message scanner',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CallSenseApp(supabaseConfigured: false));

    expect(find.text('Stay one step ahead'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('Check a message'), findsOneWidget);
    expect(find.text('Message text'), findsOneWidget);
  });
}
