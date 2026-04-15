class TutorialStepModel {
  const TutorialStepModel({
    required this.titleKey,
    required this.descriptionKey,
    required this.image,
  });

  final String titleKey;
  final String descriptionKey;
  final String image;
}

const kTutorialSteps = [
  TutorialStepModel(
    titleKey: 'profileTitle',
    descriptionKey: 'profileDesc',
    image: 'assets/images/tutorial/background.png',
  ),
  TutorialStepModel(
    titleKey: 'friendsTitle',
    descriptionKey: 'friendsDesc',
    image: 'assets/images/tutorial/background.png',
  ),
  TutorialStepModel(
    titleKey: 'chatTitle',
    descriptionKey: 'chatDesc',
    image: 'assets/images/tutorial/background.png',
  ),
  TutorialStepModel(
    titleKey: 'shopTitle',
    descriptionKey: 'shopDesc',
    image: 'assets/images/tutorial/background.png',
  ),
  TutorialStepModel(
    titleKey: 'gameModesTitle',
    descriptionKey: 'gameModesDesc',
    image: 'assets/images/tutorial/background.png',
  ),
  TutorialStepModel(
    titleKey: 'createGameTitle',
    descriptionKey: 'createGameDesc',
    image: 'assets/images/tutorial/background.png',
  ),
  TutorialStepModel(
    titleKey: 'joinGameTitle',
    descriptionKey: 'joinGameDesc',
    image: 'assets/images/tutorial/background.png',
  ),
];
