import 'package:fpdart/fpdart.dart';

sealed class GameCombatState {
  const GameCombatState();

  int get combatCountdown;
  int get flightAttemptsLeft;
  Option<bool> get lastFlightAttemptSuccess;

  bool get isCombatMode =>
      this is CombatActive || this is CombatWithResult || this is CombatResolved;

  Option<String> get combatRoomId => switch (this) {
    CombatActive() => (this as CombatActive).combatRoomId,
    CombatResolved() => (this as CombatResolved).combatRoomId,
    CombatIdle() => const Option.none(),
  };

  Option<String> get attackerId => switch (this) {
    CombatActive() => (this as CombatActive).attackerId,
    CombatResolved() => (this as CombatResolved).attackerId,
    CombatIdle() => const Option.none(),
  };

  Option<String> get defenderId => switch (this) {
    CombatActive() => (this as CombatActive).defenderId,
    CombatResolved() => (this as CombatResolved).defenderId,
    CombatIdle() => const Option.none(),
  };

  Option<String> get currentPlayerId => switch (this) {
    CombatActive() => (this as CombatActive).currentPlayerId,
    CombatResolved() => (this as CombatResolved).currentPlayerId,
    CombatIdle() => const Option.none(),
  };

  Option<String> get currentOpponentId => switch (this) {
    CombatActive() => (this as CombatActive).currentOpponentId,
    CombatResolved() => (this as CombatResolved).currentOpponentId,
    CombatIdle() => const Option.none(),
  };

  Option<bool> get lastAttackSuccess => switch (this) {
    CombatWithResult() => (this as CombatWithResult).lastAttackSuccess,
    CombatActive() => const Option.none(),
    CombatResolved() => const Option.none(),
    CombatIdle() => const Option.none(),
  };

  Option<int> get lastAttackValue => switch (this) {
    CombatWithResult() => (this as CombatWithResult).lastAttackValue,
    CombatActive() => const Option.none(),
    CombatResolved() => const Option.none(),
    CombatIdle() => const Option.none(),
  };

  Option<int> get lastDefenseValue => switch (this) {
    CombatWithResult() => (this as CombatWithResult).lastDefenseValue,
    CombatActive() => const Option.none(),
    CombatResolved() => const Option.none(),
    CombatIdle() => const Option.none(),
  };

  const factory GameCombatState.initial() = CombatIdle;

  T when<T>({
    required T Function(CombatIdle) idle,
    required T Function(CombatActive) active,
    required T Function(CombatWithResult) withResult,
    required T Function(CombatResolved) resolved,
  }) => switch (this) {
    CombatIdle() => idle(this as CombatIdle),
    CombatWithResult() => withResult(this as CombatWithResult),
    CombatResolved() => resolved(this as CombatResolved),
    CombatActive() => active(this as CombatActive),
  };
}

final class CombatIdle extends GameCombatState {
  @override
  final int combatCountdown;
  @override
  final int flightAttemptsLeft;
  @override
  final Option<bool> lastFlightAttemptSuccess;

  const CombatIdle({
    this.combatCountdown = 0,
    this.flightAttemptsLeft = 2,
    this.lastFlightAttemptSuccess = const Option.none(),
  });

  CombatIdle copyWith({int? combatCountdown, int? flightAttemptsLeft}) {
    return CombatIdle(
      combatCountdown: combatCountdown ?? this.combatCountdown,
      flightAttemptsLeft: flightAttemptsLeft ?? this.flightAttemptsLeft,
    );
  }
}

final class CombatActive extends GameCombatState {
  final String _combatRoomId;
  final String _attackerId;
  final String _defenderId;
  final String _currentPlayerId;
  final String _currentOpponentId;
  @override
  final int combatCountdown;
  @override
  final int flightAttemptsLeft;
  @override
  final Option<bool> lastFlightAttemptSuccess;

  @override
  Option<String> get combatRoomId => Option.of(_combatRoomId);

  @override
  Option<String> get attackerId => Option.of(_attackerId);

  @override
  Option<String> get defenderId => Option.of(_defenderId);

  @override
  Option<String> get currentPlayerId => Option.of(_currentPlayerId);

  @override
  Option<String> get currentOpponentId => Option.of(_currentOpponentId);

  String get combatRoomIdRaw => _combatRoomId;
  String get attackerIdRaw => _attackerId;
  String get defenderIdRaw => _defenderId;
  String get currentPlayerIdRaw => _currentPlayerId;
  String get currentOpponentIdRaw => _currentOpponentId;

  const CombatActive({
    required String combatRoomId,
    required String attackerId,
    required String defenderId,
    required String currentPlayerId,
    required String currentOpponentId,
    required this.combatCountdown,
    this.flightAttemptsLeft = 2,
    this.lastFlightAttemptSuccess = const Option.none(),
  }) : _combatRoomId = combatRoomId,
       _attackerId = attackerId,
       _defenderId = defenderId,
       _currentPlayerId = currentPlayerId,
       _currentOpponentId = currentOpponentId;

  CombatActive copyWith({
    String? combatRoomId,
    String? attackerId,
    String? defenderId,
    String? currentPlayerId,
    String? currentOpponentId,
    int? combatCountdown,
    int? flightAttemptsLeft,
    Option<bool>? lastFlightAttemptSuccess,
  }) {
    return CombatActive(
      combatRoomId: combatRoomId ?? _combatRoomId,
      attackerId: attackerId ?? _attackerId,
      defenderId: defenderId ?? _defenderId,
      currentPlayerId: currentPlayerId ?? _currentPlayerId,
      currentOpponentId: currentOpponentId ?? _currentOpponentId,
      combatCountdown: combatCountdown ?? this.combatCountdown,
      flightAttemptsLeft: flightAttemptsLeft ?? this.flightAttemptsLeft,
      lastFlightAttemptSuccess:
          lastFlightAttemptSuccess ?? this.lastFlightAttemptSuccess,
    );
  }
}

/// Post-combat outcome overlay (participants only); clears to [CombatIdle] after a delay.
final class CombatResolved extends GameCombatState {
  final String _combatRoomId;
  final String _attackerId;
  final String _defenderId;
  final String _currentPlayerId;
  final String _currentOpponentId;
  final String winnerId;
  final String loserId;
  final bool isByFlight;
  @override
  final int combatCountdown;
  @override
  final int flightAttemptsLeft;
  @override
  final Option<bool> lastFlightAttemptSuccess;

  @override
  Option<String> get combatRoomId => Option.of(_combatRoomId);

  @override
  Option<String> get attackerId => Option.of(_attackerId);

  @override
  Option<String> get defenderId => Option.of(_defenderId);

  @override
  Option<String> get currentPlayerId => Option.of(_currentPlayerId);

  @override
  Option<String> get currentOpponentId => Option.of(_currentOpponentId);

  String get combatRoomIdRaw => _combatRoomId;
  String get attackerIdRaw => _attackerId;
  String get defenderIdRaw => _defenderId;
  String get currentPlayerIdRaw => _currentPlayerId;
  String get currentOpponentIdRaw => _currentOpponentId;

  const CombatResolved({
    required String combatRoomId,
    required String attackerId,
    required String defenderId,
    required String currentPlayerId,
    required String currentOpponentId,
    required this.combatCountdown,
    required this.flightAttemptsLeft,
    required this.winnerId,
    required this.loserId,
    required this.isByFlight,
    this.lastFlightAttemptSuccess = const Option.none(),
  }) : _combatRoomId = combatRoomId,
       _attackerId = attackerId,
       _defenderId = defenderId,
       _currentPlayerId = currentPlayerId,
       _currentOpponentId = currentOpponentId;
}

final class CombatWithResult extends CombatActive {
  final String _lastActorId;
  final String _lastTargetId;
  final bool _lastAttackSuccess;
  final int _lastOpponentHealthPoints;
  final int _lastAttackValue;
  final int _lastDefenseValue;

  String get lastActorIdRaw => _lastActorId;
  String get lastTargetIdRaw => _lastTargetId;

  @override
  Option<bool> get lastAttackSuccess => Option.of(_lastAttackSuccess);

  int get lastOpponentHealthPoints => _lastOpponentHealthPoints;

  @override
  Option<int> get lastAttackValue => Option.of(_lastAttackValue);

  @override
  Option<int> get lastDefenseValue => Option.of(_lastDefenseValue);

  const CombatWithResult({
    required super.combatRoomId,
    required super.attackerId,
    required super.defenderId,
    required super.currentPlayerId,
    required super.currentOpponentId,
    required super.combatCountdown,
    super.flightAttemptsLeft,
    super.lastFlightAttemptSuccess,
    required String lastActorId,
    required String lastTargetId,
    required bool lastAttackSuccess,
    required int lastOpponentHealthPoints,
    required int lastAttackValue,
    required int lastDefenseValue,
  }) : _lastActorId = lastActorId,
       _lastTargetId = lastTargetId,
       _lastAttackSuccess = lastAttackSuccess,
       _lastOpponentHealthPoints = lastOpponentHealthPoints,
       _lastAttackValue = lastAttackValue,
       _lastDefenseValue = lastDefenseValue;

  @override
  CombatWithResult copyWith({
    String? combatRoomId,
    String? attackerId,
    String? defenderId,
    String? currentPlayerId,
    String? currentOpponentId,
    int? combatCountdown,
    int? flightAttemptsLeft,
    Option<bool>? lastFlightAttemptSuccess,
    String? lastActorId,
    String? lastTargetId,
    bool? lastAttackSuccess,
    int? lastOpponentHealthPoints,
    int? lastAttackValue,
    int? lastDefenseValue,
  }) {
    return CombatWithResult(
      combatRoomId: combatRoomId ?? combatRoomIdRaw,
      attackerId: attackerId ?? attackerIdRaw,
      defenderId: defenderId ?? defenderIdRaw,
      currentPlayerId: currentPlayerId ?? currentPlayerIdRaw,
      currentOpponentId: currentOpponentId ?? currentOpponentIdRaw,
      combatCountdown: combatCountdown ?? this.combatCountdown,
      flightAttemptsLeft: flightAttemptsLeft ?? this.flightAttemptsLeft,
      lastFlightAttemptSuccess:
          lastFlightAttemptSuccess ?? this.lastFlightAttemptSuccess,
      lastActorId: lastActorId ?? _lastActorId,
      lastTargetId: lastTargetId ?? _lastTargetId,
      lastAttackSuccess: lastAttackSuccess ?? _lastAttackSuccess,
      lastOpponentHealthPoints:
          lastOpponentHealthPoints ?? _lastOpponentHealthPoints,
      lastAttackValue: lastAttackValue ?? _lastAttackValue,
      lastDefenseValue: lastDefenseValue ?? _lastDefenseValue,
    );
  }
}
