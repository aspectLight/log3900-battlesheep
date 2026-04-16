import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/presentation/shell/shell_chrome_back_handler.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../widgets/select_game_session/select_game_session_panel.dart';
import 'select_game_session_view_model.dart';

@RoutePage()
class SelectGameSessionScreen extends StatefulWidget {
  const SelectGameSessionScreen({super.key});

  @override
  State<SelectGameSessionScreen> createState() =>
      _SelectGameSessionScreenState();
}

class _SelectGameSessionScreenState extends State<SelectGameSessionScreen> {
  late final SelectGameSessionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<SelectGameSessionViewModel>();
    GetIt.I<ShellChromeBackHandler>().register(_viewModel.onBackButtonTap);
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
        if (!didPop) _viewModel.onPopRequested();
      },
      child: const AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(32, 32, 32, 40),
                  child: SelectGameSessionPanel(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
