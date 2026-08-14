import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/auth_controller.dart';
import '../data/settings_controller.dart';
import '../services/auth_service.dart';
import '../theme/adaptive_palette.dart';
import '../theme/app_theme.dart';

/// Account + preferences. Reached from the home screen's profile icon.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.auth,
    required this.settings,
  });

  final AuthController auth;
  final SettingsController settings;

  Future<void> _signOut(BuildContext context) async {
    await auth.signOut();
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final palette = context.palette;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: Listenable.merge([auth, settings]),
        builder: (context, _) {
          final user = auth.user;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _ProfileCard(user: user),
              const SizedBox(height: 24),
              Text('Appearance', style: text.titleMedium),
              const SizedBox(height: 8),
              _SectionCard(
                child: _ThemeTile(settings: settings),
              ),
              const SizedBox(height: 24),
              Text('Account', style: text.titleMedium),
              const SizedBox(height: 8),
              _SectionCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.logout_rounded, color: palette.ember),
                  title: Text(
                    'Sign out',
                    style: text.bodyLarge?.copyWith(
                      color: palette.ember,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () => _signOut(context),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'requesT demo build — data stays on this device.',
                textAlign: TextAlign.center,
                style: text.labelMedium?.copyWith(color: palette.slate),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: palette.mist),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: palette.signalCoral,
            foregroundImage:
                (user?.photoUrl != null && user!.photoUrl!.isNotEmpty)
                ? NetworkImage(user!.photoUrl!)
                : null,
            child: Text(
              user?.initials ?? 'R',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? 'Guest',
                  style: text.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  user?.email ?? 'Not signed in',
                  style: text.labelMedium?.copyWith(color: palette.slate),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (user != null) ...[
            const SizedBox(width: 8),
            _ProviderBadge(provider: user!.provider),
          ],
        ],
      ),
    );
  }
}

class _ProviderBadge extends StatelessWidget {
  const _ProviderBadge({required this.provider});

  final String provider;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final palette = context.palette;
    final label = switch (provider) {
      'google' => 'Google',
      'email' => 'Email',
      _ => 'Demo',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: palette.mintWash,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: text.labelSmall?.copyWith(
          color: palette.deepTeal,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        side: BorderSide(color: palette.mist),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: child,
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final palette = context.palette;

    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.dark_mode_outlined, color: palette.charcoal),
            const SizedBox(width: 12),
            Text('Theme', style: text.bodyLarge),
          ],
        ),
        const SizedBox(height: 6),
        RadioGroup<ThemeMode>(
          groupValue: settings.themeMode,
          onChanged: (mode) {
            if (mode != null) settings.setThemeMode(mode);
          },
          child: Column(
            children: [
              for (final (label, mode) in const [
                ('System', ThemeMode.system),
                ('Light', ThemeMode.light),
                ('Dark', ThemeMode.dark),
              ])
                RadioListTile<ThemeMode>(
                  value: mode,
                  title: Text(label, style: text.bodyMedium),
                  contentPadding: EdgeInsets.zero,
                  activeColor: palette.signalCoral,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
