import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:requestee/data/app_store.dart';
import 'package:requestee/data/auth_controller.dart';
import 'package:requestee/data/settings_controller.dart';
import 'package:requestee/main.dart';
import 'package:requestee/services/auth_service.dart';

Future<AuthController> _signedOutAuth() async {
  final auth = AuthController(DemoAuthService());
  await auth.restore();
  return auth;
}

void main() {
  testWidgets('signed out → login screen, demo email sign-in reaches home', (
    tester,
  ) async {
    final store = AppStore();
    await tester.pumpWidget(
      RequestTApp(
        store: store,
        auth: await _signedOutAuth(),
        settings: SettingsController(),
      ),
    );
    await tester.pumpAndSettle();

    // Login screen shown when signed out.
    expect(find.text('requesT'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);

    // Invalid email is rejected with a friendly message.
    await tester.enterText(find.byType(TextField).first, 'not-an-email');
    await tester.enterText(find.byType(TextField).last, 'short');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(find.textContaining("doesn't look right"), findsOneWidget);

    // Valid demo credentials land on home.
    await tester.enterText(
      find.byType(TextField).first,
      'demo@requestee.app',
    );
    await tester.enterText(find.byType(TextField).last, 'password123');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(find.text("What's going on?"), findsOneWidget);
  });

  testWidgets('Google sign-in works in demo mode', (tester) async {
    final store = AppStore();
    await tester.pumpWidget(
      RequestTApp(
        store: store,
        auth: await _signedOutAuth(),
        settings: SettingsController(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    expect(find.text("What's going on?"), findsOneWidget);
  });

  testWidgets(
    'settings shows profile and theme override, sign out returns to login',
    (
      tester,
    ) async {
      final auth = AuthController(DemoAuthService());
      await auth.restore();
      await auth.signUp('demo@requestee.app', 'password123');

      final store = AppStore();
      await tester.pumpWidget(
        RequestTApp(store: store, auth: auth, settings: SettingsController()),
      );
      await tester.pumpAndSettle();

      // Open settings via the profile avatar (initials "D").
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('demo@requestee.app'), findsOneWidget);

      // Switch to dark theme; the ThemeMode override sticks.
      await tester.ensureVisible(find.text('Dark'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, ThemeMode.dark);

      // Sign out lands back on the login screen.
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      expect(find.text('Log in'), findsOneWidget);
    },
  );
}
