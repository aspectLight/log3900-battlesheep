import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../generated/l10n/app_localizations.dart';
import '../view_models/auth_view_model.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    _authViewModel = GetIt.I<AuthViewModel>();
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
      body: Column(children: [_buildWelcomeCard(), _buildMenuOptions()]),
    );
  }

  Widget _buildWelcomeCard() {
    return Watch((context) {
      final user = _authViewModel.currentUser.value;
      final username = user?.username ?? 'Player';

      return Column(
        children: [
          Text(username.isNotEmpty ? username[0].toUpperCase() : 'P'),
          Text(AppLocalizations.of(context)!.welcomeUser(username)),
        ],
      );
    });
  }

  Widget _buildMenuOptions() {
    return Center(child: Text(AppLocalizations.of(context)!.gameContentSoon));
  }
}
