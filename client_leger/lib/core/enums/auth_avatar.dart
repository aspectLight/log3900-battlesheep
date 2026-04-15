enum AuthAvatar {
  esportsGamer('esportsGamer'),
  raceCarDriver('raceCarDriver'),
  cyberpunkTechie('cyberpunkTechie'),
  secretAgent('secretAgent'),
  survivalist('survivalist'),
  dj('dj'),
  skateboarder('skateboarder'),
  mechanic('mechanic'),
  detective('detective'),
  streetFighter('streetFighter'),
  tacticalOperator('tacticalOperator'),
  screamGhostface('screamGhostface');

  const AuthAvatar(this.id);

  final String id;

  bool get isExclusiveAtSignUp =>
      this == AuthAvatar.streetFighter ||
      this == AuthAvatar.tacticalOperator ||
      this == AuthAvatar.screamGhostface;
}
