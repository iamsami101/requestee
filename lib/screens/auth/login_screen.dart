import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/auth_controller.dart';
import '../../services/auth_service.dart';
import '../../theme/adaptive_palette.dart';
import '../../theme/app_colors.dart';
import 'signup_screen.dart';

/// Sign-in entry point. Shown when no session exists (design.md §9 auth).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.auth});

  final AuthController auth;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    try {
      await widget.auth.signInWithEmail(_email.text, _password.text);
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  Future<void> _google() async {
    try {
      await widget.auth.signInWithGoogle();
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  void _goSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SignupScreen(auth: widget.auth)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final palette = context.palette;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                key: const ValueKey('login-form'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'requesT',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.2,
                        color: palette.charcoal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Find a nearby, verified shop that can actually fix it.',
                      textAlign: TextAlign.center,
                      style: text.bodyMedium?.copyWith(color: palette.slate),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _password,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _signIn(),
                    ),
                    const SizedBox(height: 22),
                    ListenableBuilder(
                      listenable: widget.auth,
                      builder: (context, _) {
                        return FilledButton(
                          onPressed: widget.auth.busy ? null : _signIn,
                          child: widget.auth.busy
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Log in'),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    ListenableBuilder(
                      listenable: widget.auth,
                      builder: (context, _) {
                        return OutlinedButton.icon(
                          onPressed: widget.auth.busy ? null : _google,
                          icon: const Text(
                            'G',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.signalCoral,
                            ),
                          ),
                          label: const Text('Continue with Google'),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New here?',
                          style: text.bodyMedium?.copyWith(color: palette.slate),
                        ),
                        TextButton(
                          onPressed: _goSignUp,
                          child: const Text('Create an account'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
