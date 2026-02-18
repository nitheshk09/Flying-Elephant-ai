import 'package:flutter_test/flutter_test.dart';
import 'package:hyderabad_ai_concierge/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: HyderabadAIApp(),
      ),
    );

    // Verify that we start on the Home Screen
    expect(find.text('Hyderabad Concierge'), findsOneWidget);
    expect(find.text('Try searching for:'), findsOneWidget);
  });
}
