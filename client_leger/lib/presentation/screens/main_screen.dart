import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/entities/auth_state.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../routing/app_router.dart';
import '../view_models/auth_view_model.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final AuthViewModel _authViewModel;
  EffectCleanup? _authStateCleanup;

  @override
  void initState() {
    super.initState();
    _authViewModel = GetIt.I<AuthViewModel>();
    _setupAuthStateListener();
  }

  void _setupAuthStateListener() {
    _authStateCleanup = effect(() {
      final state = _authViewModel.authState.value;
      if (state is AuthStateUnauthenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(context.router.replaceAll([const LoginRoute()]));
        });
      }
    });
  }

  @override
  void dispose() {
    _authStateCleanup?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mainMenu),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _authViewModel.signOut,
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 48),
            _buildMenuOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Watch((context) {
      final user = _authViewModel.currentUser.value;
      final username = user?.username ?? 'Player';

      return Column(
        children: [
          Text(username.isNotEmpty ? username[0].toUpperCase() : 'P'),
          Text(
            AppLocalizations.of(context)!.welcomeUser(username),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
            ),
          ),
        ],
      );
    });
  }

  Widget _buildMenuOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.gameContentSoon,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              context.router.push(const ChatRoute());
            },
            icon: const Icon(Icons.chat),
            label: Text(
              AppLocalizations.of(context)!.chat,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
