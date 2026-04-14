import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/presentation/shell/shell_chrome_back_handler.dart';
import '../../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../widgets/available_rooms/available_rooms_panel.dart';
import '../../widgets/join_by_code/join_by_code_panel.dart';
import 'join_game_session_view_model.dart';

@RoutePage()
class JoinGameSessionScreen extends StatefulWidget {
  const JoinGameSessionScreen({super.key});

  @override
  State<JoinGameSessionScreen> createState() => _JoinGameSessionScreenState();
}

class _JoinGameSessionScreenState extends State<JoinGameSessionScreen> {
  late final JoinGameSessionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<JoinGameSessionViewModel>();
    GetIt.I<ShellChromeBackHandler>().register(_viewModel.onBackTap);
  }

  @override
  void dispose() {
    GetIt.I<ShellChromeBackHandler>().clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _viewModel.onBackTap();
        }
      },
      child: const AppBackground(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: Column(
                    children: [
                      AvailableRoomsPanel(),
                      SizedBox(height: 28),
                      JoinByCodePanel(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
