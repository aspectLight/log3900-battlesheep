import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../constants/ui_assets.dart';
import '../../widgets/app_background/app_background.dart';

@RoutePage()
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Match [LoadingOverlay] so when the overlay hides (timer) the route under it
    // is not a bare dark scaffold — avoids a quick black flash before the game.
    return Scaffold(
      body: AppBackground(
        child: Center(
          child: Image.asset(
            UiAssets.loading,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
