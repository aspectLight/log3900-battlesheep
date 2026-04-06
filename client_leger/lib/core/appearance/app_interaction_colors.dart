import 'package:flutter/material.dart';

@immutable
class AppInteractionColors extends ThemeExtension<AppInteractionColors> {
  const AppInteractionColors({
    required this.primary,
    required this.primaryStrong,
    required this.outline,
    required this.danger,
    required this.dangerBorder,
    required this.focus,
  });

  final Color primary;
  final Color primaryStrong;
  final Color outline;
  final Color danger;
  final Color dangerBorder;
  final Color focus;

  static const AppInteractionColors defaultPalette = AppInteractionColors(
    primary: Color(0xFF550000),
    primaryStrong: Color(0xFF7F1F1F),
    outline: Color(0xFF7F1F1F),
    danger: Color(0xFF8B0000),
    dangerBorder: Color(0xFFDC3545),
    focus: Color(0xFFC60D0D),
  );

  static const AppInteractionColors frostPalette = AppInteractionColors(
    primary: Color(0xFF0A1420),
    primaryStrong: Color(0xFF060F18),
    outline: Color(0xFF28526E),
    danger: Color(0xFF8B0000),
    dangerBorder: Color(0xFFDC3545),
    focus: Color(0xFF4A9CC4),
  );

  static const AppInteractionColors villagePalette = AppInteractionColors(
    primary: Color(0xFF160E06),
    primaryStrong: Color(0xFF100A04),
    outline: Color(0xFF4A3018),
    danger: Color(0xFF8B0000),
    dangerBorder: Color(0xFFDC3545),
    focus: Color(0xFFC8924A),
  );

  @override
  AppInteractionColors copyWith({
    Color? primary,
    Color? primaryStrong,
    Color? outline,
    Color? danger,
    Color? dangerBorder,
    Color? focus,
  }) {
    return AppInteractionColors(
      primary: primary ?? this.primary,
      primaryStrong: primaryStrong ?? this.primaryStrong,
      outline: outline ?? this.outline,
      danger: danger ?? this.danger,
      dangerBorder: dangerBorder ?? this.dangerBorder,
      focus: focus ?? this.focus,
    );
  }

  @override
  AppInteractionColors lerp(
    ThemeExtension<AppInteractionColors>? other,
    double t,
  ) {
    if (other is! AppInteractionColors) return this;
    return AppInteractionColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryStrong: Color.lerp(primaryStrong, other.primaryStrong, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerBorder: Color.lerp(dangerBorder, other.dangerBorder, t)!,
      focus: Color.lerp(focus, other.focus, t)!,
    );
  }
}

extension AppInteractionColorsContext on BuildContext {
  AppInteractionColors get interactionColors =>
      Theme.of(this).extension<AppInteractionColors>() ??
      AppInteractionColors.defaultPalette;
}
