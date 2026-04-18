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
    _viewModel = GetIt.I<GameSessionScopeHolder>().scope!
        .get<GamePlayerHudWidgetViewModel>();
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
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF141414), Color(0xFF222222)],
        ),
        border: Border.all(color: const Color(0xFF3A3A3A)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PlayerHeader(model: model, l10n: l10n),
            const SizedBox(height: 10),
            _SectionHeader(title: l10n.playerHudStatsSection),
            const SizedBox(height: 4),
            Expanded(
              child: _StatsOnePerRow(statRows: model.statRows, l10n: l10n),
            ),
            const SizedBox(height: 4),
            _SectionHeader(title: l10n.playerHudDiceSection),
            const SizedBox(height: 6),
            _DiceRowPair(
              attackAsset: model.attackDiceAsset,
              defenseAsset: model.defenseDiceAsset,
              l10n: l10n,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerHeader extends StatefulWidget {
  final GamePlayerHudUiState model;
  final GameSessionLocalizations l10n;

  const _PlayerHeader({required this.model, required this.l10n});

  @override
  State<_PlayerHeader> createState() => _PlayerHeaderState();
}

class _PlayerHeaderState extends State<_PlayerHeader> {
  final GlobalKey _chipsColumnKey = GlobalKey();
  double _chipsStackHeight = 72;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_measureChipsStack);
  }

  @override
  void didUpdateWidget(covariant _PlayerHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    final m = widget.model;
    final o = oldWidget.model;
    if (m.name != o.name ||
        m.movementPoints != o.movementPoints ||
        m.actionPoints != o.actionPoints ||
        m.avatarPath != o.avatarPath) {
      WidgetsBinding.instance.addPostFrameCallback(_measureChipsStack);
    }
  }

  void _measureChipsStack([Duration? _]) {
    if (!mounted) return;
    final ctx = _chipsColumnKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      WidgetsBinding.instance.addPostFrameCallback(_measureChipsStack);
      return;
    }
    final h = box.size.height.clamp(48.0, 400.0);
    if ((h - _chipsStackHeight).abs() > 0.5) {
      setState(() => _chipsStackHeight = h);
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.model;
    final l10n = widget.l10n;
    final diameter = (_chipsStackHeight * 0.75).clamp(40.0, 200.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          m.name,
          softWrap: true,
          style: const TextStyle(
            color: Color(0xFFF8F8F8),
            fontSize: 20,
            height: 1.2,
            fontWeight: FontWeight.w700,
            fontFamily: 'CustomFont',
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: diameter,
              child: Align(
                child: SizedBox(
                  width: diameter,
                  height: diameter,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2E2E2E),
                    ),
                    child: ClipOval(
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
                        child: m.avatarPath.isEmpty
                            ? const SizedBox.shrink()
                            : Image.asset(m.avatarPath, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                key: _chipsColumnKey,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _MetaChip(text: l10n.playerHudMovements(m.movementPoints)),
                  const SizedBox(height: 8),
                  _MetaChip(text: l10n.playerHudActions(m.actionPoints)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String text;

  const _MetaChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF4A4A4A)),
      ),
      child: Text(
        text,
        softWrap: true,
        style: const TextStyle(
          color: Color(0xFFE8E8E8),
          fontSize: 13,
          height: 1.25,
          fontWeight: FontWeight.w600,
          fontFamily: 'CustomFont',
        ),
      ),
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
          color: const Color(0xFF4A4A4A),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: const Color(0xFF1C1C1C),
          child: Text(
            title.toUpperCase(),
            softWrap: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFC8C8C8),
              fontSize: 12,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w700,
              fontFamily: 'CustomFont',
            ),
          ),
        ),
      ],
    );
  }
}

/// One row per stat in HUD order: health, attack, defense, speed.
class _StatsOnePerRow extends StatelessWidget {
  final List<GamePlayerUiStat> statRows;
  final GameSessionLocalizations l10n;

  const _StatsOnePerRow({required this.statRows, required this.l10n});

  @override
  Widget build(BuildContext context) {
    if (statRows.length < 4) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      '${statRows[0].statType.resolveStatLabel(l10n)}  ${statRows[0].value.clamp(0, 999)}',
                      style: const TextStyle(fontFamily: 'CustomFont'),
                    ),
                    const Spacer(),
                    Text(
                      '${statRows[1].statType.resolveStatLabel(l10n)}  ${statRows[1].value.clamp(0, 999)}',
                      style: const TextStyle(fontFamily: 'CustomFont'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${statRows[2].statType.resolveStatLabel(l10n)}  ${statRows[2].value.clamp(0, 999)}',
                      style: const TextStyle(fontFamily: 'CustomFont'),
                    ),
                    const Spacer(),
                    Text(
                      '${statRows[3].statType.resolveStatLabel(l10n)}  ${statRows[3].value.clamp(0, 999)}',
                      style: const TextStyle(fontFamily: 'CustomFont'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DiceRowPair extends StatelessWidget {
  final String attackAsset;
  final String defenseAsset;
  final GameSessionLocalizations l10n;

  const _DiceRowPair({
    required this.attackAsset,
    required this.defenseAsset,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _DiceCell(label: l10n.statAttack, asset: attackAsset),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _DiceCell(label: l10n.statDefense, asset: defenseAsset),
        ),
      ],
    );
  }
}

class _DiceCell extends StatelessWidget {
  final String label;
  final String asset;

  const _DiceCell({required this.label, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            softWrap: true,
            style: const TextStyle(
              color: Color(0xFFF0F0F0),
              fontSize: 14,
              height: 1.2,
              fontWeight: FontWeight.w600,
              fontFamily: 'CustomFont',
            ),
          ),
        ),
        Image.asset(
          asset,
          width: 28,
          height: 28,
          filterQuality: FilterQuality.medium,
        ),
      ],
    );
  }
}
