// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../features/chat/presentation/widgets/chat_feature_overlay/chat_feature_overlay.dart';

/// Shell screen wrapping all authenticated routes.
///
/// Exists for one reason: [ChatFeatureOverlay] requires an [Overlay] ancestor,
/// which is only available inside the [Navigator]. Placing the chat here ensures
/// it sits under the [Navigator] in the widget tree while still appearing on top
/// of every authenticated screen — without duplicating it per screen.
///
/// Any screen that should show the chat panel must be a child route of this shell.
@RoutePage()
class AuthenticatedShellScreen extends StatelessWidget {
  const AuthenticatedShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AutoRouter(),
        const Positioned.fill(child: ChatFeatureOverlay()),
      ],
    );
  }
}
