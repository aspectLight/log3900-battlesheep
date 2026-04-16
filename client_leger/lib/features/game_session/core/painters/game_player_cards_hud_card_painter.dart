import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/game_team_constants.dart';
import '../../../../core/helpers/functional_programming.dart';

/// Angular `actions-hud`: polygon(0 0, 97% 0, 100% 50%, 97% 100%, 0 100%, 3% 50%)
class GamePlayerCardsHudCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.97, 0)
      ..lineTo(w, h * 0.5)
      ..lineTo(w * 0.97, h)
      ..lineTo(0, h)
      ..lineTo(w * 0.03, h * 0.5)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class GamePlayerCardsHudCardPainter extends CustomPainter {
  final Option<int> team;
  final bool isVirtual;
  final bool isActive;

  GamePlayerCardsHudCardPainter({
    required this.team,
    required this.isVirtual,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = GamePlayerCardsHudCardClipper().getClip(size);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isVirtual ? 2.0 : 2.5;

    var colors = [const Color(0xFFD4AF37), const Color(0xFF8B0000)];

    final isTeamUsa = team
        .map((t) => t == GameTeamConstants.teamUsa)
        .orElse(false);
    if (isTeamUsa) {
      colors = [Colors.white, const Color(0xFF0000FF)];
    }

    if (isVirtual) {
      paint.color = const Color(0xFF00BFFF);
      paint.shader = null;
    } else {
      if (isActive) {
        paint.color = const Color(0xFFC89B05);
        paint.shader = null;
      } else {
        paint.shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant GamePlayerCardsHudCardPainter oldDelegate) {
    return oldDelegate.team.orElse(-1) != team.orElse(-1) ||
        oldDelegate.isVirtual != isVirtual ||
        oldDelegate.isActive != isActive;
  }
}
