import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../features/chat/presentation/widgets/chat_feature_overlay/chat_feature_overlay.dart';
import '../../shell/shell_chrome_metrics.dart';
import '../../widgets/shell_quick_settings_overlay/shell_quick_settings_overlay.dart';

@RoutePage()
class AuthenticatedShellScreen extends StatelessWidget {
  const AuthenticatedShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = shellChromeBodyTopInset(context);
    final mq = MediaQuery.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        MediaQuery(
          data: mq.copyWith(padding: mq.padding.copyWith(top: topInset)),
          child: const AutoRouter(),
        ),
        const Positioned.fill(child: ChatFeatureOverlay()),
        const ShellQuickSettingsOverlay(),
      ],
    );
  }
}
