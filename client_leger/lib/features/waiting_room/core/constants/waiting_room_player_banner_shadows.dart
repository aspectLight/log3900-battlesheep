import 'package:flutter/material.dart';

abstract final class WaitingRoomPlayerBannerShadows {
  WaitingRoomPlayerBannerShadows._();

  static const floorSoft = BoxShadow(
    color: Color(0x33000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  static const dropStrong = BoxShadow(
    color: Color(0x4D000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  static const shadowMistFloorSoft = BoxShadow(
    color: Color(0x33000000),
    blurRadius: 15,
    spreadRadius: -5,
  );

  static const shadowMistFloorStrong = BoxShadow(
    color: Color(0x4D000000),
    blurRadius: 25,
    spreadRadius: -5,
  );
}
