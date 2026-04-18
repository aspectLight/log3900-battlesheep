import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../../core/app_transition/app_transition_bus.dart';
import '../../core/app_transition/tutorial_events.dart';
import '../../data/models/tutorial_state.dart';
import '../../data/models/tutorial_step_model.dart';
import '../../data/services/http_tutorial_service.dart';

class TutorialViewModel {
  TutorialViewModel({
    required HttpTutorialService tutorialService,
    required AppTransitionEventBus appTransitionEventBus,
  }) : _tutorialService = tutorialService,
       _appTransitionEventBus = appTransitionEventBus;

  final HttpTutorialService _tutorialService;
  final AppTransitionEventBus _appTransitionEventBus;

  final Signal<TutorialState> state = signal(const TutorialStateLoading());
  final steps = kTutorialSteps;

  Future<void> load() async {
    final progress = await _tutorialService.fetchProgress();
    state.value = TutorialStateLoaded(
      currentStep: progress.started ? progress.step : 0,
      totalSteps: steps.length,
      started: progress.started,
    );
  }

  Future<void> nextStep() async {
    final s = state.value;
    if (s is! TutorialStateLoaded) return;
    final isLast = s.currentStep >= s.totalSteps - 1;
    if (isLast) {
      await _tutorialService.saveProgress(step: s.totalSteps - 1);
      exit();
      return;
    }
    final next = s.currentStep + 1;
    state.value = TutorialStateLoaded(
      currentStep: next,
      totalSteps: s.totalSteps,
      started: s.started,
    );
    await _tutorialService.saveProgress(step: next);
  }

  Future<void> previousStep() async {
    final s = state.value;
    if (s is! TutorialStateLoaded || s.currentStep == 0) return;
    final prev = s.currentStep - 1;
    state.value = TutorialStateLoaded(
      currentStep: prev,
      totalSteps: s.totalSteps,
      started: s.started,
    );
    await _tutorialService.saveProgress(step: prev);
  }

  Future<void> restart() async {
    await _tutorialService.saveProgress(step: 0);
    await Future(() {
      state.value = TutorialStateLoaded(
        currentStep: 0,
        totalSteps: steps.length,
        started: true,
      );
    });
  }

  void exit() {
    _appTransitionEventBus.fire(const TutorialExitAppEvent.leaveRequested());
  }

  /// Close from the header: keep current step so the user can resume later.
  Future<void> dismiss() async {
    final s = state.value;
    if (s is TutorialStateLoaded) {
      await _tutorialService.saveProgress(step: s.currentStep);
    }
    exit();
  }
}
