import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'data/app_store.dart';
import 'data/auth_controller.dart';
import 'data/settings_controller.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AuthService service;
  try {
    await Firebase.initializeApp();
    service = FirebaseAuthService();
  } catch (_) {
    // No Firebase project configured (no firebase_options.dart /
    // google-services.json) — fall back to the in-memory demo auth so the
    // app stays runnable and testable.
    service = DemoAuthService();
  }

  runApp(
    RequestTApp(
      store: AppStore(),
      auth: AuthController(service)..restore(),
      settings: SettingsController(),
    ),
  );
}

class RequestTApp extends StatelessWidget {
  const RequestTApp({
    super.key,
    required this.store,
    required this.auth,
    required this.settings,
  });

  final AppStore store;
  final AuthController auth;
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        return MaterialApp(
          title: 'requesT',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.themeMode,
          home: AuthGate(store: store, auth: auth, settings: settings),
        );
      },
    );
  }
}

/// Routes to login (signed out) or the app shell (signed in), with a brief
/// splash while the persisted session is restored.
class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.store,
    required this.auth,
    required this.settings,
  });

  final AppStore store;
  final AuthController auth;
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: auth,
      builder: (context, _) {
        return switch (auth.status) {
          AuthStatus.unknown => const _Splash(),
          AuthStatus.signedOut => LoginScreen(auth: auth),
          AuthStatus.signedIn => HomeScreen(
            store: store,
            auth: auth,
            settings: settings,
          ),
        };
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'requesT',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 32,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ],
        ),
      ),
    );
  }
}
