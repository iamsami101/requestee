import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:requestee/data/app_store.dart';
import 'package:requestee/data/auth_controller.dart';
import 'package:requestee/data/settings_controller.dart';
import 'package:requestee/main.dart';
import 'package:requestee/services/auth_service.dart';
import 'package:requestee/widgets/shop_card.dart';

Future<AuthController> _signedInAuth() async {
  final auth = AuthController(DemoAuthService());
  await auth.restore();
  await auth.signUp('demo@requestee.app', 'password123');
  return auth;
}

Future<void> _pumpApp(WidgetTester tester, AppStore store) async {
  await tester.pumpWidget(
    RequestTApp(
      store: store,
      auth: await _signedInAuth(),
      settings: SettingsController(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('full post → match → book → confirm → rate flow', (tester) async {
    final store = AppStore();
    await _pumpApp(tester, store);

    // Home: type an issue and submit.
    expect(find.text("What's going on?"), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'leaking pipe under sink');
    await tester.tap(find.text('Find help'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Matching screen shows radar pulse while searching.
    expect(find.textContaining('Searching nearby'), findsOneWidget);

    // Let the matching agent finish and the results route settle.
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Results: ranked shop cards with sticky context.
    expect(find.text('Matches'), findsOneWidget);
    expect(find.textContaining('Ranked by reliability'), findsOneWidget);
    expect(find.byType(ShopCard), findsWidgets);

    // Open first shop detail.
    await tester.tap(find.text('Al-Ahmed Plumbing'));
    await tester.pumpAndSettle();
    expect(find.text('Reputation'), findsOneWidget);
    expect(find.text('Reliability score'), findsOneWidget);

    // Book an appointment.
    await tester.tap(find.text('Book\nappointment'));
    await tester.pumpAndSettle();
    expect(find.text('Book an appointment'), findsOneWidget);

    // Pick a slot and confirm.
    await tester.tap(find.text('Today, 4:30 PM'));
    await tester.pump();
    await tester.tap(find.text('Confirm booking'));
    await tester.pumpAndSettle();

    // Confirmation in human voice.
    expect(find.textContaining('Booked with'), findsOneWidget);
    expect(find.textContaining('Booking confirmed'), findsOneWidget);

    // Back to home.
    await tester.tap(find.text('Back to home'));
    await tester.pumpAndSettle();

    // My requests shows the booking.
    await tester.tap(find.text('My requests'));
    await tester.pumpAndSettle();
    expect(find.text('Al-Ahmed Plumbing'), findsWidgets);

    // Mark completed then rate.
    await tester.tap(find.text('Start job'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Complete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rate job'));
    await tester.pumpAndSettle();
    expect(find.text('Rate the job'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.star_outline_rounded).last);
    await tester.pump();
    await tester.tap(find.text('Submit rating'));
    await tester.pumpAndSettle();
    expect(find.textContaining('You rated'), findsOneWidget);
  });

  testWidgets('category tile starts a matching flow', (tester) async {
    final store = AppStore()..matchingDelay = const Duration(milliseconds: 300);
    await _pumpApp(tester, store);

    await tester.tap(find.text('Plumbing'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('Searching nearby'), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets(
    'typed description is classified fresh, ignoring selected category',
    (
      tester,
    ) async {
      final store = AppStore()
        ..matchingDelay = const Duration(milliseconds: 300);
      await _pumpApp(tester, store);

      // Select the Auto Service tile first…
      await tester.ensureVisible(find.text('Auto Service'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Auto Service'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      // …back on home, type a plumbing request. It must NOT be forced into auto.
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // Scroll the lazy ListView back to the top so the TextField is built.
      await tester.drag(find.byType(ListView), const Offset(0, 600));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'leaking pipe under sink');
      await tester.tap(find.text('Find help'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // Results must be plumbing shops — the earlier Auto Service selection
      // must not have leaked into the typed request.
      expect(find.text('Al-Ahmed Plumbing'), findsOneWidget);
    },
  );
}
