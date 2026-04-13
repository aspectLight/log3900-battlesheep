import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../../core/localisation/select_game_session_localizations.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final l10n = SelectGameSessionLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _viewModel.onPopRequested();
      },
      child: AppBackground(
        child: Column(
          children: [
            _buildHeader(l10n),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: SelectGameSessionPanel(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(SelectGameSessionLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.only(bottom: 32),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _viewModel.onBackButtonTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.mainMenu,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'CustomFont',
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            l10n.createGame,
            style: const TextStyle(
              color: Color(0xFFf5e6e6),
              fontFamily: 'CustomFont',
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
