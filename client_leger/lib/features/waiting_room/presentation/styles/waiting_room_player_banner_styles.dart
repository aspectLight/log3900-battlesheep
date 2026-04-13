import 'package:flutter/material.dart';

import '../../core/constants/waiting_room_player_banner_shadows.dart';
import '../../core/constants/waiting_room_player_banner_tokens.dart';

WaitingRoomBannerTheme? waitingRoomBannerTheme(String? activeBanner) {
  return switch (activeBanner) {
    WaitingRoomPlayerBannerTokens.bannerIdGold => WaitingRoomBannerTheme.gold,
    WaitingRoomPlayerBannerTokens.bannerIdShadow => WaitingRoomBannerTheme.shadow,
    WaitingRoomPlayerBannerTokens.bannerIdFlame => WaitingRoomBannerTheme.flame,
    WaitingRoomPlayerBannerTokens.bannerIdIce => WaitingRoomBannerTheme.ice,
    WaitingRoomPlayerBannerTokens.bannerIdNeon => WaitingRoomBannerTheme.neon,
    _ => null,
  };
}

BoxDecoration waitingRoomPlayerCardDefaultOuterDecoration() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(WaitingRoomPlayerBannerTokens.playerCardBorderRadius),
    ),
    boxShadow: [WaitingRoomPlayerBannerShadows.floorSoft],
  );
}

class _PulseShadowPair {
  const _PulseShadowPair({required this.min, required this.max});
  final List<BoxShadow> min;
  final List<BoxShadow> max;
}

_PulseShadowPair _pulsePair({
  required Color innerMin,
  required double innerBlurMin,
  required Color outerMin,
  required double outerBlurMin,
  required Color innerMax,
  required double innerBlurMax,
  required Color outerMax,
  required double outerBlurMax,
  BoxShadow? floorMin,
  BoxShadow? floorMax,
}) {
  return _PulseShadowPair(
    min: [
      BoxShadow(color: innerMin, blurRadius: innerBlurMin),
      BoxShadow(color: outerMin, blurRadius: outerBlurMin),
      floorMin ?? WaitingRoomPlayerBannerShadows.floorSoft,
    ],
    max: [
      BoxShadow(color: innerMax, blurRadius: innerBlurMax),
      BoxShadow(color: outerMax, blurRadius: outerBlurMax),
      floorMax ?? WaitingRoomPlayerBannerShadows.dropStrong,
    ],
  );
}

final _pulseGold = _pulsePair(
  innerMin: WaitingRoomPlayerBannerTokens.goldPulseInnerMin,
  innerBlurMin: WaitingRoomPlayerBannerTokens.goldPulseInnerBlurMin,
  outerMin: WaitingRoomPlayerBannerTokens.goldPulseOuterMin,
  outerBlurMin: WaitingRoomPlayerBannerTokens.goldPulseOuterBlurMin,
  innerMax: WaitingRoomPlayerBannerTokens.goldPulseInnerMax,
  innerBlurMax: WaitingRoomPlayerBannerTokens.goldPulseInnerBlurMax,
  outerMax: WaitingRoomPlayerBannerTokens.goldPulseOuterMax,
  outerBlurMax: WaitingRoomPlayerBannerTokens.goldPulseOuterBlurMax,
);

final _pulseShadow = _pulsePair(
  innerMin: WaitingRoomPlayerBannerTokens.shadowPulseInnerMin,
  innerBlurMin: WaitingRoomPlayerBannerTokens.shadowPulseInnerBlurMin,
  outerMin: WaitingRoomPlayerBannerTokens.shadowPulseOuterMin,
  outerBlurMin: WaitingRoomPlayerBannerTokens.shadowPulseOuterBlurMin,
  innerMax: WaitingRoomPlayerBannerTokens.shadowPulseInnerMax,
  innerBlurMax: WaitingRoomPlayerBannerTokens.shadowPulseInnerBlurMax,
  outerMax: WaitingRoomPlayerBannerTokens.shadowPulseOuterMax,
  outerBlurMax: WaitingRoomPlayerBannerTokens.shadowPulseOuterBlurMax,
  floorMin: WaitingRoomPlayerBannerShadows.shadowMistFloorSoft,
  floorMax: WaitingRoomPlayerBannerShadows.shadowMistFloorStrong,
);

final _pulseFlame = _pulsePair(
  innerMin: WaitingRoomPlayerBannerTokens.flamePulseInnerMin,
  innerBlurMin: WaitingRoomPlayerBannerTokens.flamePulseInnerBlurMin,
  outerMin: WaitingRoomPlayerBannerTokens.flamePulseOuterMin,
  outerBlurMin: WaitingRoomPlayerBannerTokens.flamePulseOuterBlurMin,
  innerMax: WaitingRoomPlayerBannerTokens.flamePulseInnerMax,
  innerBlurMax: WaitingRoomPlayerBannerTokens.flamePulseInnerBlurMax,
  outerMax: WaitingRoomPlayerBannerTokens.flamePulseOuterMax,
  outerBlurMax: WaitingRoomPlayerBannerTokens.flamePulseOuterBlurMax,
);

final _pulseIce = _pulsePair(
  innerMin: WaitingRoomPlayerBannerTokens.icePulseInnerMin,
  innerBlurMin: WaitingRoomPlayerBannerTokens.icePulseInnerBlurMin,
  outerMin: WaitingRoomPlayerBannerTokens.icePulseOuterMin,
  outerBlurMin: WaitingRoomPlayerBannerTokens.icePulseOuterBlurMin,
  innerMax: WaitingRoomPlayerBannerTokens.icePulseInnerMax,
  innerBlurMax: WaitingRoomPlayerBannerTokens.icePulseInnerBlurMax,
  outerMax: WaitingRoomPlayerBannerTokens.icePulseOuterMax,
  outerBlurMax: WaitingRoomPlayerBannerTokens.icePulseOuterBlurMax,
);

final _pulseNeon = _pulsePair(
  innerMin: WaitingRoomPlayerBannerTokens.neonPulseInnerMin,
  innerBlurMin: WaitingRoomPlayerBannerTokens.neonPulseInnerBlurMin,
  outerMin: WaitingRoomPlayerBannerTokens.neonPulseOuterMin,
  outerBlurMin: WaitingRoomPlayerBannerTokens.neonPulseOuterBlurMin,
  innerMax: WaitingRoomPlayerBannerTokens.neonPulseInnerMax,
  innerBlurMax: WaitingRoomPlayerBannerTokens.neonPulseInnerBlurMax,
  outerMax: WaitingRoomPlayerBannerTokens.neonPulseOuterMax,
  outerBlurMax: WaitingRoomPlayerBannerTokens.neonPulseOuterBlurMax,
);

class WaitingRoomBannerTheme {
  const WaitingRoomBannerTheme({
    required this.borderGradientColors,
    required this.borderShiftDuration,
    required this.pulseMinShadows,
    required this.pulseMaxShadows,
    required this.pulseDuration,
    this.borderPingPong = true,
    this.innerEdgeBorderColor,
    required this.div1Gradient,
    required this.div2Gradient,
    required this.statsGradient,
    this.nameColor,
    this.nameShadows,
    this.statLabelColor,
    this.statValueColor,
    this.overlay,
  });

  final List<Color> borderGradientColors;
  final Duration borderShiftDuration;
  final List<BoxShadow> pulseMinShadows;
  final List<BoxShadow> pulseMaxShadows;
  final Duration pulseDuration;
  final bool borderPingPong;
  final Color? innerEdgeBorderColor;
  final Gradient div1Gradient;
  final Gradient div2Gradient;
  final Gradient statsGradient;
  final Color? nameColor;
  final List<Shadow>? nameShadows;
  final Color? statLabelColor;
  final Color? statValueColor;
  final WaitingRoomBannerOverlaySpec? overlay;

  static final gold = WaitingRoomBannerTheme(
    borderGradientColors: WaitingRoomPlayerBannerTokens.goldBorderColors,
    borderShiftDuration: WaitingRoomPlayerBannerTokens.goldBorderShift,
    pulseMinShadows: _pulseGold.min,
    pulseMaxShadows: _pulseGold.max,
    pulseDuration: WaitingRoomPlayerBannerTokens.goldPulse,
    div1Gradient: WaitingRoomPlayerBannerTokens.goldDiv1,
    div2Gradient: WaitingRoomPlayerBannerTokens.goldDiv2,
    statsGradient: WaitingRoomPlayerBannerTokens.goldStats,
    nameShadows: WaitingRoomPlayerBannerTokens.goldNameShadows,
    overlay: const WaitingRoomBannerOverlaySpec(
      type: WaitingRoomBannerOverlayType.goldShimmer,
      animationDuration: WaitingRoomPlayerBannerTokens.goldOverlay,
    ),
  );

  static final shadow = WaitingRoomBannerTheme(
    borderGradientColors: WaitingRoomPlayerBannerTokens.shadowBorderColors,
    borderShiftDuration: WaitingRoomPlayerBannerTokens.shadowBorderShift,
    pulseMinShadows: _pulseShadow.min,
    pulseMaxShadows: _pulseShadow.max,
    pulseDuration: WaitingRoomPlayerBannerTokens.shadowPulse,
    innerEdgeBorderColor: WaitingRoomPlayerBannerTokens.shadowInnerEdge,
    div1Gradient: WaitingRoomPlayerBannerTokens.shadowDiv1,
    div2Gradient: WaitingRoomPlayerBannerTokens.shadowDiv2,
    statsGradient: WaitingRoomPlayerBannerTokens.shadowStats,
    nameColor: WaitingRoomPlayerBannerTokens.shadowName,
    nameShadows: WaitingRoomPlayerBannerTokens.shadowNameShadows,
    statLabelColor: WaitingRoomPlayerBannerTokens.shadowStatLabel,
    statValueColor: WaitingRoomPlayerBannerTokens.shadowStatValue,
    overlay: const WaitingRoomBannerOverlaySpec(
      type: WaitingRoomBannerOverlayType.shadowMist,
      animationDuration: WaitingRoomPlayerBannerTokens.shadowOverlay,
    ),
  );

  static final flame = WaitingRoomBannerTheme(
    borderGradientColors: WaitingRoomPlayerBannerTokens.flameBorderColors,
    borderShiftDuration: WaitingRoomPlayerBannerTokens.flameBorderShift,
    pulseMinShadows: _pulseFlame.min,
    pulseMaxShadows: _pulseFlame.max,
    pulseDuration: WaitingRoomPlayerBannerTokens.flamePulse,
    div1Gradient: WaitingRoomPlayerBannerTokens.flameDiv1,
    div2Gradient: WaitingRoomPlayerBannerTokens.flameDiv2,
    statsGradient: WaitingRoomPlayerBannerTokens.flameStats,
    nameShadows: WaitingRoomPlayerBannerTokens.flameNameShadows,
    overlay: const WaitingRoomBannerOverlaySpec(
      type: WaitingRoomBannerOverlayType.flameGlow,
      animationDuration: WaitingRoomPlayerBannerTokens.flameOverlay,
    ),
  );

  static final ice = WaitingRoomBannerTheme(
    borderGradientColors: WaitingRoomPlayerBannerTokens.iceBorderColors,
    borderShiftDuration: WaitingRoomPlayerBannerTokens.iceBorderShift,
    pulseMinShadows: _pulseIce.min,
    pulseMaxShadows: _pulseIce.max,
    pulseDuration: WaitingRoomPlayerBannerTokens.icePulse,
    div1Gradient: WaitingRoomPlayerBannerTokens.iceDiv1,
    div2Gradient: WaitingRoomPlayerBannerTokens.iceDiv2,
    statsGradient: WaitingRoomPlayerBannerTokens.iceStats,
    nameColor: WaitingRoomPlayerBannerTokens.iceName,
    nameShadows: WaitingRoomPlayerBannerTokens.iceNameShadows,
    statLabelColor: WaitingRoomPlayerBannerTokens.iceStatLabel,
    statValueColor: WaitingRoomPlayerBannerTokens.iceStatValue,
    overlay: const WaitingRoomBannerOverlaySpec(
      type: WaitingRoomBannerOverlayType.iceSparkle,
      animationDuration: WaitingRoomPlayerBannerTokens.iceOverlay,
    ),
  );

  static final neon = WaitingRoomBannerTheme(
    borderGradientColors: WaitingRoomPlayerBannerTokens.neonBorderColors,
    borderShiftDuration: WaitingRoomPlayerBannerTokens.neonBorderShift,
    borderPingPong: false,
    pulseMinShadows: _pulseNeon.min,
    pulseMaxShadows: _pulseNeon.max,
    pulseDuration: WaitingRoomPlayerBannerTokens.neonPulse,
    div1Gradient: WaitingRoomPlayerBannerTokens.neonDiv1,
    div2Gradient: WaitingRoomPlayerBannerTokens.neonDiv2,
    statsGradient: WaitingRoomPlayerBannerTokens.neonStats,
    nameColor: WaitingRoomPlayerBannerTokens.neonName,
    nameShadows: WaitingRoomPlayerBannerTokens.neonNameShadows,
    statLabelColor: WaitingRoomPlayerBannerTokens.neonStatLabel,
    statValueColor: WaitingRoomPlayerBannerTokens.neonStatValue,
    overlay: const WaitingRoomBannerOverlaySpec(
      type: WaitingRoomBannerOverlayType.neonWash,
      animationDuration: WaitingRoomPlayerBannerTokens.neonOverlay,
    ),
  );

  static List<BoxShadow> lerpShadowPulse(
    List<BoxShadow> a,
    List<BoxShadow> b,
    double t,
  ) {
    return List.generate(a.length, (i) => BoxShadow.lerp(a[i], b[i], t)!);
  }

  static double pulsePhase(double controllerValue) {
    final v = controllerValue * 2;
    return v <= 1
        ? Curves.easeInOut.transform(v)
        : Curves.easeInOut.transform(2 - v);
  }

  static double borderShiftPhase(double linear0to1) {
    final doubled = linear0to1 * 2;
    return doubled <= 1 ? doubled : 2 - doubled;
  }
}

enum WaitingRoomBannerOverlayType {
  goldShimmer,
  shadowMist,
  flameGlow,
  iceSparkle,
  neonWash,
}

class WaitingRoomBannerOverlaySpec {
  const WaitingRoomBannerOverlaySpec({
    required this.type,
    required this.animationDuration,
  });

  final WaitingRoomBannerOverlayType type;
  final Duration animationDuration;
}
