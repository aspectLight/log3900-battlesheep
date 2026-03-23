// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_combat_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AttackResultEvent {
  bool get isAttackSuccess => throw _privateConstructorUsedError;
  int get opponentHealthPoints => throw _privateConstructorUsedError;
  int get attackValue => throw _privateConstructorUsedError;
  int get defenseValue => throw _privateConstructorUsedError;

  /// Create a copy of AttackResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttackResultEventCopyWith<AttackResultEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttackResultEventCopyWith<$Res> {
  factory $AttackResultEventCopyWith(
    AttackResultEvent value,
    $Res Function(AttackResultEvent) then,
  ) = _$AttackResultEventCopyWithImpl<$Res, AttackResultEvent>;
  @useResult
  $Res call({
    bool isAttackSuccess,
    int opponentHealthPoints,
    int attackValue,
    int defenseValue,
  });
}

/// @nodoc
class _$AttackResultEventCopyWithImpl<$Res, $Val extends AttackResultEvent>
    implements $AttackResultEventCopyWith<$Res> {
  _$AttackResultEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttackResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAttackSuccess = null,
    Object? opponentHealthPoints = null,
    Object? attackValue = null,
    Object? defenseValue = null,
  }) {
    return _then(
      _value.copyWith(
            isAttackSuccess: null == isAttackSuccess
                ? _value.isAttackSuccess
                : isAttackSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
            opponentHealthPoints: null == opponentHealthPoints
                ? _value.opponentHealthPoints
                : opponentHealthPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            attackValue: null == attackValue
                ? _value.attackValue
                : attackValue // ignore: cast_nullable_to_non_nullable
                      as int,
            defenseValue: null == defenseValue
                ? _value.defenseValue
                : defenseValue // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttackResultEventImplCopyWith<$Res>
    implements $AttackResultEventCopyWith<$Res> {
  factory _$$AttackResultEventImplCopyWith(
    _$AttackResultEventImpl value,
    $Res Function(_$AttackResultEventImpl) then,
  ) = __$$AttackResultEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isAttackSuccess,
    int opponentHealthPoints,
    int attackValue,
    int defenseValue,
  });
}

/// @nodoc
class __$$AttackResultEventImplCopyWithImpl<$Res>
    extends _$AttackResultEventCopyWithImpl<$Res, _$AttackResultEventImpl>
    implements _$$AttackResultEventImplCopyWith<$Res> {
  __$$AttackResultEventImplCopyWithImpl(
    _$AttackResultEventImpl _value,
    $Res Function(_$AttackResultEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AttackResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAttackSuccess = null,
    Object? opponentHealthPoints = null,
    Object? attackValue = null,
    Object? defenseValue = null,
  }) {
    return _then(
      _$AttackResultEventImpl(
        isAttackSuccess: null == isAttackSuccess
            ? _value.isAttackSuccess
            : isAttackSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
        opponentHealthPoints: null == opponentHealthPoints
            ? _value.opponentHealthPoints
            : opponentHealthPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        attackValue: null == attackValue
            ? _value.attackValue
            : attackValue // ignore: cast_nullable_to_non_nullable
                  as int,
        defenseValue: null == defenseValue
            ? _value.defenseValue
            : defenseValue // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$AttackResultEventImpl implements _AttackResultEvent {
  const _$AttackResultEventImpl({
    required this.isAttackSuccess,
    required this.opponentHealthPoints,
    required this.attackValue,
    required this.defenseValue,
  });

  @override
  final bool isAttackSuccess;
  @override
  final int opponentHealthPoints;
  @override
  final int attackValue;
  @override
  final int defenseValue;

  @override
  String toString() {
    return 'AttackResultEvent(isAttackSuccess: $isAttackSuccess, opponentHealthPoints: $opponentHealthPoints, attackValue: $attackValue, defenseValue: $defenseValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttackResultEventImpl &&
            (identical(other.isAttackSuccess, isAttackSuccess) ||
                other.isAttackSuccess == isAttackSuccess) &&
            (identical(other.opponentHealthPoints, opponentHealthPoints) ||
                other.opponentHealthPoints == opponentHealthPoints) &&
            (identical(other.attackValue, attackValue) ||
                other.attackValue == attackValue) &&
            (identical(other.defenseValue, defenseValue) ||
                other.defenseValue == defenseValue));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isAttackSuccess,
    opponentHealthPoints,
    attackValue,
    defenseValue,
  );

  /// Create a copy of AttackResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttackResultEventImplCopyWith<_$AttackResultEventImpl> get copyWith =>
      __$$AttackResultEventImplCopyWithImpl<_$AttackResultEventImpl>(
        this,
        _$identity,
      );
}

abstract class _AttackResultEvent implements AttackResultEvent {
  const factory _AttackResultEvent({
    required final bool isAttackSuccess,
    required final int opponentHealthPoints,
    required final int attackValue,
    required final int defenseValue,
  }) = _$AttackResultEventImpl;

  @override
  bool get isAttackSuccess;
  @override
  int get opponentHealthPoints;
  @override
  int get attackValue;
  @override
  int get defenseValue;

  /// Create a copy of AttackResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttackResultEventImplCopyWith<_$AttackResultEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FlightAttemptResultEvent {
  bool get isSuccess => throw _privateConstructorUsedError;
  int get attackerEvasionPoints => throw _privateConstructorUsedError;

  /// Create a copy of FlightAttemptResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlightAttemptResultEventCopyWith<FlightAttemptResultEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlightAttemptResultEventCopyWith<$Res> {
  factory $FlightAttemptResultEventCopyWith(
    FlightAttemptResultEvent value,
    $Res Function(FlightAttemptResultEvent) then,
  ) = _$FlightAttemptResultEventCopyWithImpl<$Res, FlightAttemptResultEvent>;
  @useResult
  $Res call({bool isSuccess, int attackerEvasionPoints});
}

/// @nodoc
class _$FlightAttemptResultEventCopyWithImpl<
  $Res,
  $Val extends FlightAttemptResultEvent
>
    implements $FlightAttemptResultEventCopyWith<$Res> {
  _$FlightAttemptResultEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlightAttemptResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isSuccess = null, Object? attackerEvasionPoints = null}) {
    return _then(
      _value.copyWith(
            isSuccess: null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
            attackerEvasionPoints: null == attackerEvasionPoints
                ? _value.attackerEvasionPoints
                : attackerEvasionPoints // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FlightAttemptResultEventImplCopyWith<$Res>
    implements $FlightAttemptResultEventCopyWith<$Res> {
  factory _$$FlightAttemptResultEventImplCopyWith(
    _$FlightAttemptResultEventImpl value,
    $Res Function(_$FlightAttemptResultEventImpl) then,
  ) = __$$FlightAttemptResultEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isSuccess, int attackerEvasionPoints});
}

/// @nodoc
class __$$FlightAttemptResultEventImplCopyWithImpl<$Res>
    extends
        _$FlightAttemptResultEventCopyWithImpl<
          $Res,
          _$FlightAttemptResultEventImpl
        >
    implements _$$FlightAttemptResultEventImplCopyWith<$Res> {
  __$$FlightAttemptResultEventImplCopyWithImpl(
    _$FlightAttemptResultEventImpl _value,
    $Res Function(_$FlightAttemptResultEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlightAttemptResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isSuccess = null, Object? attackerEvasionPoints = null}) {
    return _then(
      _$FlightAttemptResultEventImpl(
        isSuccess: null == isSuccess
            ? _value.isSuccess
            : isSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
        attackerEvasionPoints: null == attackerEvasionPoints
            ? _value.attackerEvasionPoints
            : attackerEvasionPoints // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$FlightAttemptResultEventImpl implements _FlightAttemptResultEvent {
  const _$FlightAttemptResultEventImpl({
    required this.isSuccess,
    required this.attackerEvasionPoints,
  });

  @override
  final bool isSuccess;
  @override
  final int attackerEvasionPoints;

  @override
  String toString() {
    return 'FlightAttemptResultEvent(isSuccess: $isSuccess, attackerEvasionPoints: $attackerEvasionPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlightAttemptResultEventImpl &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.attackerEvasionPoints, attackerEvasionPoints) ||
                other.attackerEvasionPoints == attackerEvasionPoints));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isSuccess, attackerEvasionPoints);

  /// Create a copy of FlightAttemptResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlightAttemptResultEventImplCopyWith<_$FlightAttemptResultEventImpl>
  get copyWith =>
      __$$FlightAttemptResultEventImplCopyWithImpl<
        _$FlightAttemptResultEventImpl
      >(this, _$identity);
}

abstract class _FlightAttemptResultEvent implements FlightAttemptResultEvent {
  const factory _FlightAttemptResultEvent({
    required final bool isSuccess,
    required final int attackerEvasionPoints,
  }) = _$FlightAttemptResultEventImpl;

  @override
  bool get isSuccess;
  @override
  int get attackerEvasionPoints;

  /// Create a copy of FlightAttemptResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlightAttemptResultEventImplCopyWith<_$FlightAttemptResultEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CombatTurnStartedEvent {
  String get combatRoomId => throw _privateConstructorUsedError;
  String get currentPlayerId => throw _privateConstructorUsedError;
  String get currentOpponentId => throw _privateConstructorUsedError;
  String get attackerId => throw _privateConstructorUsedError;
  String get defenderId => throw _privateConstructorUsedError;

  /// Create a copy of CombatTurnStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CombatTurnStartedEventCopyWith<CombatTurnStartedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CombatTurnStartedEventCopyWith<$Res> {
  factory $CombatTurnStartedEventCopyWith(
    CombatTurnStartedEvent value,
    $Res Function(CombatTurnStartedEvent) then,
  ) = _$CombatTurnStartedEventCopyWithImpl<$Res, CombatTurnStartedEvent>;
  @useResult
  $Res call({
    String combatRoomId,
    String currentPlayerId,
    String currentOpponentId,
    String attackerId,
    String defenderId,
  });
}

/// @nodoc
class _$CombatTurnStartedEventCopyWithImpl<
  $Res,
  $Val extends CombatTurnStartedEvent
>
    implements $CombatTurnStartedEventCopyWith<$Res> {
  _$CombatTurnStartedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CombatTurnStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? combatRoomId = null,
    Object? currentPlayerId = null,
    Object? currentOpponentId = null,
    Object? attackerId = null,
    Object? defenderId = null,
  }) {
    return _then(
      _value.copyWith(
            combatRoomId: null == combatRoomId
                ? _value.combatRoomId
                : combatRoomId // ignore: cast_nullable_to_non_nullable
                      as String,
            currentPlayerId: null == currentPlayerId
                ? _value.currentPlayerId
                : currentPlayerId // ignore: cast_nullable_to_non_nullable
                      as String,
            currentOpponentId: null == currentOpponentId
                ? _value.currentOpponentId
                : currentOpponentId // ignore: cast_nullable_to_non_nullable
                      as String,
            attackerId: null == attackerId
                ? _value.attackerId
                : attackerId // ignore: cast_nullable_to_non_nullable
                      as String,
            defenderId: null == defenderId
                ? _value.defenderId
                : defenderId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CombatTurnStartedEventImplCopyWith<$Res>
    implements $CombatTurnStartedEventCopyWith<$Res> {
  factory _$$CombatTurnStartedEventImplCopyWith(
    _$CombatTurnStartedEventImpl value,
    $Res Function(_$CombatTurnStartedEventImpl) then,
  ) = __$$CombatTurnStartedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String combatRoomId,
    String currentPlayerId,
    String currentOpponentId,
    String attackerId,
    String defenderId,
  });
}

/// @nodoc
class __$$CombatTurnStartedEventImplCopyWithImpl<$Res>
    extends
        _$CombatTurnStartedEventCopyWithImpl<$Res, _$CombatTurnStartedEventImpl>
    implements _$$CombatTurnStartedEventImplCopyWith<$Res> {
  __$$CombatTurnStartedEventImplCopyWithImpl(
    _$CombatTurnStartedEventImpl _value,
    $Res Function(_$CombatTurnStartedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CombatTurnStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? combatRoomId = null,
    Object? currentPlayerId = null,
    Object? currentOpponentId = null,
    Object? attackerId = null,
    Object? defenderId = null,
  }) {
    return _then(
      _$CombatTurnStartedEventImpl(
        combatRoomId: null == combatRoomId
            ? _value.combatRoomId
            : combatRoomId // ignore: cast_nullable_to_non_nullable
                  as String,
        currentPlayerId: null == currentPlayerId
            ? _value.currentPlayerId
            : currentPlayerId // ignore: cast_nullable_to_non_nullable
                  as String,
        currentOpponentId: null == currentOpponentId
            ? _value.currentOpponentId
            : currentOpponentId // ignore: cast_nullable_to_non_nullable
                  as String,
        attackerId: null == attackerId
            ? _value.attackerId
            : attackerId // ignore: cast_nullable_to_non_nullable
                  as String,
        defenderId: null == defenderId
            ? _value.defenderId
            : defenderId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CombatTurnStartedEventImpl implements _CombatTurnStartedEvent {
  const _$CombatTurnStartedEventImpl({
    required this.combatRoomId,
    required this.currentPlayerId,
    required this.currentOpponentId,
    required this.attackerId,
    required this.defenderId,
  });

  @override
  final String combatRoomId;
  @override
  final String currentPlayerId;
  @override
  final String currentOpponentId;
  @override
  final String attackerId;
  @override
  final String defenderId;

  @override
  String toString() {
    return 'CombatTurnStartedEvent(combatRoomId: $combatRoomId, currentPlayerId: $currentPlayerId, currentOpponentId: $currentOpponentId, attackerId: $attackerId, defenderId: $defenderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CombatTurnStartedEventImpl &&
            (identical(other.combatRoomId, combatRoomId) ||
                other.combatRoomId == combatRoomId) &&
            (identical(other.currentPlayerId, currentPlayerId) ||
                other.currentPlayerId == currentPlayerId) &&
            (identical(other.currentOpponentId, currentOpponentId) ||
                other.currentOpponentId == currentOpponentId) &&
            (identical(other.attackerId, attackerId) ||
                other.attackerId == attackerId) &&
            (identical(other.defenderId, defenderId) ||
                other.defenderId == defenderId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    combatRoomId,
    currentPlayerId,
    currentOpponentId,
    attackerId,
    defenderId,
  );

  /// Create a copy of CombatTurnStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CombatTurnStartedEventImplCopyWith<_$CombatTurnStartedEventImpl>
  get copyWith =>
      __$$CombatTurnStartedEventImplCopyWithImpl<_$CombatTurnStartedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _CombatTurnStartedEvent implements CombatTurnStartedEvent {
  const factory _CombatTurnStartedEvent({
    required final String combatRoomId,
    required final String currentPlayerId,
    required final String currentOpponentId,
    required final String attackerId,
    required final String defenderId,
  }) = _$CombatTurnStartedEventImpl;

  @override
  String get combatRoomId;
  @override
  String get currentPlayerId;
  @override
  String get currentOpponentId;
  @override
  String get attackerId;
  @override
  String get defenderId;

  /// Create a copy of CombatTurnStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CombatTurnStartedEventImplCopyWith<_$CombatTurnStartedEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EndCombatResultEvent {
  String get winnerId => throw _privateConstructorUsedError;
  String get loserId => throw _privateConstructorUsedError;
  bool get isByFlight => throw _privateConstructorUsedError;

  /// Create a copy of EndCombatResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EndCombatResultEventCopyWith<EndCombatResultEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EndCombatResultEventCopyWith<$Res> {
  factory $EndCombatResultEventCopyWith(
    EndCombatResultEvent value,
    $Res Function(EndCombatResultEvent) then,
  ) = _$EndCombatResultEventCopyWithImpl<$Res, EndCombatResultEvent>;
  @useResult
  $Res call({String winnerId, String loserId, bool isByFlight});
}

/// @nodoc
class _$EndCombatResultEventCopyWithImpl<
  $Res,
  $Val extends EndCombatResultEvent
>
    implements $EndCombatResultEventCopyWith<$Res> {
  _$EndCombatResultEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EndCombatResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? winnerId = null,
    Object? loserId = null,
    Object? isByFlight = null,
  }) {
    return _then(
      _value.copyWith(
            winnerId: null == winnerId
                ? _value.winnerId
                : winnerId // ignore: cast_nullable_to_non_nullable
                      as String,
            loserId: null == loserId
                ? _value.loserId
                : loserId // ignore: cast_nullable_to_non_nullable
                      as String,
            isByFlight: null == isByFlight
                ? _value.isByFlight
                : isByFlight // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EndCombatResultEventImplCopyWith<$Res>
    implements $EndCombatResultEventCopyWith<$Res> {
  factory _$$EndCombatResultEventImplCopyWith(
    _$EndCombatResultEventImpl value,
    $Res Function(_$EndCombatResultEventImpl) then,
  ) = __$$EndCombatResultEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String winnerId, String loserId, bool isByFlight});
}

/// @nodoc
class __$$EndCombatResultEventImplCopyWithImpl<$Res>
    extends _$EndCombatResultEventCopyWithImpl<$Res, _$EndCombatResultEventImpl>
    implements _$$EndCombatResultEventImplCopyWith<$Res> {
  __$$EndCombatResultEventImplCopyWithImpl(
    _$EndCombatResultEventImpl _value,
    $Res Function(_$EndCombatResultEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EndCombatResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? winnerId = null,
    Object? loserId = null,
    Object? isByFlight = null,
  }) {
    return _then(
      _$EndCombatResultEventImpl(
        winnerId: null == winnerId
            ? _value.winnerId
            : winnerId // ignore: cast_nullable_to_non_nullable
                  as String,
        loserId: null == loserId
            ? _value.loserId
            : loserId // ignore: cast_nullable_to_non_nullable
                  as String,
        isByFlight: null == isByFlight
            ? _value.isByFlight
            : isByFlight // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$EndCombatResultEventImpl implements _EndCombatResultEvent {
  const _$EndCombatResultEventImpl({
    required this.winnerId,
    required this.loserId,
    required this.isByFlight,
  });

  @override
  final String winnerId;
  @override
  final String loserId;
  @override
  final bool isByFlight;

  @override
  String toString() {
    return 'EndCombatResultEvent(winnerId: $winnerId, loserId: $loserId, isByFlight: $isByFlight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EndCombatResultEventImpl &&
            (identical(other.winnerId, winnerId) ||
                other.winnerId == winnerId) &&
            (identical(other.loserId, loserId) || other.loserId == loserId) &&
            (identical(other.isByFlight, isByFlight) ||
                other.isByFlight == isByFlight));
  }

  @override
  int get hashCode => Object.hash(runtimeType, winnerId, loserId, isByFlight);

  /// Create a copy of EndCombatResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EndCombatResultEventImplCopyWith<_$EndCombatResultEventImpl>
  get copyWith =>
      __$$EndCombatResultEventImplCopyWithImpl<_$EndCombatResultEventImpl>(
        this,
        _$identity,
      );
}

abstract class _EndCombatResultEvent implements EndCombatResultEvent {
  const factory _EndCombatResultEvent({
    required final String winnerId,
    required final String loserId,
    required final bool isByFlight,
  }) = _$EndCombatResultEventImpl;

  @override
  String get winnerId;
  @override
  String get loserId;
  @override
  bool get isByFlight;

  /// Create a copy of EndCombatResultEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EndCombatResultEventImplCopyWith<_$EndCombatResultEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CombatCountdownEvent {
  int get seconds => throw _privateConstructorUsedError;

  /// Create a copy of CombatCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CombatCountdownEventCopyWith<CombatCountdownEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CombatCountdownEventCopyWith<$Res> {
  factory $CombatCountdownEventCopyWith(
    CombatCountdownEvent value,
    $Res Function(CombatCountdownEvent) then,
  ) = _$CombatCountdownEventCopyWithImpl<$Res, CombatCountdownEvent>;
  @useResult
  $Res call({int seconds});
}

/// @nodoc
class _$CombatCountdownEventCopyWithImpl<
  $Res,
  $Val extends CombatCountdownEvent
>
    implements $CombatCountdownEventCopyWith<$Res> {
  _$CombatCountdownEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CombatCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? seconds = null}) {
    return _then(
      _value.copyWith(
            seconds: null == seconds
                ? _value.seconds
                : seconds // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CombatCountdownEventImplCopyWith<$Res>
    implements $CombatCountdownEventCopyWith<$Res> {
  factory _$$CombatCountdownEventImplCopyWith(
    _$CombatCountdownEventImpl value,
    $Res Function(_$CombatCountdownEventImpl) then,
  ) = __$$CombatCountdownEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int seconds});
}

/// @nodoc
class __$$CombatCountdownEventImplCopyWithImpl<$Res>
    extends _$CombatCountdownEventCopyWithImpl<$Res, _$CombatCountdownEventImpl>
    implements _$$CombatCountdownEventImplCopyWith<$Res> {
  __$$CombatCountdownEventImplCopyWithImpl(
    _$CombatCountdownEventImpl _value,
    $Res Function(_$CombatCountdownEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CombatCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? seconds = null}) {
    return _then(
      _$CombatCountdownEventImpl(
        seconds: null == seconds
            ? _value.seconds
            : seconds // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$CombatCountdownEventImpl implements _CombatCountdownEvent {
  const _$CombatCountdownEventImpl({required this.seconds});

  @override
  final int seconds;

  @override
  String toString() {
    return 'CombatCountdownEvent(seconds: $seconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CombatCountdownEventImpl &&
            (identical(other.seconds, seconds) || other.seconds == seconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, seconds);

  /// Create a copy of CombatCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CombatCountdownEventImplCopyWith<_$CombatCountdownEventImpl>
  get copyWith =>
      __$$CombatCountdownEventImplCopyWithImpl<_$CombatCountdownEventImpl>(
        this,
        _$identity,
      );
}

abstract class _CombatCountdownEvent implements CombatCountdownEvent {
  const factory _CombatCountdownEvent({required final int seconds}) =
      _$CombatCountdownEventImpl;

  @override
  int get seconds;

  /// Create a copy of CombatCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CombatCountdownEventImplCopyWith<_$CombatCountdownEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CombatResultsClearedEvent {}

/// @nodoc
abstract class $CombatResultsClearedEventCopyWith<$Res> {
  factory $CombatResultsClearedEventCopyWith(
    CombatResultsClearedEvent value,
    $Res Function(CombatResultsClearedEvent) then,
  ) = _$CombatResultsClearedEventCopyWithImpl<$Res, CombatResultsClearedEvent>;
}

/// @nodoc
class _$CombatResultsClearedEventCopyWithImpl<
  $Res,
  $Val extends CombatResultsClearedEvent
>
    implements $CombatResultsClearedEventCopyWith<$Res> {
  _$CombatResultsClearedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CombatResultsClearedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CombatResultsClearedEventImplCopyWith<$Res> {
  factory _$$CombatResultsClearedEventImplCopyWith(
    _$CombatResultsClearedEventImpl value,
    $Res Function(_$CombatResultsClearedEventImpl) then,
  ) = __$$CombatResultsClearedEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CombatResultsClearedEventImplCopyWithImpl<$Res>
    extends
        _$CombatResultsClearedEventCopyWithImpl<
          $Res,
          _$CombatResultsClearedEventImpl
        >
    implements _$$CombatResultsClearedEventImplCopyWith<$Res> {
  __$$CombatResultsClearedEventImplCopyWithImpl(
    _$CombatResultsClearedEventImpl _value,
    $Res Function(_$CombatResultsClearedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CombatResultsClearedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CombatResultsClearedEventImpl implements _CombatResultsClearedEvent {
  const _$CombatResultsClearedEventImpl();

  @override
  String toString() {
    return 'CombatResultsClearedEvent()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CombatResultsClearedEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _CombatResultsClearedEvent implements CombatResultsClearedEvent {
  const factory _CombatResultsClearedEvent() = _$CombatResultsClearedEventImpl;
}

/// @nodoc
mixin _$FlightAttemptFeedbackClearedEvent {}

/// @nodoc
abstract class $FlightAttemptFeedbackClearedEventCopyWith<$Res> {
  factory $FlightAttemptFeedbackClearedEventCopyWith(
    FlightAttemptFeedbackClearedEvent value,
    $Res Function(FlightAttemptFeedbackClearedEvent) then,
  ) =
      _$FlightAttemptFeedbackClearedEventCopyWithImpl<
        $Res,
        FlightAttemptFeedbackClearedEvent
      >;
}

/// @nodoc
class _$FlightAttemptFeedbackClearedEventCopyWithImpl<
  $Res,
  $Val extends FlightAttemptFeedbackClearedEvent
>
    implements $FlightAttemptFeedbackClearedEventCopyWith<$Res> {
  _$FlightAttemptFeedbackClearedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlightAttemptFeedbackClearedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FlightAttemptFeedbackClearedEventImplCopyWith<$Res> {
  factory _$$FlightAttemptFeedbackClearedEventImplCopyWith(
    _$FlightAttemptFeedbackClearedEventImpl value,
    $Res Function(_$FlightAttemptFeedbackClearedEventImpl) then,
  ) = __$$FlightAttemptFeedbackClearedEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FlightAttemptFeedbackClearedEventImplCopyWithImpl<$Res>
    extends
        _$FlightAttemptFeedbackClearedEventCopyWithImpl<
          $Res,
          _$FlightAttemptFeedbackClearedEventImpl
        >
    implements _$$FlightAttemptFeedbackClearedEventImplCopyWith<$Res> {
  __$$FlightAttemptFeedbackClearedEventImplCopyWithImpl(
    _$FlightAttemptFeedbackClearedEventImpl _value,
    $Res Function(_$FlightAttemptFeedbackClearedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlightAttemptFeedbackClearedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FlightAttemptFeedbackClearedEventImpl
    implements _FlightAttemptFeedbackClearedEvent {
  const _$FlightAttemptFeedbackClearedEventImpl();

  @override
  String toString() {
    return 'FlightAttemptFeedbackClearedEvent()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlightAttemptFeedbackClearedEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _FlightAttemptFeedbackClearedEvent
    implements FlightAttemptFeedbackClearedEvent {
  const factory _FlightAttemptFeedbackClearedEvent() =
      _$FlightAttemptFeedbackClearedEventImpl;
}
