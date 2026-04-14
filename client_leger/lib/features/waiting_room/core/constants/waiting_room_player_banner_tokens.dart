import 'package:flutter/material.dart';

abstract final class WaitingRoomPlayerBannerTokens {
  WaitingRoomPlayerBannerTokens._();

  static const playerCardBorderRadius = 10.0;

  static const bannerIdGold = 'banner_gold';
  static const bannerIdShadow = 'banner_shadow';
  static const bannerIdFlame = 'banner_flame';
  static const bannerIdIce = 'banner_ice';
  static const bannerIdNeon = 'banner_neon';

  static const blackCenter = Color(0xB3000000);
  static const blackCenterDeep = Color(0xCC000000);

  static const goldBorderColors = [
    Color(0xFFFFD700),
    Color(0xFFDAA520),
    Color(0xFFFFF8DC),
    Color(0xFFB8860B),
    Color(0xFFFFD700),
  ];

  static const goldBorderShift = Duration(seconds: 4);
  static const goldPulse = Duration(seconds: 3);
  static const goldOverlay = Duration(seconds: 3);

  static const goldDiv1 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x14B8860B), Color(0x1EFFD700)],
  );

  static const goldDiv2 = LinearGradient(
    colors: [Color(0x66B8860B), blackCenter, Color(0x66B8860B)],
  );

  static const goldStats = LinearGradient(
    colors: [Color(0x4DB8860B), blackCenter, Color(0x4DB8860B)],
  );

  static const goldNameShadows = [
    Shadow(color: Color(0x80FFD700), blurRadius: 6),
  ];

  static const goldPulseInnerMin = Color(0x66FFD700);
  static const goldPulseInnerBlurMin = 12.0;
  static const goldPulseOuterMin = Color(0x33FFD700);
  static const goldPulseOuterBlurMin = 24.0;
  static const goldPulseInnerMax = Color(0xB3FFD700);
  static const goldPulseInnerBlurMax = 20.0;
  static const goldPulseOuterMax = Color(0x4DFFD700);
  static const goldPulseOuterBlurMax = 40.0;

  static const shadowBorderColors = [
    Color(0xFF0D0015),
    Color(0xFF2D1B69),
    Color(0xFF1A0A2E),
    Color(0xFF4A2C8A),
    Color(0xFF0D0015),
  ];

  static const shadowBorderShift = Duration(seconds: 5);
  static const shadowPulse = Duration(seconds: 4);
  static const shadowOverlay = Duration(seconds: 5);
  static const shadowInnerEdge = Color(0xFF1A0A2E);

  static const shadowDiv1 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x4D0D0015), Color(0x262D1B69)],
  );

  static const shadowDiv2 = LinearGradient(
    colors: [Color(0xCC0D0015), Color(0x802D1B69), Color(0xCC0D0015)],
  );

  static const shadowStats = LinearGradient(
    colors: [Color(0xCC0D0015), Color(0x662D1B69), Color(0xCC0D0015)],
  );

  static const shadowName = Color(0xFFC9B3FF);
  static const shadowNameShadows = [
    Shadow(color: Color(0x998A2BE2), blurRadius: 8),
    Shadow(color: Color(0xE6000000), blurRadius: 3),
  ];

  static const shadowStatLabel = Color(0xFF9A7ECC);
  static const shadowStatValue = Color(0xFFD4C4FF);

  static const shadowPulseInnerMin = Color(0x804B0082);
  static const shadowPulseInnerBlurMin = 15.0;
  static const shadowPulseOuterMin = Color(0x99000000);
  static const shadowPulseOuterBlurMin = 30.0;
  static const shadowPulseInnerMax = Color(0xB34B0082);
  static const shadowPulseInnerBlurMax = 25.0;
  static const shadowPulseOuterMax = Color(0xCC000000);
  static const shadowPulseOuterBlurMax = 50.0;

  static const flameBorderColors = [
    Color(0xFFFF4500),
    Color(0xFFFF6A00),
    Color(0xFFFFD700),
    Color(0xFFFF6A00),
    Color(0xFFFF0000),
    Color(0xFFFF4500),
  ];

  static const flameBorderShift = Duration(seconds: 2);
  static const flamePulse = Duration(seconds: 2);
  static const flameOverlay = Duration(milliseconds: 1500);

  static const flameDiv1 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x0DFF4500), Color(0x33FF4500)],
  );

  static const flameDiv2 = LinearGradient(
    colors: [Color(0x998B0000), blackCenter, Color(0x998B0000)],
  );

  static const flameStats = LinearGradient(
    colors: [Color(0x808B0000), blackCenter, Color(0x808B0000)],
  );

  static const flameNameShadows = [
    Shadow(color: Color(0xB3FF4500), blurRadius: 6),
    Shadow(color: Color(0x4DFF0000), blurRadius: 12),
  ];

  static const flamePulseInnerMin = Color(0x80FF4500);
  static const flamePulseInnerBlurMin = 12.0;
  static const flamePulseOuterMin = Color(0x33FF0000);
  static const flamePulseOuterBlurMin = 24.0;
  static const flamePulseInnerMax = Color(0xCCFF4500);
  static const flamePulseInnerBlurMax = 24.0;
  static const flamePulseOuterMax = Color(0x66FF0000);
  static const flamePulseOuterBlurMax = 48.0;

  static const iceBorderColors = [
    Color(0xFFA8D8EA),
    Color(0xFF87CEEB),
    Color(0xFFE0F7FA),
    Color(0xFF4FC3F7),
    Color(0xFFA8D8EA),
  ];

  static const iceBorderShift = Duration(seconds: 5);
  static const icePulse = Duration(seconds: 4);
  static const iceOverlay = Duration(seconds: 3);

  static const iceDiv1 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x1A87CEEB), Color(0x264FC3F7)],
  );

  static const iceDiv2 = LinearGradient(
    colors: [Color(0x6664B5F6), blackCenter, Color(0x6664B5F6)],
  );

  static const iceStats = LinearGradient(
    colors: [Color(0x4D64B5F6), blackCenter, Color(0x4D64B5F6)],
  );

  static const iceName = Color(0xFFE0F7FA);
  static const iceNameShadows = [
    Shadow(color: Color(0x9987CEEB), blurRadius: 6),
  ];

  static const iceStatLabel = Color(0xFF90CAF9);
  static const iceStatValue = Color(0xFFE0F7FA);

  static const icePulseInnerMin = Color(0x6687CEEB);
  static const icePulseInnerBlurMin = 12.0;
  static const icePulseOuterMin = Color(0x334FC3F7);
  static const icePulseOuterBlurMin = 24.0;
  static const icePulseInnerMax = Color(0xB387CEEB);
  static const icePulseInnerBlurMax = 20.0;
  static const icePulseOuterMax = Color(0x4D4FC3F7);
  static const icePulseOuterBlurMax = 40.0;

  static const neonBorderColors = [
    Color(0xFFFF00FF),
    Color(0xFF00FFFF),
    Color(0xFFFF00FF),
    Color(0xFF00FF88),
    Color(0xFFFF00FF),
  ];

  static const neonBorderShift = Duration(seconds: 3);
  static const neonPulse = Duration(milliseconds: 2500);
  static const neonOverlay = Duration(seconds: 4);

  static const neonDiv1 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x0DFF00FF), Color(0x1A00FFFF)],
  );

  static const neonDiv2 = LinearGradient(
    colors: [Color(0x4DFF00FF), blackCenterDeep, Color(0x4D00FFFF)],
  );

  static const neonStats = LinearGradient(
    colors: [Color(0x40FF00FF), blackCenterDeep, Color(0x4000FFFF)],
  );

  static const neonName = Color(0xFFE0FFFF);
  static const neonNameShadows = [
    Shadow(color: Color(0xB300FFFF), blurRadius: 8),
    Shadow(color: Color(0x66FF00FF), blurRadius: 16),
  ];

  static const neonStatLabel = Color(0xFF80FFFF);
  static const neonStatValue = Color(0xFFE0FFFF);

  static const neonPulseInnerMin = Color(0x66FF00FF);
  static const neonPulseInnerBlurMin = 10.0;
  static const neonPulseOuterMin = Color(0x4D00FFFF);
  static const neonPulseOuterBlurMin = 20.0;
  static const neonPulseInnerMax = Color(0xB3FF00FF);
  static const neonPulseInnerBlurMax = 20.0;
  static const neonPulseOuterMax = Color(0x8000FFFF);
  static const neonPulseOuterBlurMax = 40.0;
}
