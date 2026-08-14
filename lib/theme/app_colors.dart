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

  /// Semi-transparent ring color used by the radar pulse.
  static const Color radarRing = Color(0x66FF5A47);
}
