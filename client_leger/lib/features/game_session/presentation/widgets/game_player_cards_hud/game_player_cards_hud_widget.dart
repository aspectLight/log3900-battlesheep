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

    return Container(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Distribute cards across the full available WIDTH,
          // but keep a fixed vertical size for each card.
          final maxWidth = constraints.maxWidth;

          // Fixed card height (no vertical stretching).
          const cardHeight = 270.0;

          // Spread cards evenly across the width, leaving a small gap.
          const gap = 12.0;
          final totalGapWidth =
              cards.length > 1 ? gap * (cards.length - 1) : 0.0;
          final availableWidth = (maxWidth - totalGapWidth).clamp(0.0, maxWidth);
          final cardWidth =
              cards.isNotEmpty ? availableWidth / cards.length : 0.0;

          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: cardHeight,
              width: maxWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < cards.length; i++)
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: _PlayerCardsHudCard(
                        card: cards[i],
                        width: cardWidth,
                        height: cardHeight,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PlayerCardsHudCard extends StatelessWidget {
  final GamePlayerUiCard card;
  final double width;
  final double height;

  const _PlayerCardsHudCard({
    required this.card,
    required this.width,
    required this.height,
  });

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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
      transform: isActive
          ? (Matrix4.diagonal3Values(1.05, 1.05, 1)
              ..setTranslationRaw(0, 40, 0))
          : Matrix4.identity(),
      child: PhysicalShape(
        clipper: GamePlayerCardsHudCardClipper(),
        color: Colors.transparent,
        elevation: isActive ? 20 : 5,
        child: ClipPath(
          clipper: GamePlayerCardsHudCardClipper(),
          child: Container(
            width: width,
            height: height,
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
                      alignment: Alignment.topLeft,
                    )
                  : null,
            ),
            child: Opacity(
              opacity: isDisconnected ? 0.7 : 1.0,
              child: Stack(
                children: [
                  Container(color: Colors.black.withValues(alpha: 0.5)),

                  Positioned.fill(
                    child: CustomPaint(
                      painter: GamePlayerCardsHudCardPainter(
                        team: card.team,
                        isVirtual: isVirtual,
                        isActive: isActive,
                      ),
                    ),
                  ),

                  if (isActive)
                    Positioned(
                      top: 60,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          l10n.gamePlayersListPlaying,
                          style: const TextStyle(
                            color: Color(0xFFCCCCCC),
                            fontSize: 12,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                      ),
                    ),

                  if (card.isHost)
                    Positioned(
                      top: 75,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.asset(UiAssets.hostBadge, width: 15),
                      ),
                    ),

                  if (isVirtual)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF00BFFF),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF00BFFF,
                              ).withValues(alpha: 0.6),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.gamePlayersListVirtual,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'CustomFont',
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  Positioned(
                    top: 92,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: playerColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                  if (card.hasFlag)
                    Positioned(
                      top: 73,
                      left: width * 0.65 - 15,
                      child: Image.asset(
                        UiAssets.flagIcon,
                        width: 30,
                        height: 30,
                        color: Colors.white,
                        colorBlendMode: BlendMode.srcIn,
                      ),
                    ),

                  Positioned(
                    top: 110,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          card.name,
                          style: TextStyle(
                            color: isVirtual
                                ? const Color(0xFF00BFFF)
                                : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CustomFont',
                            decoration: isDisconnected
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: isDisconnected
                                ? Colors.black
                                : null,
                            decorationThickness: isDisconnected ? 2.0 : null,
                            shadows: const [
                              Shadow(
                                color: Colors.black87,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 50,
                          height: 2,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color(0xFFFFD700),
                                Colors.transparent,
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                offset: Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: 145,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFF333333),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: const Color(0xFF333333)),
                          boxShadow: const [
                            BoxShadow(color: Colors.black54, blurRadius: 5),
                          ],
                          image: DecorationImage(
                            image: AssetImage(
                              AvatarAssets.avatarPath(card.avatar),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 220,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        '${card.fightsWon}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'CustomFont',
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(offset: Offset(0, 2), blurRadius: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
