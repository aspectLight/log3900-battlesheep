// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_environment_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TrapPendingEvent {
  String get roomId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  bool get canAvoid => throw _privateConstructorUsedError;

  /// Create a copy of TrapPendingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrapPendingEventCopyWith<TrapPendingEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrapPendingEventCopyWith<$Res> {
  factory $TrapPendingEventCopyWith(
    TrapPendingEvent value,
    $Res Function(TrapPendingEvent) then,
  ) = _$TrapPendingEventCopyWithImpl<$Res, TrapPendingEvent>;
  @useResult
  $Res call({String roomId, String playerId, bool canAvoid});
}

/// @nodoc
class _$TrapPendingEventCopyWithImpl<$Res, $Val extends TrapPendingEvent>
    implements $TrapPendingEventCopyWith<$Res> {
  _$TrapPendingEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrapPendingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? canAvoid = null,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            canAvoid: null == canAvoid
                ? _value.canAvoid
                : canAvoid // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TrapPendingEventImplCopyWith<$Res>
    implements $TrapPendingEventCopyWith<$Res> {
  factory _$$TrapPendingEventImplCopyWith(
    _$TrapPendingEventImpl value,
    $Res Function(_$TrapPendingEventImpl) then,
  ) = __$$TrapPendingEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, String playerId, bool canAvoid});
}

/// @nodoc
class __$$TrapPendingEventImplCopyWithImpl<$Res>
    extends _$TrapPendingEventCopyWithImpl<$Res, _$TrapPendingEventImpl>
    implements _$$TrapPendingEventImplCopyWith<$Res> {
  __$$TrapPendingEventImplCopyWithImpl(
    _$TrapPendingEventImpl _value,
    $Res Function(_$TrapPendingEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrapPendingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? canAvoid = null,
  }) {
    return _then(
      _$TrapPendingEventImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        canAvoid: null == canAvoid
            ? _value.canAvoid
            : canAvoid // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$TrapPendingEventImpl implements _TrapPendingEvent {
  const _$TrapPendingEventImpl({
    required this.roomId,
    required this.playerId,
    required this.canAvoid,
  });

  @override
  final String roomId;
  @override
  final String playerId;
  @override
  final bool canAvoid;

  @override
  String toString() {
    return 'TrapPendingEvent(roomId: $roomId, playerId: $playerId, canAvoid: $canAvoid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrapPendingEventImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.canAvoid, canAvoid) ||
                other.canAvoid == canAvoid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, playerId, canAvoid);

  /// Create a copy of TrapPendingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrapPendingEventImplCopyWith<_$TrapPendingEventImpl> get copyWith =>
      __$$TrapPendingEventImplCopyWithImpl<_$TrapPendingEventImpl>(
        this,
        _$identity,
      );
}

abstract class _TrapPendingEvent implements TrapPendingEvent {
  const factory _TrapPendingEvent({
    required final String roomId,
    required final String playerId,
    required final bool canAvoid,
  }) = _$TrapPendingEventImpl;

  @override
  String get roomId;
  @override
  String get playerId;
  @override
  bool get canAvoid;

  /// Create a copy of TrapPendingEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrapPendingEventImplCopyWith<_$TrapPendingEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BoardIlluminationUpdatedEvent {
  Set<String> get illuminatedCellKeys => throw _privateConstructorUsedError;

  /// Create a copy of BoardIlluminationUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoardIlluminationUpdatedEventCopyWith<BoardIlluminationUpdatedEvent>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardIlluminationUpdatedEventCopyWith<$Res> {
  factory $BoardIlluminationUpdatedEventCopyWith(
    BoardIlluminationUpdatedEvent value,
    $Res Function(BoardIlluminationUpdatedEvent) then,
  ) =
      _$BoardIlluminationUpdatedEventCopyWithImpl<
        $Res,
        BoardIlluminationUpdatedEvent
      >;
  @useResult
  $Res call({Set<String> illuminatedCellKeys});
}

/// @nodoc
class _$BoardIlluminationUpdatedEventCopyWithImpl<
  $Res,
  $Val extends BoardIlluminationUpdatedEvent
>
    implements $BoardIlluminationUpdatedEventCopyWith<$Res> {
  _$BoardIlluminationUpdatedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoardIlluminationUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? illuminatedCellKeys = null}) {
    return _then(
      _value.copyWith(
            illuminatedCellKeys: null == illuminatedCellKeys
                ? _value.illuminatedCellKeys
                : illuminatedCellKeys // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BoardIlluminationUpdatedEventImplCopyWith<$Res>
    implements $BoardIlluminationUpdatedEventCopyWith<$Res> {
  factory _$$BoardIlluminationUpdatedEventImplCopyWith(
    _$BoardIlluminationUpdatedEventImpl value,
    $Res Function(_$BoardIlluminationUpdatedEventImpl) then,
  ) = __$$BoardIlluminationUpdatedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Set<String> illuminatedCellKeys});
}

/// @nodoc
class __$$BoardIlluminationUpdatedEventImplCopyWithImpl<$Res>
    extends
        _$BoardIlluminationUpdatedEventCopyWithImpl<
          $Res,
          _$BoardIlluminationUpdatedEventImpl
        >
    implements _$$BoardIlluminationUpdatedEventImplCopyWith<$Res> {
  __$$BoardIlluminationUpdatedEventImplCopyWithImpl(
    _$BoardIlluminationUpdatedEventImpl _value,
    $Res Function(_$BoardIlluminationUpdatedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoardIlluminationUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? illuminatedCellKeys = null}) {
    return _then(
      _$BoardIlluminationUpdatedEventImpl(
        illuminatedCellKeys: null == illuminatedCellKeys
            ? _value._illuminatedCellKeys
            : illuminatedCellKeys // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
      ),
    );
  }
}

/// @nodoc

class _$BoardIlluminationUpdatedEventImpl
    implements _BoardIlluminationUpdatedEvent {
  const _$BoardIlluminationUpdatedEventImpl({
    required final Set<String> illuminatedCellKeys,
  }) : _illuminatedCellKeys = illuminatedCellKeys;

  final Set<String> _illuminatedCellKeys;
  @override
  Set<String> get illuminatedCellKeys {
    if (_illuminatedCellKeys is EqualUnmodifiableSetView)
      return _illuminatedCellKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_illuminatedCellKeys);
  }

  @override
  String toString() {
    return 'BoardIlluminationUpdatedEvent(illuminatedCellKeys: $illuminatedCellKeys)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardIlluminationUpdatedEventImpl &&
            const DeepCollectionEquality().equals(
              other._illuminatedCellKeys,
              _illuminatedCellKeys,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_illuminatedCellKeys),
  );

  /// Create a copy of BoardIlluminationUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardIlluminationUpdatedEventImplCopyWith<
    _$BoardIlluminationUpdatedEventImpl
  >
  get copyWith =>
      __$$BoardIlluminationUpdatedEventImplCopyWithImpl<
        _$BoardIlluminationUpdatedEventImpl
      >(this, _$identity);
}

abstract class _BoardIlluminationUpdatedEvent
    implements BoardIlluminationUpdatedEvent {
  const factory _BoardIlluminationUpdatedEvent({
    required final Set<String> illuminatedCellKeys,
  }) = _$BoardIlluminationUpdatedEventImpl;

  @override
  Set<String> get illuminatedCellKeys;

  /// Create a copy of BoardIlluminationUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoardIlluminationUpdatedEventImplCopyWith<
    _$BoardIlluminationUpdatedEventImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TorchPlayerStatPatch {
  String get playerId => throw _privateConstructorUsedError;
  int get attack => throw _privateConstructorUsedError;
  int get defense => throw _privateConstructorUsedError;

  /// Create a copy of TorchPlayerStatPatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TorchPlayerStatPatchCopyWith<TorchPlayerStatPatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TorchPlayerStatPatchCopyWith<$Res> {
  factory $TorchPlayerStatPatchCopyWith(
    TorchPlayerStatPatch value,
    $Res Function(TorchPlayerStatPatch) then,
  ) = _$TorchPlayerStatPatchCopyWithImpl<$Res, TorchPlayerStatPatch>;
  @useResult
  $Res call({String playerId, int attack, int defense});
}

/// @nodoc
class _$TorchPlayerStatPatchCopyWithImpl<
  $Res,
  $Val extends TorchPlayerStatPatch
>
    implements $TorchPlayerStatPatchCopyWith<$Res> {
  _$TorchPlayerStatPatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TorchPlayerStatPatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? attack = null,
    Object? defense = null,
  }) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            attack: null == attack
                ? _value.attack
                : attack // ignore: cast_nullable_to_non_nullable
                      as int,
            defense: null == defense
                ? _value.defense
                : defense // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TorchPlayerStatPatchImplCopyWith<$Res>
    implements $TorchPlayerStatPatchCopyWith<$Res> {
  factory _$$TorchPlayerStatPatchImplCopyWith(
    _$TorchPlayerStatPatchImpl value,
    $Res Function(_$TorchPlayerStatPatchImpl) then,
  ) = __$$TorchPlayerStatPatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId, int attack, int defense});
}

/// @nodoc
class __$$TorchPlayerStatPatchImplCopyWithImpl<$Res>
    extends _$TorchPlayerStatPatchCopyWithImpl<$Res, _$TorchPlayerStatPatchImpl>
    implements _$$TorchPlayerStatPatchImplCopyWith<$Res> {
  __$$TorchPlayerStatPatchImplCopyWithImpl(
    _$TorchPlayerStatPatchImpl _value,
    $Res Function(_$TorchPlayerStatPatchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TorchPlayerStatPatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? attack = null,
    Object? defense = null,
  }) {
    return _then(
      _$TorchPlayerStatPatchImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        attack: null == attack
            ? _value.attack
            : attack // ignore: cast_nullable_to_non_nullable
                  as int,
        defense: null == defense
            ? _value.defense
            : defense // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$TorchPlayerStatPatchImpl implements _TorchPlayerStatPatch {
  const _$TorchPlayerStatPatchImpl({
    required this.playerId,
    required this.attack,
    required this.defense,
  });

  @override
  final String playerId;
  @override
  final int attack;
  @override
  final int defense;

  @override
  String toString() {
    return 'TorchPlayerStatPatch(playerId: $playerId, attack: $attack, defense: $defense)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TorchPlayerStatPatchImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.attack, attack) || other.attack == attack) &&
            (identical(other.defense, defense) || other.defense == defense));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId, attack, defense);

  /// Create a copy of TorchPlayerStatPatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TorchPlayerStatPatchImplCopyWith<_$TorchPlayerStatPatchImpl>
  get copyWith =>
      __$$TorchPlayerStatPatchImplCopyWithImpl<_$TorchPlayerStatPatchImpl>(
        this,
        _$identity,
      );
}

abstract class _TorchPlayerStatPatch implements TorchPlayerStatPatch {
  const factory _TorchPlayerStatPatch({
    required final String playerId,
    required final int attack,
    required final int defense,
  }) = _$TorchPlayerStatPatchImpl;

  @override
  String get playerId;
  @override
  int get attack;
  @override
  int get defense;

  /// Create a copy of TorchPlayerStatPatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TorchPlayerStatPatchImplCopyWith<_$TorchPlayerStatPatchImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlayerTorchStatsSyncEvent {
  List<TorchPlayerStatPatch> get patches => throw _privateConstructorUsedError;

  /// Create a copy of PlayerTorchStatsSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerTorchStatsSyncEventCopyWith<PlayerTorchStatsSyncEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerTorchStatsSyncEventCopyWith<$Res> {
  factory $PlayerTorchStatsSyncEventCopyWith(
    PlayerTorchStatsSyncEvent value,
    $Res Function(PlayerTorchStatsSyncEvent) then,
  ) = _$PlayerTorchStatsSyncEventCopyWithImpl<$Res, PlayerTorchStatsSyncEvent>;
  @useResult
  $Res call({List<TorchPlayerStatPatch> patches});
}

/// @nodoc
class _$PlayerTorchStatsSyncEventCopyWithImpl<
  $Res,
  $Val extends PlayerTorchStatsSyncEvent
>
    implements $PlayerTorchStatsSyncEventCopyWith<$Res> {
  _$PlayerTorchStatsSyncEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerTorchStatsSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? patches = null}) {
    return _then(
      _value.copyWith(
            patches: null == patches
                ? _value.patches
                : patches // ignore: cast_nullable_to_non_nullable
                      as List<TorchPlayerStatPatch>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerTorchStatsSyncEventImplCopyWith<$Res>
    implements $PlayerTorchStatsSyncEventCopyWith<$Res> {
  factory _$$PlayerTorchStatsSyncEventImplCopyWith(
    _$PlayerTorchStatsSyncEventImpl value,
    $Res Function(_$PlayerTorchStatsSyncEventImpl) then,
  ) = __$$PlayerTorchStatsSyncEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TorchPlayerStatPatch> patches});
}

/// @nodoc
class __$$PlayerTorchStatsSyncEventImplCopyWithImpl<$Res>
    extends
        _$PlayerTorchStatsSyncEventCopyWithImpl<
          $Res,
          _$PlayerTorchStatsSyncEventImpl
        >
    implements _$$PlayerTorchStatsSyncEventImplCopyWith<$Res> {
  __$$PlayerTorchStatsSyncEventImplCopyWithImpl(
    _$PlayerTorchStatsSyncEventImpl _value,
    $Res Function(_$PlayerTorchStatsSyncEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerTorchStatsSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? patches = null}) {
    return _then(
      _$PlayerTorchStatsSyncEventImpl(
        patches: null == patches
            ? _value._patches
            : patches // ignore: cast_nullable_to_non_nullable
                  as List<TorchPlayerStatPatch>,
      ),
    );
  }
}

/// @nodoc

class _$PlayerTorchStatsSyncEventImpl implements _PlayerTorchStatsSyncEvent {
  const _$PlayerTorchStatsSyncEventImpl({
    required final List<TorchPlayerStatPatch> patches,
  }) : _patches = patches;

  final List<TorchPlayerStatPatch> _patches;
  @override
  List<TorchPlayerStatPatch> get patches {
    if (_patches is EqualUnmodifiableListView) return _patches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_patches);
  }

  @override
  String toString() {
    return 'PlayerTorchStatsSyncEvent(patches: $patches)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerTorchStatsSyncEventImpl &&
            const DeepCollectionEquality().equals(other._patches, _patches));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_patches));

  /// Create a copy of PlayerTorchStatsSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerTorchStatsSyncEventImplCopyWith<_$PlayerTorchStatsSyncEventImpl>
  get copyWith =>
      __$$PlayerTorchStatsSyncEventImplCopyWithImpl<
        _$PlayerTorchStatsSyncEventImpl
      >(this, _$identity);
}

abstract class _PlayerTorchStatsSyncEvent implements PlayerTorchStatsSyncEvent {
  const factory _PlayerTorchStatsSyncEvent({
    required final List<TorchPlayerStatPatch> patches,
  }) = _$PlayerTorchStatsSyncEventImpl;

  @override
  List<TorchPlayerStatPatch> get patches;

  /// Create a copy of PlayerTorchStatsSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerTorchStatsSyncEventImplCopyWith<_$PlayerTorchStatsSyncEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TrapResultSyncEvent {
  String get playerId => throw _privateConstructorUsedError;
  int get remainingMovementPoints => throw _privateConstructorUsedError;
  bool get activated => throw _privateConstructorUsedError;

  /// Create a copy of TrapResultSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrapResultSyncEventCopyWith<TrapResultSyncEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrapResultSyncEventCopyWith<$Res> {
  factory $TrapResultSyncEventCopyWith(
    TrapResultSyncEvent value,
    $Res Function(TrapResultSyncEvent) then,
  ) = _$TrapResultSyncEventCopyWithImpl<$Res, TrapResultSyncEvent>;
  @useResult
  $Res call({String playerId, int remainingMovementPoints, bool activated});
}

/// @nodoc
class _$TrapResultSyncEventCopyWithImpl<$Res, $Val extends TrapResultSyncEvent>
    implements $TrapResultSyncEventCopyWith<$Res> {
  _$TrapResultSyncEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrapResultSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? remainingMovementPoints = null,
    Object? activated = null,
  }) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            remainingMovementPoints: null == remainingMovementPoints
                ? _value.remainingMovementPoints
                : remainingMovementPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            activated: null == activated
                ? _value.activated
                : activated // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TrapResultSyncEventImplCopyWith<$Res>
    implements $TrapResultSyncEventCopyWith<$Res> {
  factory _$$TrapResultSyncEventImplCopyWith(
    _$TrapResultSyncEventImpl value,
    $Res Function(_$TrapResultSyncEventImpl) then,
  ) = __$$TrapResultSyncEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId, int remainingMovementPoints, bool activated});
}

/// @nodoc
class __$$TrapResultSyncEventImplCopyWithImpl<$Res>
    extends _$TrapResultSyncEventCopyWithImpl<$Res, _$TrapResultSyncEventImpl>
    implements _$$TrapResultSyncEventImplCopyWith<$Res> {
  __$$TrapResultSyncEventImplCopyWithImpl(
    _$TrapResultSyncEventImpl _value,
    $Res Function(_$TrapResultSyncEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrapResultSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? remainingMovementPoints = null,
    Object? activated = null,
  }) {
    return _then(
      _$TrapResultSyncEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        remainingMovementPoints: null == remainingMovementPoints
            ? _value.remainingMovementPoints
            : remainingMovementPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        activated: null == activated
            ? _value.activated
            : activated // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$TrapResultSyncEventImpl implements _TrapResultSyncEvent {
  const _$TrapResultSyncEventImpl({
    required this.playerId,
    required this.remainingMovementPoints,
    required this.activated,
  });

  @override
  final String playerId;
  @override
  final int remainingMovementPoints;
  @override
  final bool activated;

  @override
  String toString() {
    return 'TrapResultSyncEvent(playerId: $playerId, remainingMovementPoints: $remainingMovementPoints, activated: $activated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrapResultSyncEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(
                  other.remainingMovementPoints,
                  remainingMovementPoints,
                ) ||
                other.remainingMovementPoints == remainingMovementPoints) &&
            (identical(other.activated, activated) ||
                other.activated == activated));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, playerId, remainingMovementPoints, activated);

  /// Create a copy of TrapResultSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrapResultSyncEventImplCopyWith<_$TrapResultSyncEventImpl> get copyWith =>
      __$$TrapResultSyncEventImplCopyWithImpl<_$TrapResultSyncEventImpl>(
        this,
        _$identity,
      );
}

abstract class _TrapResultSyncEvent implements TrapResultSyncEvent {
  const factory _TrapResultSyncEvent({
    required final String playerId,
    required final int remainingMovementPoints,
    required final bool activated,
  }) = _$TrapResultSyncEventImpl;

  @override
  String get playerId;
  @override
  int get remainingMovementPoints;
  @override
  bool get activated;

  /// Create a copy of TrapResultSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrapResultSyncEventImplCopyWith<_$TrapResultSyncEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
