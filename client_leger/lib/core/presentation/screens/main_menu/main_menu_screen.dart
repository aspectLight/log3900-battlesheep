import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/localisation/core_localizations.dart';
import '../../../../../routing/app_navigator.dart';
import '../../../../../routing/navigation_command.dart';
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
  late final AppNavigator _appNavigator;
  bool _showSettings = false;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<MainMenuViewModel>();
    _appNavigator = GetIt.I<AppNavigator>();
    _viewModel.loadPendingRequests();
  }

  void _openSettings() {
    if (_showSettings) return;
    setState(() => _showSettings = true);
  }

  void _closeSettings() {
    if (!_showSettings) return;
    setState(() => _showSettings = false);
  }

  @override
  void didPushNext() {
    _closeSettings();
  }

  @override
  void didPopNext() {
    _viewModel.loadPendingRequests();
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
                            _closeSettings();
                            _viewModel.joinGame();
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildMenuButton(
                          label: CoreLocalizations.of(context)!.createGame,
                          onPressed: () {
                            _closeSettings();
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
                            _closeSettings();
                            _viewModel.administerFriends();
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
          Positioned(
            top: 20,
            right: 20,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  if (_showSettings) {
                    _closeSettings();
                    return;
                  }
                  _openSettings();
                },
                child: Image.asset(
                  UiAssets.settingsGear,
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),
          if (_showSettings)
            Positioned(
              top: 85,
              right: 20,
              child: SafeArea(
                child: TapRegion(
                  onTapOutside: (_) => _closeSettings(),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 15,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 220,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.interactionColors.outline,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSettingsOption(
                            label: CoreLocalizations.of(context)!.profile,
                            onTap: () {
                              _closeSettings();
                              _viewModel.openProfile();
                            },
                          ),
                          const Divider(height: 1),
                          _buildSettingsOption(
                            label: CoreLocalizations.of(context)!.signOut,
                            onTap: () {
                              _closeSettings();
                              unawaited(_viewModel.signOut());
                              _appNavigator.request(GoToAuth());
                            },
                          ),
                          const Divider(height: 1),
                          _buildSettingsOption(
                            label: CoreLocalizations.of(
                              context,
                            )!.connectionHistory,
                            onTap: () {
                              _closeSettings();
                              _viewModel.openConnectionHistory();
                            },
                          ),
                          const Divider(height: 1),
                          _buildSettingsOption(
                            label: CoreLocalizations.of(context)!.gameHistory,
                            onTap: () {
                              _closeSettings();
                              _viewModel.openGameHistory();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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

  Widget _buildSettingsOption({
    required String label,
    required VoidCallback? onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      splashColor: scheme.primary.withValues(alpha: 0.25),
      highlightColor: scheme.primary.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: onTap == null ? Colors.grey : scheme.onSurface,
                  fontFamily: 'CustomFont',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
