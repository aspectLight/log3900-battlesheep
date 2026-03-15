import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
                        const SizedBox(height: 15),
                        _buildMenuButton(
                          label: CoreLocalizations.of(
                            context,
                          )!.discussionCanals,
                          onPressed: () {
                            _closeSettings();
                            _viewModel.administerCanals();
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
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
    return SizedBox(
      width: 400,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.black38,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.grey,
          shadowColor: Colors.transparent,
          side: const BorderSide(color: Colors.transparent),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 20, fontFamily: 'CustomFont'),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildSettingsOption({
    required String label,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: onTap == null ? Colors.grey : Colors.black87,
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
