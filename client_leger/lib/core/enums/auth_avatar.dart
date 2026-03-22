enum AuthAvatar {
  usNavySEAL('USNavySEAL'),
  agentSpetsnaz('agentSpetsnaz'),
  commandoSAS('commandoSAS'),
  gardeFrontiere('gardeFrontiere'),
  milicien('milicien'),
  officierAllemand('officierAllemand'),
  operateurRadio('operateurRadio'),
  parachutiste('parachutiste'),
  pilote('pilote'),
  sergent('sergent'),
  specialisteSovietique('specialisteSovietique'),
  tankiste('tankiste');

  const AuthAvatar(this.id);

  final String id;
}
