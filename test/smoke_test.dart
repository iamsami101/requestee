import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:requestee/data/app_store.dart';
import 'package:requestee/main.dart';
import 'package:requestee/widgets/shop_card.dart';

void main() {
  testWidgets('full post → match → book → confirm → rate flow', (tester) async {
    final store = AppStore();
    await tester.pumpWidget(RequestTApp(store: store));
    await tester.pumpAndSettle();

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
    await tester.pumpWidget(RequestTApp(store: store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Plumbing'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('Searching nearby'), findsOneWidget);
    await tester.pumpAndSettle();
  });
}
