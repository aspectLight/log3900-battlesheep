sealed class TutorialState {
  const TutorialState();
}

class TutorialStateLoading extends TutorialState {
  const TutorialStateLoading();
}

class TutorialStateLoaded extends TutorialState {
  const TutorialStateLoaded({
    required this.currentStep,
    required this.totalSteps,
    required this.started,
  });

  final int currentStep;
  final int totalSteps;
  final bool started;
}

class TutorialStateError extends TutorialState {
  const TutorialStateError();
}
