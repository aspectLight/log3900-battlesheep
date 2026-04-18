import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../appearance/app_appearance_service.dart';
import '../../../appearance/app_visual_theme.dart';
import '../../../constants/ui_assets.dart';
import '../../../di/injection_container.dart';

class AppBackground extends StatefulWidget {
  const AppBackground({required this.child, super.key});

  final Widget child;

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 40),
      vsync: this,
    );
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final visual = getIt<AppAppearanceService>().visualTheme.value;
      final isDefault = visual == AppVisualTheme.defaultTheme;
      final size = MediaQuery.sizeOf(context);

      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ClipRect(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: RepaintBoundary(
                  child: isDefault
                      ? AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                -size.width * _controller.value,
                                0,
                              ),
                              child: OverflowBox(
                                alignment: Alignment.topLeft,
                                maxWidth: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      backgroundAssetForVisualTheme(visual),
                                      width: size.width,
                                      height: size.height,
                                      fit: BoxFit.cover,
                                    ),
                                    Image.asset(
                                      backgroundAssetForVisualTheme(visual),
                                      width: size.width,
                                      height: size.height,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Image.asset(
                            backgroundAssetForVisualTheme(visual),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ),
            Positioned.fill(
              child: RepaintBoundary(
                child: Image.asset(
                  UiAssets.snow,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.5),
                  filterQuality: FilterQuality.low,
                  gaplessPlayback: true,
                ),
              ),
            ),
            widget.child,
          ],
        ),
      );
    });
  }
}
