import 'package:flutter/material.dart';

import '../../../constants/ui_assets.dart';
import '../app_background/app_background.dart';

/// Full-screen loading with the same parallax + snow as the rest of the app.
/// The app root keeps the route and modal/notification layers offstage during navigation
/// so only this background + the spinner paint — no page buttons or chrome.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 180),
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Image.asset(
                UiAssets.loading,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ),
    );
  }
}
