import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/localisation/core_localizations.dart';
import '../../../../../core/presentation/shell/shell_chrome_back_handler.dart';
import '../../../constants/ui_assets.dart';
import '../../widgets/app_background/app_background.dart';
import 'main_menu_view_model.dart';

@RoutePage()
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with AutoRouteAwareStateMixin<MainMenuScreen> {
  late final MainMenuViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<MainMenuViewModel>();
    GetIt.I<ShellChromeBackHandler>().clear();
    unawaited(_viewModel.loadPendingRequests());
    unawaited(_viewModel.checkTutorialStatus());
  }

  @override
  void didPopNext() {
    unawaited(_viewModel.loadPendingRequests());
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Image.asset(UiAssets.logo, width: 300),
                        ),
                        _buildMenuButton(
                          label: CoreLocalizations.of(context)!.joinGame,
                          onPressed: () {
                            _viewModel.joinGame();
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildMenuButton(
                          label: CoreLocalizations.of(context)!.createGame,
                          onPressed: () {
                            _viewModel.administerGames();
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildMenuButtonWithBadge(
                          label: CoreLocalizations.of(context)!.friends,
                          badge: Watch.builder(
                            builder: (ctx) {
                              final count =
                                  _viewModel.pendingRequestCount.value;
                              if (count == 0) return const SizedBox.shrink();
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '$count',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                          onPressed: () {
                            _viewModel.administerFriends();
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildMenuButton(
                          label: CoreLocalizations.of(context)!.shop,
                          onPressed: () {
                            _viewModel.openShop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      CoreLocalizations.of(context)!.teamName,
                      style: const TextStyle(
                        fontFamily: 'CustomFont',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      CoreLocalizations.of(context)!.teamMembers,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final outline = context.interactionColors.outline;
    return SizedBox(
      width: 400,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary.withValues(alpha: 0.42),
          disabledBackgroundColor: Colors.black38,
          foregroundColor: scheme.onPrimary,
          disabledForegroundColor: Colors.grey,
          shadowColor: Colors.transparent,
          side: BorderSide(color: outline, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 20, fontFamily: 'CustomFont'),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildMenuButtonWithBadge({
    required String label,
    required Widget badge,
    required VoidCallback? onPressed,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final outline = context.interactionColors.outline;
    return SizedBox(
      width: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 400,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary.withValues(alpha: 0.42),
                disabledBackgroundColor: Colors.black38,
                foregroundColor: scheme.onPrimary,
                shadowColor: Colors.transparent,
                side: BorderSide(color: outline, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'CustomFont',
                ),
              ),
              child: Text(label),
            ),
          ),
          Positioned(top: 4, right: 60, child: badge),
        ],
      ),
    );
  }
}
