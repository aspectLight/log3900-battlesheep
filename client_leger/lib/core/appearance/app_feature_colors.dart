import 'package:flutter/material.dart';

import 'app_visual_theme.dart';

/// Feature UI colors aligned with `client/src/app/styles/themes.scss` CSS variables
/// (`--theme-bg-card`, `--theme-game-bg`, etc.) for waiting room, character creation,
/// game session, and statistics.
@immutable
class AppFeatureColors extends ThemeExtension<AppFeatureColors> {
  const AppFeatureColors({
    required this.panel,
    required this.panelElevated,
    required this.panelInset,
    required this.borderStrong,
    required this.borderHairline,
    required this.textTertiary,
    required this.textSpecial,
    required this.textSpecialAlt,
    required this.textMuted,
    required this.controlFill,
    required this.controlFillSelected,
    required this.controlBorder,
    required this.bgButton,
    required this.bgButtonHover,
    required this.borderButton,
    required this.overlayPanel,
    required this.goldAccent,
    required this.gameFrameBg,
    required this.gameFrameBorder,
    required this.gameAccentText,
    required this.shadowAccent,
  });

  final Color panel;
  final Color panelElevated;
  final Color panelInset;
  final Color borderStrong;
  final Color borderHairline;
  final Color textTertiary;
  final Color textSpecial;
  final Color textSpecialAlt;
  final Color textMuted;
  final Color controlFill;
  final Color controlFillSelected;
  final Color controlBorder;
  final Color bgButton;
  final Color bgButtonHover;
  final Color borderButton;
  final Color overlayPanel;
  final Color goldAccent;
  final Color gameFrameBg;
  final Color gameFrameBorder;
  final Color gameAccentText;
  final Color shadowAccent;

  factory AppFeatureColors.fromVisualTheme(AppVisualTheme visual) {
    switch (visual) {
      case AppVisualTheme.frost:
        return const AppFeatureColors(
          panel: Color(0xFF152535),
          panelElevated: Color(0xFF1C3044),
          panelInset: Color(0xFF0E1C2C),
          borderStrong: Color(0xFF284A6A),
          borderHairline: Color(0xFF1E3858),
          textTertiary: Color(0xFFD0EAF8),
          textSpecial: Color(0xFFA8D4EE),
          textSpecialAlt: Color(0xFFE0F2FF),
          textMuted: Color(0xFF8AB8CC),
          controlFill: Color(0xFF284A6A),
          controlFillSelected: Color(0xFF1C3044),
          controlBorder: Color(0xFF28526E),
          bgButton: Color(0xFF1C3D55),
          bgButtonHover: Color(0xFF28526E),
          borderButton: Color(0xFF28526E),
          overlayPanel: Color(0xE6050F22),
          goldAccent: Color(0xFF88CCE8),
          gameFrameBg: Color(0xFF060F1A),
          gameFrameBorder: Color(0xFF2A5068),
          gameAccentText: Color(0xFF5CB8E0),
          shadowAccent: Color(0x331C3D55),
        );
      case AppVisualTheme.village:
        return const AppFeatureColors(
          panel: Color(0xFF201E17),
          panelElevated: Color(0xFF2A2720),
          panelInset: Color(0xFF161410),
          borderStrong: Color(0xFF383020),
          borderHairline: Color(0xFF2C2818),
          textTertiary: Color(0xFFDDD4AE),
          textSpecial: Color(0xFFC8B47A),
          textSpecialAlt: Color(0xFFEDE4C8),
          textMuted: Color(0xFF968872),
          controlFill: Color(0xFF383020),
          controlFillSelected: Color(0xFF2A2720),
          controlBorder: Color(0xFF624028),
          bgButton: Color(0xFF4A3018),
          bgButtonHover: Color(0xFF624028),
          borderButton: Color(0xFF624028),
          overlayPanel: Color(0xE60E0A04),
          goldAccent: Color(0xFFD4A840),
          gameFrameBg: Color(0xFF100A04),
          gameFrameBorder: Color(0xFF624028),
          gameAccentText: Color(0xFFB89050),
          shadowAccent: Color(0x334A3018),
        );
      case AppVisualTheme.defaultTheme:
        return const AppFeatureColors(
          panel: Color(0xFF2B2B2B),
          panelElevated: Color(0xFF3C3C3C),
          panelInset: Color(0xFF333333),
          borderStrong: Color(0xFF444444),
          borderHairline: Color(0xFF3A3A3A),
          textTertiary: Color(0xFFF5E6E6),
          textSpecial: Color(0xFFE0D8C0),
          textSpecialAlt: Color(0xFFFFF0F0),
          textMuted: Color(0xFFB3B3B3),
          controlFill: Color(0xFF444444),
          controlFillSelected: Color(0xFF3C3C3C),
          controlBorder: Color(0xFF555555),
          bgButton: Color(0xFF550000),
          bgButtonHover: Color(0xFF7F1F1F),
          borderButton: Color(0xFF7F1F1F),
          overlayPanel: Color(0xBF1E0A0A),
          goldAccent: Color(0xFFF5C842),
          gameFrameBg: Color(0xFF2A0E0E),
          gameFrameBorder: Color(0xFF8B5E34),
          gameAccentText: Color(0xFFFF6A6A),
          shadowAccent: Color(0x4D550000),
        );
    }
  }

  static final AppFeatureColors fallback = AppFeatureColors.fromVisualTheme(
    AppVisualTheme.defaultTheme,
  );

  @override
  AppFeatureColors copyWith({
    Color? panel,
    Color? panelElevated,
    Color? panelInset,
    Color? borderStrong,
    Color? borderHairline,
    Color? textTertiary,
    Color? textSpecial,
    Color? textSpecialAlt,
    Color? textMuted,
    Color? controlFill,
    Color? controlFillSelected,
    Color? controlBorder,
    Color? bgButton,
    Color? bgButtonHover,
    Color? borderButton,
    Color? overlayPanel,
    Color? goldAccent,
    Color? gameFrameBg,
    Color? gameFrameBorder,
    Color? gameAccentText,
    Color? shadowAccent,
  }) {
    return AppFeatureColors(
      panel: panel ?? this.panel,
      panelElevated: panelElevated ?? this.panelElevated,
      panelInset: panelInset ?? this.panelInset,
      borderStrong: borderStrong ?? this.borderStrong,
      borderHairline: borderHairline ?? this.borderHairline,
      textTertiary: textTertiary ?? this.textTertiary,
      textSpecial: textSpecial ?? this.textSpecial,
      textSpecialAlt: textSpecialAlt ?? this.textSpecialAlt,
      textMuted: textMuted ?? this.textMuted,
      controlFill: controlFill ?? this.controlFill,
      controlFillSelected: controlFillSelected ?? this.controlFillSelected,
      controlBorder: controlBorder ?? this.controlBorder,
      bgButton: bgButton ?? this.bgButton,
      bgButtonHover: bgButtonHover ?? this.bgButtonHover,
      borderButton: borderButton ?? this.borderButton,
      overlayPanel: overlayPanel ?? this.overlayPanel,
      goldAccent: goldAccent ?? this.goldAccent,
      gameFrameBg: gameFrameBg ?? this.gameFrameBg,
      gameFrameBorder: gameFrameBorder ?? this.gameFrameBorder,
      gameAccentText: gameAccentText ?? this.gameAccentText,
      shadowAccent: shadowAccent ?? this.shadowAccent,
    );
  }

  @override
  AppFeatureColors lerp(ThemeExtension<AppFeatureColors>? other, double t) {
    if (other is! AppFeatureColors) return this;
    return AppFeatureColors(
      panel: Color.lerp(panel, other.panel, t)!,
      panelElevated: Color.lerp(panelElevated, other.panelElevated, t)!,
      panelInset: Color.lerp(panelInset, other.panelInset, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderHairline: Color.lerp(borderHairline, other.borderHairline, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textSpecial: Color.lerp(textSpecial, other.textSpecial, t)!,
      textSpecialAlt: Color.lerp(textSpecialAlt, other.textSpecialAlt, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      controlFill: Color.lerp(controlFill, other.controlFill, t)!,
      controlFillSelected: Color.lerp(
        controlFillSelected,
        other.controlFillSelected,
        t,
      )!,
      controlBorder: Color.lerp(controlBorder, other.controlBorder, t)!,
      bgButton: Color.lerp(bgButton, other.bgButton, t)!,
      bgButtonHover: Color.lerp(bgButtonHover, other.bgButtonHover, t)!,
      borderButton: Color.lerp(borderButton, other.borderButton, t)!,
      overlayPanel: Color.lerp(overlayPanel, other.overlayPanel, t)!,
      goldAccent: Color.lerp(goldAccent, other.goldAccent, t)!,
      gameFrameBg: Color.lerp(gameFrameBg, other.gameFrameBg, t)!,
      gameFrameBorder: Color.lerp(gameFrameBorder, other.gameFrameBorder, t)!,
      gameAccentText: Color.lerp(gameAccentText, other.gameAccentText, t)!,
      shadowAccent: Color.lerp(shadowAccent, other.shadowAccent, t)!,
    );
  }
}

extension AppFeatureColorsContext on BuildContext {
  AppFeatureColors get featureColors =>
      Theme.of(this).extension<AppFeatureColors>() ?? AppFeatureColors.fallback;
}
