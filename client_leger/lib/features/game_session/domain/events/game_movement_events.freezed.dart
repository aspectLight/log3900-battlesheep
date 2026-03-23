// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_movement_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PlayerMovedEvent {
  String get playerId => throw _privateConstructorUsedError;
  int get movementPoints => throw _privateConstructorUsedError;
  List<GameBoardPosition> get selectedPath =>
      throw _privateConstructorUsedError;

  /// Create a copy of PlayerMovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerMovedEventCopyWith<PlayerMovedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerMovedEventCopyWith<$Res> {
  factory $PlayerMovedEventCopyWith(
    PlayerMovedEvent value,
    $Res Function(PlayerMovedEvent) then,
  ) = _$PlayerMovedEventCopyWithImpl<$Res, PlayerMovedEvent>;
  @useResult
  $Res call({
    String playerId,
    int movementPoints,
    List<GameBoardPosition> selectedPath,
  });
}

/// @nodoc
class _$PlayerMovedEventCopyWithImpl<$Res, $Val extends PlayerMovedEvent>
    implements $PlayerMovedEventCopyWith<$Res> {
  _$PlayerMovedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerMovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? movementPoints = null,
    Object? selectedPath = null,
  }) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            movementPoints: null == movementPoints
                ? _value.movementPoints
                : movementPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            selectedPath: null == selectedPath
                ? _value.selectedPath
                : selectedPath // ignore: cast_nullable_to_non_nullable
                      as List<GameBoardPosition>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerMovedEventImplCopyWith<$Res>
    implements $PlayerMovedEventCopyWith<$Res> {
  factory _$$PlayerMovedEventImplCopyWith(
    _$PlayerMovedEventImpl value,
    $Res Function(_$PlayerMovedEventImpl) then,
  ) = __$$PlayerMovedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String playerId,
    int movementPoints,
    List<GameBoardPosition> selectedPath,
  });
}

/// @nodoc
class __$$PlayerMovedEventImplCopyWithImpl<$Res>
    extends _$PlayerMovedEventCopyWithImpl<$Res, _$PlayerMovedEventImpl>
    implements _$$PlayerMovedEventImplCopyWith<$Res> {
  __$$PlayerMovedEventImplCopyWithImpl(
    _$PlayerMovedEventImpl _value,
    $Res Function(_$PlayerMovedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerMovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? movementPoints = null,
    Object? selectedPath = null,
  }) {
    return _then(
      _$PlayerMovedEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        movementPoints: null == movementPoints
            ? _value.movementPoints
            : movementPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        selectedPath: null == selectedPath
            ? _value._selectedPath
            : selectedPath // ignore: cast_nullable_to_non_nullable
                  as List<GameBoardPosition>,
      ),
    );
  }
}

/// @nodoc

class _$PlayerMovedEventImpl implements _PlayerMovedEvent {
  const _$PlayerMovedEventImpl({
    required this.playerId,
    required this.movementPoints,
    required final List<GameBoardPosition> selectedPath,
  }) : _selectedPath = selectedPath;

  @override
  final String playerId;
  @override
  final int movementPoints;
  final List<GameBoardPosition> _selectedPath;
  @override
  List<GameBoardPosition> get selectedPath {
    if (_selectedPath is EqualUnmodifiableListView) return _selectedPath;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedPath);
  }

  @override
  String toString() {
    return 'PlayerMovedEvent(playerId: $playerId, movementPoints: $movementPoints, selectedPath: $selectedPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerMovedEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.movementPoints, movementPoints) ||
                other.movementPoints == movementPoints) &&
            const DeepCollectionEquality().equals(
              other._selectedPath,
              _selectedPath,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    playerId,
    movementPoints,
    const DeepCollectionEquality().hash(_selectedPath),
  );

  /// Create a copy of PlayerMovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerMovedEventImplCopyWith<_$PlayerMovedEventImpl> get copyWith =>
      __$$PlayerMovedEventImplCopyWithImpl<_$PlayerMovedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _PlayerMovedEvent implements PlayerMovedEvent {
  const factory _PlayerMovedEvent({
    required final String playerId,
    required final int movementPoints,
    required final List<GameBoardPosition> selectedPath,
  }) = _$PlayerMovedEventImpl;

  @override
  String get playerId;
  @override
  int get movementPoints;
  @override
  List<GameBoardPosition> get selectedPath;

  /// Create a copy of PlayerMovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerMovedEventImplCopyWith<_$PlayerMovedEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlayerTeleportedEvent {
  String get playerId => throw _privateConstructorUsedError;
  GameBoardPosition get destination => throw _privateConstructorUsedError;

  /// Create a copy of PlayerTeleportedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerTeleportedEventCopyWith<PlayerTeleportedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerTeleportedEventCopyWith<$Res> {
  factory $PlayerTeleportedEventCopyWith(
    PlayerTeleportedEvent value,
    $Res Function(PlayerTeleportedEvent) then,
  ) = _$PlayerTeleportedEventCopyWithImpl<$Res, PlayerTeleportedEvent>;
  @useResult
  $Res call({String playerId, GameBoardPosition destination});

  $GameBoardPositionCopyWith<$Res> get destination;
}

/// @nodoc
class _$PlayerTeleportedEventCopyWithImpl<
  $Res,
  $Val extends PlayerTeleportedEvent
>
    implements $PlayerTeleportedEventCopyWith<$Res> {
  _$PlayerTeleportedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerTeleportedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null, Object? destination = null}) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            destination: null == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as GameBoardPosition,
          )
          as $Val,
    );
  }

  /// Create a copy of PlayerTeleportedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameBoardPositionCopyWith<$Res> get destination {
    return $GameBoardPositionCopyWith<$Res>(_value.destination, (value) {
      return _then(_value.copyWith(destination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerTeleportedEventImplCopyWith<$Res>
    implements $PlayerTeleportedEventCopyWith<$Res> {
  factory _$$PlayerTeleportedEventImplCopyWith(
    _$PlayerTeleportedEventImpl value,
    $Res Function(_$PlayerTeleportedEventImpl) then,
  ) = __$$PlayerTeleportedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId, GameBoardPosition destination});

  @override
  $GameBoardPositionCopyWith<$Res> get destination;
}

/// @nodoc
class __$$PlayerTeleportedEventImplCopyWithImpl<$Res>
    extends
        _$PlayerTeleportedEventCopyWithImpl<$Res, _$PlayerTeleportedEventImpl>
    implements _$$PlayerTeleportedEventImplCopyWith<$Res> {
  __$$PlayerTeleportedEventImplCopyWithImpl(
    _$PlayerTeleportedEventImpl _value,
    $Res Function(_$PlayerTeleportedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerTeleportedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null, Object? destination = null}) {
    return _then(
      _$PlayerTeleportedEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        destination: null == destination
            ? _value.destination
            : destination // ignore: cast_nullable_to_non_nullable
                  as GameBoardPosition,
      ),
    );
  }
}

/// @nodoc

class _$PlayerTeleportedEventImpl implements _PlayerTeleportedEvent {
  const _$PlayerTeleportedEventImpl({
    required this.playerId,
    required this.destination,
  });

  @override
  final String playerId;
  @override
  final GameBoardPosition destination;

  @override
  String toString() {
    return 'PlayerTeleportedEvent(playerId: $playerId, destination: $destination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerTeleportedEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.destination, destination) ||
                other.destination == destination));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId, destination);

  /// Create a copy of PlayerTeleportedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerTeleportedEventImplCopyWith<_$PlayerTeleportedEventImpl>
  get copyWith =>
      __$$PlayerTeleportedEventImplCopyWithImpl<_$PlayerTeleportedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _PlayerTeleportedEvent implements PlayerTeleportedEvent {
  const factory _PlayerTeleportedEvent({
    required final String playerId,
    required final GameBoardPosition destination,
  }) = _$PlayerTeleportedEventImpl;

  @override
  String get playerId;
  @override
  GameBoardPosition get destination;

  /// Create a copy of PlayerTeleportedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerTeleportedEventImplCopyWith<_$PlayerTeleportedEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VirtualPlayerMovedEvent {
  String get playerId => throw _privateConstructorUsedError;
  List<GameBoardPosition> get path => throw _privateConstructorUsedError;
  int get remainingMovementPoints => throw _privateConstructorUsedError;
  String get opponentPlayerId => throw _privateConstructorUsedError;

  /// Create a copy of VirtualPlayerMovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VirtualPlayerMovedEventCopyWith<VirtualPlayerMovedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VirtualPlayerMovedEventCopyWith<$Res> {
  factory $VirtualPlayerMovedEventCopyWith(
    VirtualPlayerMovedEvent value,
    $Res Function(VirtualPlayerMovedEvent) then,
  ) = _$VirtualPlayerMovedEventCopyWithImpl<$Res, VirtualPlayerMovedEvent>;
  @useResult
  $Res call({
    String playerId,
    List<GameBoardPosition> path,
    int remainingMovementPoints,
    String opponentPlayerId,
  });
}

/// @nodoc
class _$VirtualPlayerMovedEventCopyWithImpl<
  $Res,
  $Val extends VirtualPlayerMovedEvent
>
    implements $VirtualPlayerMovedEventCopyWith<$Res> {
  _$VirtualPlayerMovedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VirtualPlayerMovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? path = null,
    Object? remainingMovementPoints = null,
    Object? opponentPlayerId = null,
  }) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            path: null == path
                ? _value.path
                : path // ignore: cast_nullable_to_non_nullable
                      as List<GameBoardPosition>,
            remainingMovementPoints: null == remainingMovementPoints
                ? _value.remainingMovementPoints
                : remainingMovementPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            opponentPlayerId: null == opponentPlayerId
                ? _value.opponentPlayerId
                : opponentPlayerId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VirtualPlayerMovedEventImplCopyWith<$Res>
    implements $VirtualPlayerMovedEventCopyWith<$Res> {
  factory _$$VirtualPlayerMovedEventImplCopyWith(
    _$VirtualPlayerMovedEventImpl value,
    $Res Function(_$VirtualPlayerMovedEventImpl) then,
  ) = __$$VirtualPlayerMovedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String playerId,
    List<GameBoardPosition> path,
    int remainingMovementPoints,
    String opponentPlayerId,
  });
}

/// @nodoc
class __$$VirtualPlayerMovedEventImplCopyWithImpl<$Res>
    extends
        _$VirtualPlayerMovedEventCopyWithImpl<
          $Res,
          _$VirtualPlayerMovedEventImpl
        >
    implements _$$VirtualPlayerMovedEventImplCopyWith<$Res> {
  __$$VirtualPlayerMovedEventImplCopyWithImpl(
    _$VirtualPlayerMovedEventImpl _value,
    $Res Function(_$VirtualPlayerMovedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VirtualPlayerMovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? path = null,
    Object? remainingMovementPoints = null,
    Object? opponentPlayerId = null,
  }) {
    return _then(
      _$VirtualPlayerMovedEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        path: null == path
            ? _value._path
            : path // ignore: cast_nullable_to_non_nullable
                  as List<GameBoardPosition>,
        remainingMovementPoints: null == remainingMovementPoints
            ? _value.remainingMovementPoints
            : remainingMovementPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        opponentPlayerId: null == opponentPlayerId
            ? _value.opponentPlayerId
            : opponentPlayerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$VirtualPlayerMovedEventImpl implements _VirtualPlayerMovedEvent {
  const _$VirtualPlayerMovedEventImpl({
    required this.playerId,
    required final List<GameBoardPosition> path,
    required this.remainingMovementPoints,
    this.opponentPlayerId = '',
  }) : _path = path;

  @override
  final String playerId;
  final List<GameBoardPosition> _path;
  @override
  List<GameBoardPosition> get path {
    if (_path is EqualUnmodifiableListView) return _path;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_path);
  }

  @override
  final int remainingMovementPoints;
  @override
  @JsonKey()
  final String opponentPlayerId;

  @override
  String toString() {
    return 'VirtualPlayerMovedEvent(playerId: $playerId, path: $path, remainingMovementPoints: $remainingMovementPoints, opponentPlayerId: $opponentPlayerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VirtualPlayerMovedEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            const DeepCollectionEquality().equals(other._path, _path) &&
            (identical(
                  other.remainingMovementPoints,
                  remainingMovementPoints,
                ) ||
                other.remainingMovementPoints == remainingMovementPoints) &&
            (identical(other.opponentPlayerId, opponentPlayerId) ||
                other.opponentPlayerId == opponentPlayerId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    playerId,
    const DeepCollectionEquality().hash(_path),
    remainingMovementPoints,
    opponentPlayerId,
  );

  /// Create a copy of VirtualPlayerMovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VirtualPlayerMovedEventImplCopyWith<_$VirtualPlayerMovedEventImpl>
  get copyWith =>
      __$$VirtualPlayerMovedEventImplCopyWithImpl<
        _$VirtualPlayerMovedEventImpl
      >(this, _$identity);
}

abstract class _VirtualPlayerMovedEvent implements VirtualPlayerMovedEvent {
  const factory _VirtualPlayerMovedEvent({
    required final String playerId,
    required final List<GameBoardPosition> path,
    required final int remainingMovementPoints,
    final String opponentPlayerId,
  }) = _$VirtualPlayerMovedEventImpl;

  @override
  String get playerId;
  @override
  List<GameBoardPosition> get path;
  @override
  int get remainingMovementPoints;
  @override
  String get opponentPlayerId;

  /// Create a copy of VirtualPlayerMovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VirtualPlayerMovedEventImplCopyWith<_$VirtualPlayerMovedEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SynchronizeMovementEvent {
  String get playerId => throw _privateConstructorUsedError;
  GameBoardPosition get destination => throw _privateConstructorUsedError;

  /// Create a copy of SynchronizeMovementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SynchronizeMovementEventCopyWith<SynchronizeMovementEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SynchronizeMovementEventCopyWith<$Res> {
  factory $SynchronizeMovementEventCopyWith(
    SynchronizeMovementEvent value,
    $Res Function(SynchronizeMovementEvent) then,
  ) = _$SynchronizeMovementEventCopyWithImpl<$Res, SynchronizeMovementEvent>;
  @useResult
  $Res call({String playerId, GameBoardPosition destination});

  $GameBoardPositionCopyWith<$Res> get destination;
}

/// @nodoc
class _$SynchronizeMovementEventCopyWithImpl<
  $Res,
  $Val extends SynchronizeMovementEvent
>
    implements $SynchronizeMovementEventCopyWith<$Res> {
  _$SynchronizeMovementEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SynchronizeMovementEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null, Object? destination = null}) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            destination: null == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as GameBoardPosition,
          )
          as $Val,
    );
  }

  /// Create a copy of SynchronizeMovementEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameBoardPositionCopyWith<$Res> get destination {
    return $GameBoardPositionCopyWith<$Res>(_value.destination, (value) {
      return _then(_value.copyWith(destination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SynchronizeMovementEventImplCopyWith<$Res>
    implements $SynchronizeMovementEventCopyWith<$Res> {
  factory _$$SynchronizeMovementEventImplCopyWith(
    _$SynchronizeMovementEventImpl value,
    $Res Function(_$SynchronizeMovementEventImpl) then,
  ) = __$$SynchronizeMovementEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId, GameBoardPosition destination});

  @override
  $GameBoardPositionCopyWith<$Res> get destination;
}

/// @nodoc
class __$$SynchronizeMovementEventImplCopyWithImpl<$Res>
    extends
        _$SynchronizeMovementEventCopyWithImpl<
          $Res,
          _$SynchronizeMovementEventImpl
        >
    implements _$$SynchronizeMovementEventImplCopyWith<$Res> {
  __$$SynchronizeMovementEventImplCopyWithImpl(
    _$SynchronizeMovementEventImpl _value,
    $Res Function(_$SynchronizeMovementEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SynchronizeMovementEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null, Object? destination = null}) {
    return _then(
      _$SynchronizeMovementEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        destination: null == destination
            ? _value.destination
            : destination // ignore: cast_nullable_to_non_nullable
                  as GameBoardPosition,
      ),
    );
  }
}

/// @nodoc

class _$SynchronizeMovementEventImpl implements _SynchronizeMovementEvent {
  const _$SynchronizeMovementEventImpl({
    required this.playerId,
    required this.destination,
  });

  @override
  final String playerId;
  @override
  final GameBoardPosition destination;

  @override
  String toString() {
    return 'SynchronizeMovementEvent(playerId: $playerId, destination: $destination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SynchronizeMovementEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.destination, destination) ||
                other.destination == destination));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId, destination);

  /// Create a copy of SynchronizeMovementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SynchronizeMovementEventImplCopyWith<_$SynchronizeMovementEventImpl>
  get copyWith =>
      __$$SynchronizeMovementEventImplCopyWithImpl<
        _$SynchronizeMovementEventImpl
      >(this, _$identity);
}

abstract class _SynchronizeMovementEvent implements SynchronizeMovementEvent {
  const factory _SynchronizeMovementEvent({
    required final String playerId,
    required final GameBoardPosition destination,
  }) = _$SynchronizeMovementEventImpl;

  @override
  String get playerId;
  @override
  GameBoardPosition get destination;

  /// Create a copy of SynchronizeMovementEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SynchronizeMovementEventImplCopyWith<_$SynchronizeMovementEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReachablePath {
  GameBoardPosition get from => throw _privateConstructorUsedError;
  List<GameBoardPosition> get path => throw _privateConstructorUsedError;

  /// Create a copy of ReachablePath
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReachablePathCopyWith<ReachablePath> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReachablePathCopyWith<$Res> {
  factory $ReachablePathCopyWith(
    ReachablePath value,
    $Res Function(ReachablePath) then,
  ) = _$ReachablePathCopyWithImpl<$Res, ReachablePath>;
  @useResult
  $Res call({GameBoardPosition from, List<GameBoardPosition> path});

  $GameBoardPositionCopyWith<$Res> get from;
}

/// @nodoc
class _$ReachablePathCopyWithImpl<$Res, $Val extends ReachablePath>
    implements $ReachablePathCopyWith<$Res> {
  _$ReachablePathCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReachablePath
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? from = null, Object? path = null}) {
    return _then(
      _value.copyWith(
            from: null == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                      as GameBoardPosition,
            path: null == path
                ? _value.path
                : path // ignore: cast_nullable_to_non_nullable
                      as List<GameBoardPosition>,
          )
          as $Val,
    );
  }

  /// Create a copy of ReachablePath
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameBoardPositionCopyWith<$Res> get from {
    return $GameBoardPositionCopyWith<$Res>(_value.from, (value) {
      return _then(_value.copyWith(from: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReachablePathImplCopyWith<$Res>
    implements $ReachablePathCopyWith<$Res> {
  factory _$$ReachablePathImplCopyWith(
    _$ReachablePathImpl value,
    $Res Function(_$ReachablePathImpl) then,
  ) = __$$ReachablePathImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GameBoardPosition from, List<GameBoardPosition> path});

  @override
  $GameBoardPositionCopyWith<$Res> get from;
}

/// @nodoc
class __$$ReachablePathImplCopyWithImpl<$Res>
    extends _$ReachablePathCopyWithImpl<$Res, _$ReachablePathImpl>
    implements _$$ReachablePathImplCopyWith<$Res> {
  __$$ReachablePathImplCopyWithImpl(
    _$ReachablePathImpl _value,
    $Res Function(_$ReachablePathImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReachablePath
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? from = null, Object? path = null}) {
    return _then(
      _$ReachablePathImpl(
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as GameBoardPosition,
        path: null == path
            ? _value._path
            : path // ignore: cast_nullable_to_non_nullable
                  as List<GameBoardPosition>,
      ),
    );
  }
}

/// @nodoc

class _$ReachablePathImpl implements _ReachablePath {
  const _$ReachablePathImpl({
    required this.from,
    required final List<GameBoardPosition> path,
  }) : _path = path;

  @override
  final GameBoardPosition from;
  final List<GameBoardPosition> _path;
  @override
  List<GameBoardPosition> get path {
    if (_path is EqualUnmodifiableListView) return _path;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_path);
  }

  @override
  String toString() {
    return 'ReachablePath(from: $from, path: $path)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReachablePathImpl &&
            (identical(other.from, from) || other.from == from) &&
            const DeepCollectionEquality().equals(other._path, _path));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    from,
    const DeepCollectionEquality().hash(_path),
  );

  /// Create a copy of ReachablePath
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReachablePathImplCopyWith<_$ReachablePathImpl> get copyWith =>
      __$$ReachablePathImplCopyWithImpl<_$ReachablePathImpl>(this, _$identity);
}

abstract class _ReachablePath implements ReachablePath {
  const factory _ReachablePath({
    required final GameBoardPosition from,
    required final List<GameBoardPosition> path,
  }) = _$ReachablePathImpl;

  @override
  GameBoardPosition get from;
  @override
  List<GameBoardPosition> get path;

  /// Create a copy of ReachablePath
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReachablePathImplCopyWith<_$ReachablePathImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReachablePathsResponseEvent {
  List<ReachablePath> get paths => throw _privateConstructorUsedError;

  /// Create a copy of ReachablePathsResponseEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReachablePathsResponseEventCopyWith<ReachablePathsResponseEvent>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReachablePathsResponseEventCopyWith<$Res> {
  factory $ReachablePathsResponseEventCopyWith(
    ReachablePathsResponseEvent value,
    $Res Function(ReachablePathsResponseEvent) then,
  ) =
      _$ReachablePathsResponseEventCopyWithImpl<
        $Res,
        ReachablePathsResponseEvent
      >;
  @useResult
  $Res call({List<ReachablePath> paths});
}

/// @nodoc
class _$ReachablePathsResponseEventCopyWithImpl<
  $Res,
  $Val extends ReachablePathsResponseEvent
>
    implements $ReachablePathsResponseEventCopyWith<$Res> {
  _$ReachablePathsResponseEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReachablePathsResponseEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? paths = null}) {
    return _then(
      _value.copyWith(
            paths: null == paths
                ? _value.paths
                : paths // ignore: cast_nullable_to_non_nullable
                      as List<ReachablePath>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReachablePathsResponseEventImplCopyWith<$Res>
    implements $ReachablePathsResponseEventCopyWith<$Res> {
  factory _$$ReachablePathsResponseEventImplCopyWith(
    _$ReachablePathsResponseEventImpl value,
    $Res Function(_$ReachablePathsResponseEventImpl) then,
  ) = __$$ReachablePathsResponseEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ReachablePath> paths});
}

/// @nodoc
class __$$ReachablePathsResponseEventImplCopyWithImpl<$Res>
    extends
        _$ReachablePathsResponseEventCopyWithImpl<
          $Res,
          _$ReachablePathsResponseEventImpl
        >
    implements _$$ReachablePathsResponseEventImplCopyWith<$Res> {
  __$$ReachablePathsResponseEventImplCopyWithImpl(
    _$ReachablePathsResponseEventImpl _value,
    $Res Function(_$ReachablePathsResponseEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReachablePathsResponseEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? paths = null}) {
    return _then(
      _$ReachablePathsResponseEventImpl(
        paths: null == paths
            ? _value._paths
            : paths // ignore: cast_nullable_to_non_nullable
                  as List<ReachablePath>,
      ),
    );
  }
}

/// @nodoc

class _$ReachablePathsResponseEventImpl
    implements _ReachablePathsResponseEvent {
  const _$ReachablePathsResponseEventImpl({
    required final List<ReachablePath> paths,
  }) : _paths = paths;

  final List<ReachablePath> _paths;
  @override
  List<ReachablePath> get paths {
    if (_paths is EqualUnmodifiableListView) return _paths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paths);
  }

  @override
  String toString() {
    return 'ReachablePathsResponseEvent(paths: $paths)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReachablePathsResponseEventImpl &&
            const DeepCollectionEquality().equals(other._paths, _paths));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_paths));

  /// Create a copy of ReachablePathsResponseEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReachablePathsResponseEventImplCopyWith<_$ReachablePathsResponseEventImpl>
  get copyWith =>
      __$$ReachablePathsResponseEventImplCopyWithImpl<
        _$ReachablePathsResponseEventImpl
      >(this, _$identity);
}

abstract class _ReachablePathsResponseEvent
    implements ReachablePathsResponseEvent {
  const factory _ReachablePathsResponseEvent({
    required final List<ReachablePath> paths,
  }) = _$ReachablePathsResponseEventImpl;

  @override
  List<ReachablePath> get paths;

  /// Create a copy of ReachablePathsResponseEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReachablePathsResponseEventImplCopyWith<_$ReachablePathsResponseEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlayerMovementStepEvent {
  String get playerId => throw _privateConstructorUsedError;
  GameBoardPosition get destination => throw _privateConstructorUsedError;
  BoardCharacterOrientation get orientation =>
      throw _privateConstructorUsedError;

  /// Create a copy of PlayerMovementStepEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerMovementStepEventCopyWith<PlayerMovementStepEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerMovementStepEventCopyWith<$Res> {
  factory $PlayerMovementStepEventCopyWith(
    PlayerMovementStepEvent value,
    $Res Function(PlayerMovementStepEvent) then,
  ) = _$PlayerMovementStepEventCopyWithImpl<$Res, PlayerMovementStepEvent>;
  @useResult
  $Res call({
    String playerId,
    GameBoardPosition destination,
    BoardCharacterOrientation orientation,
  });

  $GameBoardPositionCopyWith<$Res> get destination;
}

/// @nodoc
class _$PlayerMovementStepEventCopyWithImpl<
  $Res,
  $Val extends PlayerMovementStepEvent
>
    implements $PlayerMovementStepEventCopyWith<$Res> {
  _$PlayerMovementStepEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerMovementStepEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? destination = null,
    Object? orientation = null,
  }) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            destination: null == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as GameBoardPosition,
            orientation: null == orientation
                ? _value.orientation
                : orientation // ignore: cast_nullable_to_non_nullable
                      as BoardCharacterOrientation,
          )
          as $Val,
    );
  }

  /// Create a copy of PlayerMovementStepEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameBoardPositionCopyWith<$Res> get destination {
    return $GameBoardPositionCopyWith<$Res>(_value.destination, (value) {
      return _then(_value.copyWith(destination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerMovementStepEventImplCopyWith<$Res>
    implements $PlayerMovementStepEventCopyWith<$Res> {
  factory _$$PlayerMovementStepEventImplCopyWith(
    _$PlayerMovementStepEventImpl value,
    $Res Function(_$PlayerMovementStepEventImpl) then,
  ) = __$$PlayerMovementStepEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String playerId,
    GameBoardPosition destination,
    BoardCharacterOrientation orientation,
  });

  @override
  $GameBoardPositionCopyWith<$Res> get destination;
}

/// @nodoc
class __$$PlayerMovementStepEventImplCopyWithImpl<$Res>
    extends
        _$PlayerMovementStepEventCopyWithImpl<
          $Res,
          _$PlayerMovementStepEventImpl
        >
    implements _$$PlayerMovementStepEventImplCopyWith<$Res> {
  __$$PlayerMovementStepEventImplCopyWithImpl(
    _$PlayerMovementStepEventImpl _value,
    $Res Function(_$PlayerMovementStepEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerMovementStepEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? destination = null,
    Object? orientation = null,
  }) {
    return _then(
      _$PlayerMovementStepEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        destination: null == destination
            ? _value.destination
            : destination // ignore: cast_nullable_to_non_nullable
                  as GameBoardPosition,
        orientation: null == orientation
            ? _value.orientation
            : orientation // ignore: cast_nullable_to_non_nullable
                  as BoardCharacterOrientation,
      ),
    );
  }
}

/// @nodoc

class _$PlayerMovementStepEventImpl implements _PlayerMovementStepEvent {
  const _$PlayerMovementStepEventImpl({
    required this.playerId,
    required this.destination,
    required this.orientation,
  });

  @override
  final String playerId;
  @override
  final GameBoardPosition destination;
  @override
  final BoardCharacterOrientation orientation;

  @override
  String toString() {
    return 'PlayerMovementStepEvent(playerId: $playerId, destination: $destination, orientation: $orientation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerMovementStepEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.orientation, orientation) ||
                other.orientation == orientation));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, playerId, destination, orientation);

  /// Create a copy of PlayerMovementStepEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerMovementStepEventImplCopyWith<_$PlayerMovementStepEventImpl>
  get copyWith =>
      __$$PlayerMovementStepEventImplCopyWithImpl<
        _$PlayerMovementStepEventImpl
      >(this, _$identity);
}

abstract class _PlayerMovementStepEvent implements PlayerMovementStepEvent {
  const factory _PlayerMovementStepEvent({
    required final String playerId,
    required final GameBoardPosition destination,
    required final BoardCharacterOrientation orientation,
  }) = _$PlayerMovementStepEventImpl;

  @override
  String get playerId;
  @override
  GameBoardPosition get destination;
  @override
  BoardCharacterOrientation get orientation;

  /// Create a copy of PlayerMovementStepEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerMovementStepEventImplCopyWith<_$PlayerMovementStepEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlayerIdleResetEvent {
  String get playerId => throw _privateConstructorUsedError;

  /// Create a copy of PlayerIdleResetEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerIdleResetEventCopyWith<PlayerIdleResetEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerIdleResetEventCopyWith<$Res> {
  factory $PlayerIdleResetEventCopyWith(
    PlayerIdleResetEvent value,
    $Res Function(PlayerIdleResetEvent) then,
  ) = _$PlayerIdleResetEventCopyWithImpl<$Res, PlayerIdleResetEvent>;
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class _$PlayerIdleResetEventCopyWithImpl<
  $Res,
  $Val extends PlayerIdleResetEvent
>
    implements $PlayerIdleResetEventCopyWith<$Res> {
  _$PlayerIdleResetEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerIdleResetEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null}) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerIdleResetEventImplCopyWith<$Res>
    implements $PlayerIdleResetEventCopyWith<$Res> {
  factory _$$PlayerIdleResetEventImplCopyWith(
    _$PlayerIdleResetEventImpl value,
    $Res Function(_$PlayerIdleResetEventImpl) then,
  ) = __$$PlayerIdleResetEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class __$$PlayerIdleResetEventImplCopyWithImpl<$Res>
    extends _$PlayerIdleResetEventCopyWithImpl<$Res, _$PlayerIdleResetEventImpl>
    implements _$$PlayerIdleResetEventImplCopyWith<$Res> {
  __$$PlayerIdleResetEventImplCopyWithImpl(
    _$PlayerIdleResetEventImpl _value,
    $Res Function(_$PlayerIdleResetEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerIdleResetEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null}) {
    return _then(
      _$PlayerIdleResetEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PlayerIdleResetEventImpl implements _PlayerIdleResetEvent {
  const _$PlayerIdleResetEventImpl({required this.playerId});

  @override
  final String playerId;

  @override
  String toString() {
    return 'PlayerIdleResetEvent(playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerIdleResetEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId);

  /// Create a copy of PlayerIdleResetEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerIdleResetEventImplCopyWith<_$PlayerIdleResetEventImpl>
  get copyWith =>
      __$$PlayerIdleResetEventImplCopyWithImpl<_$PlayerIdleResetEventImpl>(
        this,
        _$identity,
      );
}

abstract class _PlayerIdleResetEvent implements PlayerIdleResetEvent {
  const factory _PlayerIdleResetEvent({required final String playerId}) =
      _$PlayerIdleResetEventImpl;

  @override
  String get playerId;

  /// Create a copy of PlayerIdleResetEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerIdleResetEventImplCopyWith<_$PlayerIdleResetEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}
