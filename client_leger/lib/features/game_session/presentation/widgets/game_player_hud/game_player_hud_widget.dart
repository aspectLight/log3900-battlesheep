import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/context/game_session_scope_holder.dart';
import '../../../core/extensions/stat_type_ext.dart';
import '../../../core/localisation/game_session_localizations.dart';
import '../../ui_models/components/game_player_ui_stat.dart';
import '../../ui_models/widget_states/game_player_hud_ui_state.dart';
import 'game_player_hud_view_model.dart';

class GamePlayerHudWidget extends StatefulWidget {
  const GamePlayerHudWidget({super.key});

  @override
  State<GamePlayerHudWidget> createState() => _GamePlayerHudWidgetState();
}

class _GamePlayerHudWidgetState extends State<GamePlayerHudWidget> {
  late final GamePlayerHudWidgetViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<GameSessionScopeHolder>().scope!.get<GamePlayerHudWidgetViewModel>();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = _viewModel.hudModel.watch(context);
    if (model == null) return const SizedBox.shrink();
    return _buildContent(context, model);
  }

  Widget _buildContent(BuildContext context, GamePlayerHudUiState model) {
    final l10n = GameSessionLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A1A), Color(0xFF252525)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            spreadRadius: 2,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PlayerHeader(model: model, l10n: l10n),
            _SectionHeader(title: l10n.playerHudStatsSection),
            _StatsGrid(statRows: model.statRows, l10n: l10n),
            _SectionHeader(title: l10n.playerHudDiceSection),
            _DiceGrid(
              attackAsset: model.attackDiceAsset,
              defenseAsset: model.defenseDiceAsset,
              l10n: l10n,
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _PlayerHeader extends StatelessWidget {
  final GamePlayerHudUiState model;
  final GameSessionLocalizations l10n;

  const _PlayerHeader({required this.model, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF333333),
            ),
            clipBehavior: Clip.antiAlias,
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                2.5,
                0,
                0,
                0,
                0,
                0,
                2.5,
                0,
                0,
                0,
                0,
                0,
                2.5,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ]),
              child: model.avatarPath.isEmpty
                  ? const SizedBox.shrink()
                  : Image.asset(model.avatarPath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              model.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                fontFamily: 'CustomFont',
              ),
            ),
          ),
          const SizedBox(width: 8),
          IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PointValue(
                    label: l10n.playerHudMovements(model.movementPoints),
                  ),
                  const SizedBox(height: 4),
                  _PointValue(label: l10n.playerHudActions(model.actionPoints)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PointValue extends StatelessWidget {
  final String label;

  const _PointValue({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFEEEEEE),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
            fontFamily: 'CustomFont',
          ),
        ),
        const SizedBox(height: 1),
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withValues(alpha: 0.15),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.white.withValues(alpha: 0.1),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A1A1A), Color(0xFF252525)],
            ),
          ),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 14,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
              fontFamily: 'CustomFont',
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final List<GamePlayerUiStat> statRows;
  final GameSessionLocalizations l10n;

  const _StatsGrid({required this.statRows, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 22,
          crossAxisSpacing: 16,
        ),
        itemCount: statRows.length,
        itemBuilder: (context, index) {
          final stat = statRows[index];
          return FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 65,
                  child: Text(
                    stat.statType.resolveStatLabel(l10n),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'CustomFont',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    stat.value.clamp(0, 999),
                    (_) => Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Image.asset(
                        stat.assetPath,
                        width: 15,
                        height: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DiceGrid extends StatelessWidget {
  final String attackAsset;
  final String defenseAsset;
  final GameSessionLocalizations l10n;

  const _DiceGrid({
    required this.attackAsset,
    required this.defenseAsset,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 22,
          crossAxisSpacing: 16,
        ),
        children: [
          _buildDiceRow(l10n.statAttack, attackAsset),
          _buildDiceRow(l10n.statDefense, defenseAsset),
        ],
      ),
    );
  }

  Widget _buildDiceRow(String label, String asset) {
    return FittedBox(
      alignment: Alignment.centerLeft,
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 65,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'CustomFont',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Image.asset(asset, width: 18, height: 18),
        ],
      ),
    );
  }
}
