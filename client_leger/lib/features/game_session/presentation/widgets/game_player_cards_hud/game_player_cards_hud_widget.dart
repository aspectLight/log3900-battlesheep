import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/constants/avatar_assets.dart';
import '../../../../../core/constants/ui_assets.dart';
import '../../../../../core/helpers/functional_programming.dart';
import '../../../core/constants/game_team_constants.dart';
import '../../../core/localisation/game_session_localizations.dart';
import '../../../core/painters/game_player_cards_hud_card_painter.dart';
import '../../ui_models/components/game_player_ui_card.dart';
import 'game_player_cards_hud_view_model.dart';

/// Other players list: one compact card per row, hex clip-path, scrolls vertically.
class GamePlayerCardsHudWidget extends StatefulWidget {
  const GamePlayerCardsHudWidget({super.key});

  @override
  State<GamePlayerCardsHudWidget> createState() =>
      _GamePlayerCardsHudWidgetState();
}

class _GamePlayerCardsHudWidgetState extends State<GamePlayerCardsHudWidget> {
  late final GamePlayerCardsHudViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<GamePlayerCardsHudViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    final cards = _viewModel.cards.watch(context);
    if (cards.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index < cards.length - 1 ? 4 : 0),
            child: _PlayerCardsHudCard(card: cards[index]),
          );
        },
      ),
    );
  }
}

class _PlayerCardsHudCard extends StatelessWidget {
  final GamePlayerUiCard card;

  const _PlayerCardsHudCard({required this.card});

  /// Hex row height; avatar fills the inner bar vertically (frame + bar padding).
  static const double _cardHeight = 68;
  static const double _framePadV = 6;
  static const double _barPadV = 2;
  static const double _avatarExtent =
      _cardHeight - 2 * _framePadV - 2 * _barPadV;

  @override
  Widget build(BuildContext context) {
    final l10n = GameSessionLocalizations.of(context)!;
    final isActive = card.isActiveTurn;
    final isDisconnected = card.isDisconnected;
    final isVirtual = card.isVirtual;
    final playerColor = Color(int.parse(card.color));

    final backgroundImage = card.team.when(
      none: () => null,
      some: GameTeamConstants.backgroundAssetFor,
    );

    Widget cardFace = SizedBox(
      height: _cardHeight,
      width: double.infinity,
      child: ClipPath(
        clipper: GamePlayerCardsHudCardClipper(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF660000), Color(0xFF990000)],
                ),
                image: backgroundImage != null
                    ? DecorationImage(
                        image: AssetImage(backgroundImage),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            if (isVirtual) ...[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BFFF),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00BFFF).withValues(alpha: 0.6),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BFFF),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00BFFF).withValues(alpha: 0.6),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Positioned.fill(
              child: CustomPaint(
                painter: GamePlayerCardsHudCardPainter(
                  team: card.team,
                  isVirtual: isVirtual,
                  isActive: isActive,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: _framePadV,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: _barPadV,
                ),
                child: Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: _avatarExtent,
                          height: _avatarExtent,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xFF2A2A2A),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ColorFiltered(
                                colorFilter: const ColorFilter.matrix([
                                  2.5, 0, 0, 0, 0,
                                  0, 2.5, 0, 0, 0,
                                  0, 0, 2.5, 0, 0,
                                  0, 0, 0, 1, 0,
                                ]),
                                child: Image.asset(
                                  AvatarAssets.avatarPath(card.avatar),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.35),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                            color: playerColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (card.hasFlag) ...[
                          const SizedBox(width: 6),
                          Image.asset(
                            UiAssets.flagIcon,
                            width: 24,
                            height: 24,
                            color: Colors.white,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  card.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isVirtual
                                        ? const Color(0xFF00BFFF)
                                        : Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'CustomFont',
                                    decoration: isDisconnected
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    decorationColor: Colors.black87,
                                    decorationThickness: 2,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black87,
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (isVirtual) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00BFFF)
                                        .withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00BFFF)
                                            .withValues(alpha: 0.7),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    l10n.gamePlayersListVirtual,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'CustomFont',
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              if (isActive)
                                Text(
                                  l10n.gamePlayersListPlaying,
                                  style: const TextStyle(
                                    color: Color(0xFFC89B05),
                                    fontSize: 11,
                                    fontFamily: 'CustomFont',
                                    height: 1.1,
                                  ),
                                ),
                              if (isActive) const SizedBox(width: 6),
                              Text(
                                '${card.fightsWon}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 11,
                                  fontFamily: 'CustomFont',
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (card.isHost)
                      Image.asset(UiAssets.hostBadge, width: 24, height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (isDisconnected) {
      cardFace = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 0.85, 0,
        ]),
        child: cardFace,
      );
    }

    return cardFace;
  }
}
