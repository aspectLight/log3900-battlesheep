import 'package:flutter/material.dart';

import '../../../core/constants/asset_constants.dart';
import '../app_background/app_background.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 250),
        builder: (context, opacity, child) {
          return Opacity(
            opacity: opacity,
            child: Center(
              child: Image.asset(
                AssetConstants.loading,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
