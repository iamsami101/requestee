import 'dart:async';

import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

enum AuthStatus {
  /// Still resolving the persisted session on startup.
  unknown,
  signedOut,
  signedIn,
}

/// Holds the current auth session and exposes async actions to the UI.
class AuthController extends ChangeNotifier {
  AuthController(this._service) {
    _sub = _service.authStateChanges().listen((user) {
      _user = user;
      _status = user == null ? AuthStatus.signedOut : AuthStatus.signedIn;
      notifyListeners();
    });
  }

  final AuthService _service;
  late final StreamSubscription<dynamic> _sub;

  AuthUser? _user;
  AuthStatus _status = AuthStatus.unknown;
  bool _busy = false;

  AuthService get service => _service;
  AuthUser? get user => _user;
  AuthStatus get status => _status;
  bool get isSignedIn => _status == AuthStatus.signedIn;
  bool get busy => _busy;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  /// Checks for an existing session (called once at startup).
  Future<void> restore() async {
    final user = await _service.currentUser();
    _user = user;
    _status = user == null ? AuthStatus.signedOut : AuthStatus.signedIn;
    notifyListeners();
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    _busy = true;
    notifyListeners();
    try {
      await action();
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> signInWithEmail(String email, String password) {
    return _run(() => _service.signInWithEmail(email, password));
  }

  Future<void> signUp(String email, String password) {
    return _run(() => _service.signUp(email, password));
  }

  Future<void> signInWithGoogle() {
    return _run(() => _service.signInWithGoogle());
  }

  Future<void> signOut() {
    return _run(() => _service.signOut());
  }
}
