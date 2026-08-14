import 'package:flutter/material.dart';

/// Brand palette for requesT — see design.md §3.
///
/// Two moods: urgency/action (coral family) and trust/calm (teal family).
abstract final class AppColors {
  // Action / urgency
  static const Color signalCoral = Color(0xFFFF5A47);
  static const Color ember = Color(0xFFD6402F);
  static const Color amber = Color(0xFFF2A93B);

  // Trust / verified
  static const Color deepTeal = Color(0xFF0F6B5C);
  static const Color mintWash = Color(0xFFDFF3EE);

  // Neutrals
  static const Color charcoal = Color(0xFF1C1E21);
  static const Color slate = Color(0xFF6B7280);
  static const Color paper = Color(0xFFF7F6F3);
  static const Color surface = Colors.white;
  static const Color mist = Color(0xFFE7E5E1);

  // Dark theme (design.md §4) — desaturated + lightened for AA on Near-Black.
  static const Color coralGlow = Color(0xFFFF7A68);
  static const Color emberDeep = Color(0xFFE0503D);
  static const Color tealGlow = Color(0xFF3FA98D);
  static const Color tealWash = Color(0xFF123A32);
  static const Color offWhite = Color(0xFFF2F1EE);
  static const Color fog = Color(0xFF9CA3AF);
  static const Color nearBlack = Color(0xFF121314);
  static const Color charcoalPanel = Color(0xFF1C1E21);
  static const Color slatePanel = Color(0xFF26282C);
  static const Color amberGlow = Color(0xFFF5BE63);
  static const Color iron = Color(0xFF33353A);

  /// Semi-transparent ring color used by the radar pulse.
  static const Color radarRing = Color(0x66FF5A47);

  /// Dark-mode ring (Coral Glow, translucent) so the pulse reads on near-black.
  static const Color radarRingDark = Color(0x66FF7A68);
}
