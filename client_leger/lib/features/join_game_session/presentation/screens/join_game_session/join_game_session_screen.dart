import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../../core/localisation/join_game_session_localizations.dart';
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
      child: AppBackground(
        child: Column(
          children: [
            _buildHeader(context),
            const Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: JoinByCodePanel(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = JoinGameSessionLocalizations.of(context)!;
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
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: _viewModel.onBackTap,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.mainMenu,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'CustomFont',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              l10n.joinGameTitle,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'CustomFont',
                fontSize: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
