import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../generated/l10n/app_localizations.dart';
import '../../../routing/app_router.dart';
import '../../widgets/app_background/app_background.dart';
import 'main_menu_view_model.dart';

@RoutePage()
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late final MainMenuViewModel _viewModel;
  bool _showSettings = false;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<MainMenuViewModel>();
  }

  void _toggleSettings() {
    setState(() {
      _showSettings = !_showSettings;
    });
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
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 300,
                          ),
                        ),
                        _buildMenuButton(
                          label: AppLocalizations.of(context)!.joinGame,
                          onPressed: null,
                        ),
                        const SizedBox(height: 15),
                        _buildMenuButton(
                          label: AppLocalizations.of(context)!.createGame,
                          onPressed: null,
                        ),
                        const SizedBox(height: 15),
                        _buildMenuButton(
                          label: AppLocalizations.of(context)!.administerGames,
                          onPressed: null,
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
                      AppLocalizations.of(context)!.teamName,
                      style: const TextStyle(
                        fontFamily: 'CustomFont',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      AppLocalizations.of(context)!.teamMembers,
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
                onTap: _toggleSettings,
                child: Image.asset(
                  'assets/images/settings.png',
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),
          if (_showSettings)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleSettings,
                behavior: HitTestBehavior.translucent,
                child: Container(),
              ),
            ),
          if (_showSettings)
            Positioned(
              top: 85,
              right: 20,
              child: SafeArea(
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
                          label: AppLocalizations.of(context)!.profile,
                          onTap: null,
                        ),
                        const Divider(height: 1),
                        _buildSettingsOption(
                          label: AppLocalizations.of(context)!.signOut,
                          onTap: () {
                            _toggleSettings();
                            unawaited(_viewModel.signOut());
                            unawaited(
                              context.router.replaceAll([
                                const AuthLandingRoute(),
                              ]),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        _buildSettingsOption(
                          label: AppLocalizations.of(
                            context,
                          )!.connectionHistory,
                          onTap: null,
                        ),
                        const Divider(height: 1),
                        _buildSettingsOption(
                          label: AppLocalizations.of(context)!.gameHistory,
                          onTap: null,
                        ),
                      ],
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
