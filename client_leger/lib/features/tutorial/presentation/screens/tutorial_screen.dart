import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../core/localisation/tutorial_localizations.dart';
import '../../data/models/tutorial_state.dart';
import '../../data/models/tutorial_step_model.dart';
import 'tutorial_view_model.dart';

@RoutePage()
class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late final TutorialViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<TutorialViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_viewModel.load());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = _viewModel.state.watch(context);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: switch (state) {
            TutorialStateLoading() => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            TutorialStateError() => _buildError(),
            TutorialStateLoaded(:final currentStep, :final totalSteps) =>
              _buildTutorial(currentStep, totalSteps),
          },
        ),
      ),
    );
  }

  Widget _buildTutorial(int currentStep, int totalSteps) {
    final l10n = TutorialLocalizations.of(context)!;
    final step = _viewModel.steps[currentStep];
    final isFirst = currentStep == 0;
    final isLast = currentStep == totalSteps - 1;

    return Column(
      children: [
        _buildHeader(currentStep, totalSteps, l10n),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildStepContent(step, currentStep, l10n),
          ),
        ),
        _buildNavigation(isFirst: isFirst, isLast: isLast, l10n: l10n),
      ],
    );
  }

  Widget _buildHeader(
    int currentStep,
    int totalSteps,
    TutorialLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${currentStep + 1} / $totalSteps',
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: 'CustomFont',
              fontSize: 14,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              totalSteps,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == currentStep ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == currentStep
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 48), // Placeholder for alignment
        ],
      ),
    );
  }

  Widget _buildStepContent(
    TutorialStepModel step,
    int index,
    TutorialLocalizations l10n,
  ) {
    return SingleChildScrollView(
      key: ValueKey(index),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            getLocalizedString(context, step.titleKey),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'CustomFont',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 8),
          Container(
            height: 600,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                l10n.localeName == 'fr'
                    ? '${step.image}.png'
                    : '${step.image}_en.png',
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Text(
              getLocalizedString(context, step.descriptionKey),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'CustomFont',
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNavigation({
    required bool isFirst,
    required bool isLast,
    required TutorialLocalizations l10n,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => unawaited(_viewModel.previousStep()),
              icon: Icon(
                Icons.chevron_left,
                color: isFirst ? Colors.white10 : Colors.white,
              ),
              label: Text(
                l10n.previous,
                style: TextStyle(
                  color: isFirst ? Colors.white10 : Colors.white,
                  fontFamily: 'CustomFont',
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isFirst ? Colors.white10 : Colors.white,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => unawaited(_viewModel.nextStep()),
              icon: Icon(isLast ? Icons.check : Icons.chevron_right),
              label: Text(
                isLast ? l10n.finish : l10n.next,
                style: const TextStyle(
                  fontFamily: 'CustomFont',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Impossible de charger le tutoriel.',
            style: TextStyle(color: Colors.white, fontFamily: 'CustomFont'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _viewModel.exit,
            child: const Text('Retour au menu'),
          ),
        ],
      ),
    );
  }
}

String getLocalizedString(BuildContext context, String key) {
  final l10n = TutorialLocalizations.of(context)!;
  switch (key) {
    case 'profileTitle':
      return l10n.profileTitle;
    case 'profileDesc':
      return l10n.profileDesc;
    case 'friendsTitle':
      return l10n.friendsTitle;
    case 'friendsDesc':
      return l10n.friendsDesc;
    case 'chatTitle':
      return l10n.chatTitle;
    case 'chatDesc':
      return l10n.chatDesc;
    case 'shopTitle':
      return l10n.shopTitle;
    case 'shopDesc':
      return l10n.shopDesc;
    case 'gameModesTitle':
      return l10n.gameModesTitle;
    case 'gameModesDesc':
      return l10n.gameModesDesc;
    case 'createGameTitle':
      return l10n.createGameTitle;
    case 'createGameDesc':
      return l10n.createGameDesc;
    case 'joinGameTitle':
      return l10n.joinGameTitle;
    case 'joinGameDesc':
      return l10n.joinGameDesc;
    default:
      return key;
  }
}
