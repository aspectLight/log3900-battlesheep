import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'waiting_room_player_banner_styles.dart';

class WaitingRoomPlayerBannerShell extends StatefulWidget {
  const WaitingRoomPlayerBannerShell({
    super.key,
    required this.activeBanner,
    required this.builder,
  });

  final String? activeBanner;
  final Widget Function(
    BuildContext context,
    WaitingRoomBannerTheme? theme,
    double borderPhase,
    double pulsePhase,
    double overlayPhase,
  ) builder;

  @override
  State<WaitingRoomPlayerBannerShell> createState() =>
      _WaitingRoomPlayerBannerShellState();
}

class _WaitingRoomPlayerBannerShellState extends State<WaitingRoomPlayerBannerShell>
    with TickerProviderStateMixin {
  AnimationController? _border;
  AnimationController? _pulse;
  AnimationController? _overlay;

  WaitingRoomBannerTheme? get _theme => waitingRoomBannerTheme(widget.activeBanner);

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  @override
  void didUpdateWidget(covariant WaitingRoomPlayerBannerShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeBanner != widget.activeBanner) {
      _disposeControllers();
      _syncControllers();
    }
  }

  void _syncControllers() {
    final t = _theme;
    if (t == null) {
      return;
    }
    _border = AnimationController(vsync: this, duration: t.borderShiftDuration);
    unawaited(_border!.repeat(reverse: t.borderPingPong));
    _pulse = AnimationController(vsync: this, duration: t.pulseDuration);
    unawaited(_pulse!.repeat(reverse: true));
    final overlaySpec = t.overlay;
    if (overlaySpec != null) {
      _overlay = AnimationController(
        vsync: this,
        duration: overlaySpec.animationDuration,
      );
      if (overlaySpec.type == WaitingRoomBannerOverlayType.neonWash) {
        unawaited(_overlay!.repeat());
      } else {
        unawaited(_overlay!.repeat(reverse: true));
      }
    }
  }

  void _disposeControllers() {
    _border?.dispose();
    _pulse?.dispose();
    _overlay?.dispose();
    _border = _pulse = _overlay = null;
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  LinearGradient _borderGradient(WaitingRoomBannerTheme t, double borderP) {
    final shift = borderP * 2 - 1;
    return LinearGradient(
      begin: Alignment(-1 + shift * 0.85, -1),
      end: Alignment(1 + shift * 0.85, 1),
      colors: t.borderGradientColors,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _theme;
    if (theme == null) {
      return DecoratedBox(
        decoration: waitingRoomPlayerCardDefaultOuterDecoration(),
        child: widget.builder(context, null, 0, 0, 0),
      );
    }

    final listenables = <Listenable>[_border!, _pulse!];
    if (_overlay != null) {
      listenables.add(_overlay!);
    }

    return AnimatedBuilder(
      animation: Listenable.merge(listenables),
      builder: (context, _) {
        final borderRaw = _border!.value;
        final borderP = theme.borderPingPong
            ? WaitingRoomBannerTheme.borderShiftPhase(borderRaw)
            : borderRaw;
        final pulseP = WaitingRoomBannerTheme.pulsePhase(_pulse!.value);
        final overlayCtrl = _overlay?.value ?? 0.0;
        final overlayP = theme.overlay?.type == WaitingRoomBannerOverlayType.neonWash
            ? _neonFlicker(overlayCtrl)
            : WaitingRoomBannerTheme.pulsePhase(overlayCtrl);

        final shadows = WaitingRoomBannerTheme.lerpShadowPulse(
          theme.pulseMinShadows,
          theme.pulseMaxShadows,
          pulseP,
        );

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            gradient: _borderGradient(theme, borderP),
            boxShadow: shadows,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(11)),
                border: theme.innerEdgeBorderColor != null
                    ? Border.all(
                        color: theme.innerEdgeBorderColor!,
                        width: 2,
                      )
                    : null,
              ),
              child: widget.builder(context, theme, borderP, pulseP, overlayP),
            ),
          ),
        );
      },
    );
  }
}

double _neonFlicker(double t) {
  final x = t * math.pi * 2;
  final a = 0.55 + 0.22 * math.sin(x * 5);
  final b = 0.12 * math.sin(x * 17);
  return (a + b).clamp(0.35, 1.0);
}

Widget waitingRoomBannerOverlayLayer(
  WaitingRoomBannerTheme theme,
  double borderPhase,
  double overlayPhase,
) {
  final spec = theme.overlay;
  if (spec == null) {
    return const SizedBox.shrink();
  }

  return Positioned.fill(
    child: IgnorePointer(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: switch (spec.type) {
          WaitingRoomBannerOverlayType.goldShimmer => CustomPaint(
            painter: _GoldShimmerPainter(overlayPhase),
            child: const SizedBox.expand(),
          ),
          WaitingRoomBannerOverlayType.shadowMist => DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomCenter,
                radius: 1.1,
                colors: [
                  Color.lerp(
                    const Color(0x4D4B0082),
                    const Color(0x66250032),
                    overlayPhase,
                  )!,
                  Colors.transparent,
                ],
                stops: const [0, 1],
              ),
            ),
          ),
          WaitingRoomBannerOverlayType.flameGlow => CustomPaint(
            painter: _FlameGlowPainter(overlayPhase),
            child: const SizedBox.expand(),
          ),
          WaitingRoomBannerOverlayType.iceSparkle => CustomPaint(
            painter: _IceSparklePainter(overlayPhase),
            child: const SizedBox.expand(),
          ),
          WaitingRoomBannerOverlayType.neonWash => DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0x0DFF00FF)
                      .withValues(alpha: 0.4 + 0.35 * overlayPhase),
                  const Color(0x1400FFFF)
                      .withValues(alpha: 0.45 + 0.25 * overlayPhase),
                  const Color(0x0DFF00FF)
                      .withValues(alpha: 0.4 + 0.35 * overlayPhase),
                ],
              ),
            ),
          ),
        },
      ),
    ),
  );
}

class _GoldShimmerPainter extends CustomPainter {
  _GoldShimmerPainter(this.phase);

  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final shift = (phase * 2 - 1) * size.width;
    final shaderRect = Rect.fromLTWH(-shift, 0, size.width * 2.5, size.height);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment(-0.85, 0.35),
        end: Alignment(0.85, -0.35),
        colors: [
          Colors.transparent,
          Color(0x26FFD700),
          Color(0x40FFF8DC),
          Color(0x26FFD700),
          Colors.transparent,
        ],
        stops: [0.35, 0.42, 0.5, 0.58, 0.65],
      ).createShader(shaderRect);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _GoldShimmerPainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}

class _FlameGlowPainter extends CustomPainter {
  _FlameGlowPainter(this.phase);

  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final o = 0.7 + 0.3 * phase;
    final sy = 1 + 0.02 * phase;
    canvas.save();
    canvas.translate(0, size.height * (1 - sy) / 2);
    canvas.scale(1, sy);

    void drawGlow(Offset c, double r, Color color) {
      final a = (color.a * o).clamp(0.0, 1.0);
      final p = Paint()
        ..shader = RadialGradient(
          colors: [color.withValues(alpha: a), Colors.transparent],
        ).createShader(Rect.fromCircle(center: c, radius: r));
      canvas.drawCircle(c, r, p);
    }

    drawGlow(Offset(size.width / 2, size.height), size.height * 0.55,
        const Color(0x4DFF4500));
    drawGlow(Offset(size.width * 0.28, size.height * 0.92), size.height * 0.35,
        const Color(0x33FFA500));
    drawGlow(Offset(size.width * 0.72, size.height * 0.92), size.height * 0.35,
        const Color(0x33FF0000));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FlameGlowPainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}

class _IceSparklePainter extends CustomPainter {
  _IceSparklePainter(this.phase);

  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final o = 0.5 + 0.5 * phase;
    void sparkle(Offset c, double r, double baseA) {
      final p = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: baseA * o),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: c, radius: r));
      canvas.drawCircle(c, r, p);
    }

    sparkle(Offset(size.width * 0.2, size.height * 0.2), size.width * 0.12, 0.3);
    sparkle(Offset(size.width * 0.82, size.height * 0.28), size.width * 0.09, 0.2);
    sparkle(Offset(size.width * 0.5, size.height * 0.72), size.width * 0.11, 0.25);
    sparkle(Offset(size.width * 0.72, size.height * 0.82), size.width * 0.07, 0.15);
  }

  @override
  bool shouldRepaint(covariant _IceSparklePainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}
