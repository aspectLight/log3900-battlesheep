import 'dart:math';
import 'package:flutter/material.dart';

class DashedPathPainter extends CustomPainter {
  final bool hasUp;
  final bool hasDown;
  final bool hasLeft;
  final bool hasRight;

  DashedPathPainter({
    required this.hasUp,
    required this.hasDown,
    required this.hasLeft,
    required this.hasRight,
  });

  static const double _dashLength = 4;
  static const double _gapLength = 4;
  static const double _strokeWidth = 3;
  static const Color _pathColor = Color.fromRGBO(180, 180, 180, 1);

  @override
  void paint(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..color = _pathColor
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    if (hasUp) {
      _drawDashedLine(
        canvas,
        Offset(centerX, 0),
        Offset(centerX, centerY),
        pathPaint,
      );
    }
    if (hasDown) {
      _drawDashedLine(
        canvas,
        Offset(centerX, centerY),
        Offset(centerX, size.height),
        pathPaint,
      );
    }
    if (hasLeft) {
      _drawDashedLine(
        canvas,
        Offset(0, centerY),
        Offset(centerX, centerY),
        pathPaint,
      );
    }
    if (hasRight) {
      _drawDashedLine(
        canvas,
        Offset(centerX, centerY),
        Offset(size.width, centerY),
        pathPaint,
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final double dx = end.dx - start.dx;
    final double dy = end.dy - start.dy;
    final double totalLength = sqrt(dx * dx + dy * dy);
    if (totalLength == 0) return;
    final double unitX = dx / totalLength;
    final double unitY = dy / totalLength;
    var drawn = 0.0;
    var current = start;
    while (drawn < totalLength) {
      final dashEnd = Offset(
        current.dx + unitX * _dashLength,
        current.dy + unitY * _dashLength,
      );
      canvas.drawLine(current, dashEnd, paint);
      drawn += _dashLength + _gapLength;
      current = Offset(
        current.dx + unitX * (_dashLength + _gapLength),
        current.dy + unitY * (_dashLength + _gapLength),
      );
    }
  }

  @override
  bool shouldRepaint(covariant DashedPathPainter oldDelegate) {
    return hasUp != oldDelegate.hasUp ||
        hasDown != oldDelegate.hasDown ||
        hasLeft != oldDelegate.hasLeft ||
        hasRight != oldDelegate.hasRight;
  }
}
