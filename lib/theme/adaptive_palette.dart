import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Resolves a semantic color name to the light or dark variant based on the
/// current [Brightness] — see design.md §3 and §4.
///
/// Widgets use `context.palette.signalCoral` etc. so dark mode keeps WCAG-AA
/// contrast without hardcoding light hex values everywhere.
class AppPalette {
  const AppPalette._(this.dark);

  final bool dark;

  // Action / urgency
  Color get signalCoral => dark ? AppColors.coralGlow : AppColors.signalCoral;
  Color get ember => dark ? AppColors.emberDeep : AppColors.ember;
  Color get amber => dark ? AppColors.amberGlow : AppColors.amber;

  // Trust / verified
  Color get deepTeal => dark ? AppColors.tealGlow : AppColors.deepTeal;
  Color get mintWash => dark ? AppColors.tealWash : AppColors.mintWash;

  // Neutrals
  Color get charcoal => dark ? AppColors.offWhite : AppColors.charcoal;
  Color get slate => dark ? AppColors.fog : AppColors.slate;
  Color get paper => dark ? AppColors.nearBlack : AppColors.paper;
  Color get surface => dark ? AppColors.charcoalPanel : AppColors.surface;
  Color get mist => dark ? AppColors.iron : AppColors.mist;

  Color get radarRing => dark ? AppColors.radarRingDark : AppColors.radarRing;
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => AppPalette._(
    Theme.of(this).brightness == Brightness.dark,
  );
}
