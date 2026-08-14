import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A signed-in user as the rest of the app knows them.
class AuthUser {
  const AuthUser({
    required this.uid,
    required this.provider,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  final String uid;

  /// One of `email`, `google`, `demo`.
  final String provider;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  /// Initials for an avatar fallback when there is no photo.
  String get initials {
    final name = displayName;
    if (name != null && name.trim().isNotEmpty) {
      final parts = name.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    if (email != null && email!.isNotEmpty) return email![0].toUpperCase();
    return 'R';
  }

  AuthUser copyWith({String? displayName, String? photoUrl}) => AuthUser(
    uid: uid,
    provider: provider,
    email: email,
    displayName: displayName ?? this.displayName,
    photoUrl: photoUrl ?? this.photoUrl,
  );
}

/// Thrown for user-facing auth errors (bad email, weak password, offline).
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Auth contract. Implementations: [FirebaseAuthService] (real) and
/// [DemoAuthService] (fallback when no Firebase project is configured).
abstract class AuthService {
  Future<AuthUser?> currentUser();

  Stream<AuthUser?> authStateChanges();

  Future<AuthUser> signInWithEmail(String email, String password);

  Future<AuthUser> signUp(String email, String password);

  Future<AuthUser> signInWithGoogle();

  Future<void> signOut();
}

/// Real Firebase Auth backed implementation.
class FirebaseAuthService implements AuthService {
  FirebaseAuthService({fb.FirebaseAuth? auth})
    : _auth = auth ?? fb.FirebaseAuth.instance;

  final fb.FirebaseAuth _auth;

  @override
  Future<AuthUser?> currentUser() async {
    final user = _auth.currentUser;
    return user == null ? null : _fromFirebase(user);
  }

  @override
  Stream<AuthUser?> authStateChanges() {
    return _auth.authStateChanges().map(
      (u) => u == null ? null : _fromFirebase(u),
    );
  }

  @override
  Future<AuthUser> signInWithEmail(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _fromFirebase(cred.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_friendly(e.code));
    }
  }

  @override
  Future<AuthUser> signUp(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _fromFirebase(cred.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_friendly(e.code));
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AuthException('Google sign-in did not return a token.');
      }
      final cred = fb.GoogleAuthProvider.credential(idToken: idToken);
      final result = await _auth.signInWithCredential(cred);
      return _fromFirebase(result.user!);
    } on MissingPluginException {
      // google_sign_in has no Linux implementation — surface a friendly
      // message so the demo flow can fall back to email sign-in.
      throw const AuthException(
        'Google sign-in is not supported on this platform yet. '
        'Use email sign-in instead.',
      );
    } on UnsupportedError {
      throw const AuthException(
        'Google sign-in is not supported on this platform yet. '
        'Use email sign-in instead.',
      );
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_friendly(e.code));
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await GoogleSignIn.instance.signOut();
    } on MissingPluginException {
      // No-op on platforms without google_sign_in.
    }
  }

  AuthUser _fromFirebase(fb.User u) => AuthUser(
    uid: u.uid,
    provider: u.providerData.isEmpty
        ? 'email'
        : u.providerData.first.providerId,
    email: u.email,
    displayName: u.displayName,
    photoUrl: u.photoURL,
  );

  String _friendly(String code) => switch (code) {
    'invalid-email' => 'That email address doesn\'t look right.',
    'user-not-found' ||
    'wrong-password' ||
    'invalid-credential' => 'Incorrect email or password.',
    'user-disabled' => 'This account has been disabled.',
    'email-already-in-use' => 'An account already exists for that email.',
    'weak-password' => 'Password must be at least 6 characters.',
    'network-request-failed' => 'Network error — check your connection.',
    'too-many-requests' => 'Too many attempts. Try again later.',
    _ => 'Sign-in failed. Please try again.',
  };
}

/// In-memory fallback so the app is usable (and testable) without a Firebase
/// project configured. Accepts any well-formed credentials.
class DemoAuthService implements AuthService {
  DemoAuthService();

  final _controller = StreamController<AuthUser?>.broadcast();
  AuthUser? _user;

  @override
  Future<AuthUser?> currentUser() async => _user;

  @override
  Stream<AuthUser?> authStateChanges() => _controller.stream;

  @override
  Future<AuthUser> signInWithEmail(String email, String password) async {
    final clean = email.trim().toLowerCase();
    if (!clean.contains('@') || !clean.contains('.')) {
      throw const AuthException('That email address doesn\'t look right.');
    }
    if (password.length < 6) {
      throw const AuthException('Password must be at least 6 characters.');
    }
    return _set(
      AuthUser(
        uid: 'demo-$clean',
        provider: 'email',
        email: clean,
        displayName: _nameFromEmail(clean),
      ),
    );
  }

  @override
  Future<AuthUser> signUp(String email, String password) =>
      signInWithEmail(email, password);

  @override
  Future<AuthUser> signInWithGoogle() async {
    return _set(
      const AuthUser(
        uid: 'demo-google',
        provider: 'google',
        email: 'demo@requestee.app',
        displayName: 'Demo Explorer',
      ),
    );
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }

  AuthUser _set(AuthUser user) {
    _user = user;
    _controller.add(user);
    return user;
  }

  String _nameFromEmail(String email) {
    final local = email.split('@').first;
    if (local.contains('.')) {
      return local.split('.').map(_cap).join(' ');
    }
    return _cap(local);
  }

  String _cap(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
