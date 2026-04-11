import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/constants/character_assets.dart';
import '../../../../../core/constants/stat_assets.dart';
import '../../../../../core/constants/ui_assets.dart';
import '../../../../../core/enums/character.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../../core/constants/character_creation_constants.dart';
import '../../../core/context/character_creation_scope_holder.dart';
import '../../../core/helpers/character_creation_form_validator.dart';
import '../../../core/localisation/character_creation_localizations.dart';
import 'character_creation_view_model.dart';

@RoutePage()
class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  State<CharacterCreationScreen> createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  late final CharacterCreationViewModel _viewModel;
  final ScrollController _gridScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<CharacterCreationScopeHolder>().scope!
        .get<CharacterCreationViewModel>();
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _gridScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = CharacterCreationLocalizations.of(context)!;
    return AppBackground(
      child: Stack(
        children: [
          Column(
            children: [
              _CharacterCreationHeader(
                title: l10n.createPlayerTitle,
                onBackTap: _viewModel.requestExitToCreateGame,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 900) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _CharacterGrid(
                              viewModel: _viewModel,
                              scrollController: _gridScrollController,
                              maxHeight: 420,
                            ),
                            const SizedBox(height: 24),
                            _CenterColumn(viewModel: _viewModel),
                            const SizedBox(height: 24),
                            _BonusSection(
                              viewModel: _viewModel,
                              maxHeight: 420,
                            ),
                          ],
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 560,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _CharacterGrid(
                                viewModel: _viewModel,
                                scrollController: _gridScrollController,
                                maxHeight: 560,
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: Center(
                                child: _CenterColumn(viewModel: _viewModel),
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: _BonusSection(
                                viewModel: _viewModel,
                                maxHeight: 560,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CharacterCreationHeader extends StatelessWidget {
  const _CharacterCreationHeader({
    required this.title,
    required this.onBackTap,
  });

  final String title;
  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    final l10n = CharacterCreationLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                  onTap: onBackTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          UiAssets.characterCreationBackArrowIcon,
                          width: 15,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          l10n.backToCreateGame,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CustomFont',
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
            title,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'CustomFont',
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class _CharacterGrid extends StatelessWidget {
  const _CharacterGrid({
    required this.viewModel,
    required this.scrollController,
    required this.maxHeight,
  });

  final CharacterCreationViewModel viewModel;
  final ScrollController scrollController;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final l10n = CharacterCreationLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2b2b2b),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF444444), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10),
        ],
      ),
      constraints: BoxConstraints(maxWidth: 800, maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.charactersSectionTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(
                thickness: WidgetStateProperty.all(6),
                radius: const Radius.circular(5),
                thumbColor: WidgetStateProperty.all(
                  context.interactionColors.outline,
                ),
                trackColor: WidgetStateProperty.all(const Color(0xFF2b2b2b)),
                trackBorderColor: WidgetStateProperty.all(
                  const Color(0xFF2b2b2b),
                ),
              ),
              child: Watch((context) {
                final characters = viewModel.charactersForGrid;
                final state = viewModel.creationState.value;
                final selectedId = state.form.selectedCharacterId.fold(
                  () => '',
                  (id) => id,
                );
                return Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.only(right: 12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final character = characters[index];
                      return _CharacterCard(
                        character: character,
                        isSelected: selectedId == character.id,
                        isDisabled: viewModel.isCharacterDisabled(character),
                        onTap: () => viewModel.selectCharacter(character),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  const _CharacterCard({
    required this.character,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  final Character character;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? const Color(0xFF7f1f1f)
        : const Color(0xFF444444);
    return Material(
      color: Colors.black.withValues(alpha: isDisabled ? 0.16 : 0.278),
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.grey.withValues(alpha: isDisabled ? 1 : 0),
                      BlendMode.saturation,
                    ),
                    child: Opacity(
                      opacity: isDisabled ? 0.5 : 1,
                      child: Image.asset(
                        CharacterAssets.characterAvatarPath(character),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              UiAssets.characterCreationEmptyPortrait,
                              fit: BoxFit.cover,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                character.displayName,
                style: const TextStyle(
                  color: Color(0xFFf5e6e6),
                  fontSize: 14,
                  fontFamily: 'CustomFont',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterColumn extends StatelessWidget {
  const _CenterColumn({required this.viewModel});

  final CharacterCreationViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = CharacterCreationLocalizations.of(context)!;
    return Watch((context) {
      final form = viewModel.creationState.value.form;
      final selectedCharacterId = form.selectedCharacterId;
      final character = selectedCharacterId.fold(() => null, Character.fromId);
      final characterName = character == null
          ? l10n.chooseCharacterPlaceholder
          : character.displayName;
      final avatarPath = character == null
          ? UiAssets.characterCreationEmptyPortrait
          : CharacterAssets.characterAvatarFullPath(character);
      final healthPreview = form.health;
      final speedPreview = form.speed;
      final attackPreview = form.attackDice;
      final defensePreview = form.defenseDice;
      return SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.278),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.black.withValues(alpha: 0.1),
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      height: 220,
                      child: Image.asset(
                        avatarPath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              UiAssets.characterCreationEmptyPortrait,
                              fit: BoxFit.contain,
                            ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.black.withValues(alpha: 0.7),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      characterName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'CustomFont',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.black.withValues(alpha: 0.7),
                    child: Row(
                      children: [
                        _PreviewStatCell(
                          label: l10n.statHealth,
                          value: healthPreview,
                        ),
                        _PreviewStatCell(
                          label: l10n.statSpeed,
                          value: speedPreview,
                        ),
                        _PreviewStatCell(
                          label: l10n.statAttack,
                          value: attackPreview,
                        ),
                        _PreviewStatCell(
                          label: l10n.statDefense,
                          value: defensePreview,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _SubmitButton(viewModel: viewModel),
          ],
        ),
      );
    });
  }
}

class _PreviewStatCell extends StatelessWidget {
  const _PreviewStatCell({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final int value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          border: Border(
            right: isLast
                ? BorderSide.none
                : BorderSide(color: Colors.black.withValues(alpha: 0.5)),
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xCCFFFFFF),
                fontSize: 12,
                fontFamily: 'CustomFont',
              ),
            ),
            Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'CustomFont',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.viewModel});

  final CharacterCreationViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = CharacterCreationLocalizations.of(context)!;
    return Watch((context) {
      final isSubmitting = viewModel.isSubmitting;
      final buttonLabel = viewModel.isHost
          ? l10n.createGameButton
          : l10n.accessWaitingRoomButton;
      return SizedBox(
        width: 300,
        child: ElevatedButton(
          onPressed: isSubmitting
              ? null
              : () async {
                  await viewModel.submitCharacter();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: context.interactionColors.outline,
                width: 2,
              ),
            ),
            elevation: 0,
          ),
          child: isSubmitting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                )
              : Text(
                  buttonLabel,
                  style: const TextStyle(
                    fontFamily: 'CustomFont',
                    fontSize: 16,
                  ),
                ),
        ),
      );
    });
  }
}

class _BonusSection extends StatelessWidget {
  const _BonusSection({required this.viewModel, required this.maxHeight});

  final CharacterCreationViewModel viewModel;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final l10n = CharacterCreationLocalizations.of(context)!;
    return Container(
      constraints: BoxConstraints(maxWidth: 400, maxHeight: maxHeight),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2b2b2b),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF444444), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.playerHudStatsSection,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2b2b2b),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF444444), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Watch((context) {
              final form = viewModel.creationState.value.form;
              final hasDicePair =
                  CharacterCreationFormValidator.hasValidDicePairing(form);
              return Column(
                children: [
                  _StatRow(
                    label: l10n.statHealth,
                    description: l10n.statHealthDescription,
                    value: form.health,
                    isSelected:
                        CharacterCreationFormValidator.isHealthBonusChoiceActive(
                          form,
                        ),
                    onTap: viewModel.selectHealthBonus,
                  ),
                  const SizedBox(height: 20),
                  _StatRow(
                    label: l10n.statSpeed,
                    description: l10n.statSpeedDescription,
                    value: form.speed,
                    isSelected:
                        CharacterCreationFormValidator.isSpeedBonusChoiceActive(
                          form,
                        ),
                    onTap: viewModel.selectSpeedBonus,
                  ),
                  const SizedBox(height: 20),
                  _DiceRow(
                    label: l10n.statAttack,
                    description: l10n.statAttackDescription,
                    value: form.attackDice,
                    isD4Selected:
                        hasDicePair &&
                        form.attackDice == CharacterCreationConstants.d4Value,
                    isD6Selected:
                        hasDicePair &&
                        form.attackDice == CharacterCreationConstants.d6Value,
                    onSelectD4: () => viewModel.selectAttackDice(
                      CharacterCreationConstants.d4Value,
                    ),
                    onSelectD6: () => viewModel.selectAttackDice(
                      CharacterCreationConstants.d6Value,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _DiceRow(
                    label: l10n.statDefense,
                    description: l10n.statDefenseDescription,
                    value: form.defenseDice,
                    isD4Selected:
                        hasDicePair &&
                        form.defenseDice == CharacterCreationConstants.d4Value,
                    isD6Selected:
                        hasDicePair &&
                        form.defenseDice == CharacterCreationConstants.d6Value,
                    onSelectD4: () => viewModel.selectDefenseDice(
                      CharacterCreationConstants.d4Value,
                    ),
                    onSelectD6: () => viewModel.selectDefenseDice(
                      CharacterCreationConstants.d6Value,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.description,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String description;
  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontFamily: 'CustomFont',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'CustomFont',
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          '$value',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontFamily: 'CustomFont',
          ),
        ),
        const SizedBox(width: 16),
        _StatBonusButton(isSelected: isSelected, onTap: onTap),
      ],
    );
  }
}

class _StatBonusButton extends StatelessWidget {
  const _StatBonusButton({required this.isSelected, required this.onTap});

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3c3c3c) : const Color(0xFF444444),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0xFF555555)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.interactionColors.primaryStrong.withValues(
                      alpha: 0.5,
                    ),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: const Text(
          '+2',
          style: TextStyle(color: Colors.white, fontFamily: 'CustomFont'),
        ),
      ),
    );
  }
}

class _DiceRow extends StatelessWidget {
  const _DiceRow({
    required this.label,
    required this.description,
    required this.value,
    required this.isD4Selected,
    required this.isD6Selected,
    required this.onSelectD4,
    required this.onSelectD6,
  });

  final String label;
  final String description;
  final int value;
  final bool isD4Selected;
  final bool isD6Selected;
  final VoidCallback onSelectD4;
  final VoidCallback onSelectD6;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontFamily: 'CustomFont',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFc0c0c0),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'CustomFont',
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          '$value',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontFamily: 'CustomFont',
          ),
        ),
        const SizedBox(width: 12),
        _DiceButton(
          imagePath: StatAssets.diceD4,
          isSelected: isD4Selected,
          onTap: onSelectD4,
        ),
        const SizedBox(width: 12),
        _DiceButton(
          imagePath: StatAssets.diceD6,
          isSelected: isD6Selected,
          onTap: onSelectD6,
        ),
      ],
    );
  }
}

class _DiceButton extends StatelessWidget {
  const _DiceButton({
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3c3c3c) : const Color(0xFF444444),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0xFF555555)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.interactionColors.primaryStrong.withValues(
                      alpha: 0.5,
                    ),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              1.6,
              0,
              0,
              0,
              0,
              0,
              1.6,
              0,
              0,
              0,
              0,
              0,
              1.6,
              0,
              0,
              0,
              0,
              0,
              1,
              0,
            ]),
            child: Image.asset(imagePath),
          ),
        ),
      ),
    );
  }
}
