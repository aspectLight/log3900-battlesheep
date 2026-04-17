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
    image: 'assets/images/tutorial/profile',
  ),
  TutorialStepModel(
    titleKey: 'friendsTitle',
    descriptionKey: 'friendsDesc',
    image: 'assets/images/tutorial/friends',
  ),
  TutorialStepModel(
    titleKey: 'chatTitle',
    descriptionKey: 'chatDesc',
    image: 'assets/images/tutorial/chat',
  ),
  TutorialStepModel(
    titleKey: 'shopTitle',
    descriptionKey: 'shopDesc',
    image: 'assets/images/tutorial/shop',
  ),
  TutorialStepModel(
    titleKey: 'gameModesTitle',
    descriptionKey: 'gameModesDesc',
    image: 'assets/images/tutorial/game_modes',
  ),
  TutorialStepModel(
    titleKey: 'createGameTitle',
    descriptionKey: 'createGameDesc',
    image: 'assets/images/tutorial/create_game',
  ),
  TutorialStepModel(
    titleKey: 'joinGameTitle',
    descriptionKey: 'joinGameDesc',
    image: 'assets/images/tutorial/join_game',
  ),
];
