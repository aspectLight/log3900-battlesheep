// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_movement_commands.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PlayerGetMovementsCommand {
  String get roomId => throw _privateConstructorUsedError;
  bool get hasBoots => throw _privateConstructorUsedError;

  /// Create a copy of PlayerGetMovementsCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerGetMovementsCommandCopyWith<PlayerGetMovementsCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerGetMovementsCommandCopyWith<$Res> {
  factory $PlayerGetMovementsCommandCopyWith(
    PlayerGetMovementsCommand value,
    $Res Function(PlayerGetMovementsCommand) then,
  ) = _$PlayerGetMovementsCommandCopyWithImpl<$Res, PlayerGetMovementsCommand>;
  @useResult
  $Res call({String roomId, bool hasBoots});
}

/// @nodoc
class _$PlayerGetMovementsCommandCopyWithImpl<
  $Res,
  $Val extends PlayerGetMovementsCommand
>
    implements $PlayerGetMovementsCommandCopyWith<$Res> {
  _$PlayerGetMovementsCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerGetMovementsCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? hasBoots = null}) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            hasBoots: null == hasBoots
                ? _value.hasBoots
                : hasBoots // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerGetMovementsCommandImplCopyWith<$Res>
    implements $PlayerGetMovementsCommandCopyWith<$Res> {
  factory _$$PlayerGetMovementsCommandImplCopyWith(
    _$PlayerGetMovementsCommandImpl value,
    $Res Function(_$PlayerGetMovementsCommandImpl) then,
  ) = __$$PlayerGetMovementsCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, bool hasBoots});
}

/// @nodoc
class __$$PlayerGetMovementsCommandImplCopyWithImpl<$Res>
    extends
        _$PlayerGetMovementsCommandCopyWithImpl<
          $Res,
          _$PlayerGetMovementsCommandImpl
        >
    implements _$$PlayerGetMovementsCommandImplCopyWith<$Res> {
  __$$PlayerGetMovementsCommandImplCopyWithImpl(
    _$PlayerGetMovementsCommandImpl _value,
    $Res Function(_$PlayerGetMovementsCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerGetMovementsCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? hasBoots = null}) {
    return _then(
      _$PlayerGetMovementsCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        hasBoots: null == hasBoots
            ? _value.hasBoots
            : hasBoots // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$PlayerGetMovementsCommandImpl implements _PlayerGetMovementsCommand {
  const _$PlayerGetMovementsCommandImpl({
    required this.roomId,
    required this.hasBoots,
  });

  @override
  final String roomId;
  @override
  final bool hasBoots;

  @override
  String toString() {
    return 'PlayerGetMovementsCommand(roomId: $roomId, hasBoots: $hasBoots)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerGetMovementsCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.hasBoots, hasBoots) ||
                other.hasBoots == hasBoots));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, hasBoots);

  /// Create a copy of PlayerGetMovementsCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerGetMovementsCommandImplCopyWith<_$PlayerGetMovementsCommandImpl>
  get copyWith =>
      __$$PlayerGetMovementsCommandImplCopyWithImpl<
        _$PlayerGetMovementsCommandImpl
      >(this, _$identity);
}

abstract class _PlayerGetMovementsCommand implements PlayerGetMovementsCommand {
  const factory _PlayerGetMovementsCommand({
    required final String roomId,
    required final bool hasBoots,
  }) = _$PlayerGetMovementsCommandImpl;

  @override
  String get roomId;
  @override
  bool get hasBoots;

  /// Create a copy of PlayerGetMovementsCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerGetMovementsCommandImplCopyWith<_$PlayerGetMovementsCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlayerMovedCommand {
  String get roomId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  List<GameBoardPosition> get selectedPath =>
      throw _privateConstructorUsedError;

  /// Create a copy of PlayerMovedCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerMovedCommandCopyWith<PlayerMovedCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerMovedCommandCopyWith<$Res> {
  factory $PlayerMovedCommandCopyWith(
    PlayerMovedCommand value,
    $Res Function(PlayerMovedCommand) then,
  ) = _$PlayerMovedCommandCopyWithImpl<$Res, PlayerMovedCommand>;
  @useResult
  $Res call({
    String roomId,
    String playerId,
    List<GameBoardPosition> selectedPath,
  });
}

/// @nodoc
class _$PlayerMovedCommandCopyWithImpl<$Res, $Val extends PlayerMovedCommand>
    implements $PlayerMovedCommandCopyWith<$Res> {
  _$PlayerMovedCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerMovedCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? selectedPath = null,
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
abstract class _$$PlayerMovedCommandImplCopyWith<$Res>
    implements $PlayerMovedCommandCopyWith<$Res> {
  factory _$$PlayerMovedCommandImplCopyWith(
    _$PlayerMovedCommandImpl value,
    $Res Function(_$PlayerMovedCommandImpl) then,
  ) = __$$PlayerMovedCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roomId,
    String playerId,
    List<GameBoardPosition> selectedPath,
  });
}

/// @nodoc
class __$$PlayerMovedCommandImplCopyWithImpl<$Res>
    extends _$PlayerMovedCommandCopyWithImpl<$Res, _$PlayerMovedCommandImpl>
    implements _$$PlayerMovedCommandImplCopyWith<$Res> {
  __$$PlayerMovedCommandImplCopyWithImpl(
    _$PlayerMovedCommandImpl _value,
    $Res Function(_$PlayerMovedCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerMovedCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? selectedPath = null,
  }) {
    return _then(
      _$PlayerMovedCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedPath: null == selectedPath
            ? _value._selectedPath
            : selectedPath // ignore: cast_nullable_to_non_nullable
                  as List<GameBoardPosition>,
      ),
    );
  }
}

/// @nodoc

class _$PlayerMovedCommandImpl implements _PlayerMovedCommand {
  const _$PlayerMovedCommandImpl({
    required this.roomId,
    required this.playerId,
    required final List<GameBoardPosition> selectedPath,
  }) : _selectedPath = selectedPath;

  @override
  final String roomId;
  @override
  final String playerId;
  final List<GameBoardPosition> _selectedPath;
  @override
  List<GameBoardPosition> get selectedPath {
    if (_selectedPath is EqualUnmodifiableListView) return _selectedPath;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedPath);
  }

  @override
  String toString() {
    return 'PlayerMovedCommand(roomId: $roomId, playerId: $playerId, selectedPath: $selectedPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerMovedCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            const DeepCollectionEquality().equals(
              other._selectedPath,
              _selectedPath,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    roomId,
    playerId,
    const DeepCollectionEquality().hash(_selectedPath),
  );

  /// Create a copy of PlayerMovedCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerMovedCommandImplCopyWith<_$PlayerMovedCommandImpl> get copyWith =>
      __$$PlayerMovedCommandImplCopyWithImpl<_$PlayerMovedCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _PlayerMovedCommand implements PlayerMovedCommand {
  const factory _PlayerMovedCommand({
    required final String roomId,
    required final String playerId,
    required final List<GameBoardPosition> selectedPath,
  }) = _$PlayerMovedCommandImpl;

  @override
  String get roomId;
  @override
  String get playerId;
  @override
  List<GameBoardPosition> get selectedPath;

  /// Create a copy of PlayerMovedCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerMovedCommandImplCopyWith<_$PlayerMovedCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlayerTeleportedCommand {
  String get roomId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  GameBoardPosition get destination => throw _privateConstructorUsedError;
  bool get hasCamouflage => throw _privateConstructorUsedError;

  /// Create a copy of PlayerTeleportedCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerTeleportedCommandCopyWith<PlayerTeleportedCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerTeleportedCommandCopyWith<$Res> {
  factory $PlayerTeleportedCommandCopyWith(
    PlayerTeleportedCommand value,
    $Res Function(PlayerTeleportedCommand) then,
  ) = _$PlayerTeleportedCommandCopyWithImpl<$Res, PlayerTeleportedCommand>;
  @useResult
  $Res call({
    String roomId,
    String playerId,
    GameBoardPosition destination,
    bool hasCamouflage,
  });

  $GameBoardPositionCopyWith<$Res> get destination;
}

/// @nodoc
class _$PlayerTeleportedCommandCopyWithImpl<
  $Res,
  $Val extends PlayerTeleportedCommand
>
    implements $PlayerTeleportedCommandCopyWith<$Res> {
  _$PlayerTeleportedCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerTeleportedCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? destination = null,
    Object? hasCamouflage = null,
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
            destination: null == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as GameBoardPosition,
            hasCamouflage: null == hasCamouflage
                ? _value.hasCamouflage
                : hasCamouflage // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of PlayerTeleportedCommand
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
abstract class _$$PlayerTeleportedCommandImplCopyWith<$Res>
    implements $PlayerTeleportedCommandCopyWith<$Res> {
  factory _$$PlayerTeleportedCommandImplCopyWith(
    _$PlayerTeleportedCommandImpl value,
    $Res Function(_$PlayerTeleportedCommandImpl) then,
  ) = __$$PlayerTeleportedCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roomId,
    String playerId,
    GameBoardPosition destination,
    bool hasCamouflage,
  });

  @override
  $GameBoardPositionCopyWith<$Res> get destination;
}

/// @nodoc
class __$$PlayerTeleportedCommandImplCopyWithImpl<$Res>
    extends
        _$PlayerTeleportedCommandCopyWithImpl<
          $Res,
          _$PlayerTeleportedCommandImpl
        >
    implements _$$PlayerTeleportedCommandImplCopyWith<$Res> {
  __$$PlayerTeleportedCommandImplCopyWithImpl(
    _$PlayerTeleportedCommandImpl _value,
    $Res Function(_$PlayerTeleportedCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerTeleportedCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? destination = null,
    Object? hasCamouflage = null,
  }) {
    return _then(
      _$PlayerTeleportedCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        destination: null == destination
            ? _value.destination
            : destination // ignore: cast_nullable_to_non_nullable
                  as GameBoardPosition,
        hasCamouflage: null == hasCamouflage
            ? _value.hasCamouflage
            : hasCamouflage // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$PlayerTeleportedCommandImpl implements _PlayerTeleportedCommand {
  const _$PlayerTeleportedCommandImpl({
    required this.roomId,
    required this.playerId,
    required this.destination,
    required this.hasCamouflage,
  });

  @override
  final String roomId;
  @override
  final String playerId;
  @override
  final GameBoardPosition destination;
  @override
  final bool hasCamouflage;

  @override
  String toString() {
    return 'PlayerTeleportedCommand(roomId: $roomId, playerId: $playerId, destination: $destination, hasCamouflage: $hasCamouflage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerTeleportedCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.hasCamouflage, hasCamouflage) ||
                other.hasCamouflage == hasCamouflage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, roomId, playerId, destination, hasCamouflage);

  /// Create a copy of PlayerTeleportedCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerTeleportedCommandImplCopyWith<_$PlayerTeleportedCommandImpl>
  get copyWith =>
      __$$PlayerTeleportedCommandImplCopyWithImpl<
        _$PlayerTeleportedCommandImpl
      >(this, _$identity);
}

abstract class _PlayerTeleportedCommand implements PlayerTeleportedCommand {
  const factory _PlayerTeleportedCommand({
    required final String roomId,
    required final String playerId,
    required final GameBoardPosition destination,
    required final bool hasCamouflage,
  }) = _$PlayerTeleportedCommandImpl;

  @override
  String get roomId;
  @override
  String get playerId;
  @override
  GameBoardPosition get destination;
  @override
  bool get hasCamouflage;

  /// Create a copy of PlayerTeleportedCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerTeleportedCommandImplCopyWith<_$PlayerTeleportedCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SynchronizeMovementCommand {
  String get roomId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  GameBoardPosition get destination => throw _privateConstructorUsedError;

  /// Create a copy of SynchronizeMovementCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SynchronizeMovementCommandCopyWith<SynchronizeMovementCommand>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SynchronizeMovementCommandCopyWith<$Res> {
  factory $SynchronizeMovementCommandCopyWith(
    SynchronizeMovementCommand value,
    $Res Function(SynchronizeMovementCommand) then,
  ) =
      _$SynchronizeMovementCommandCopyWithImpl<
        $Res,
        SynchronizeMovementCommand
      >;
  @useResult
  $Res call({String roomId, String playerId, GameBoardPosition destination});

  $GameBoardPositionCopyWith<$Res> get destination;
}

/// @nodoc
class _$SynchronizeMovementCommandCopyWithImpl<
  $Res,
  $Val extends SynchronizeMovementCommand
>
    implements $SynchronizeMovementCommandCopyWith<$Res> {
  _$SynchronizeMovementCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SynchronizeMovementCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? destination = null,
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
            destination: null == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as GameBoardPosition,
          )
          as $Val,
    );
  }

  /// Create a copy of SynchronizeMovementCommand
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
abstract class _$$SynchronizeMovementCommandImplCopyWith<$Res>
    implements $SynchronizeMovementCommandCopyWith<$Res> {
  factory _$$SynchronizeMovementCommandImplCopyWith(
    _$SynchronizeMovementCommandImpl value,
    $Res Function(_$SynchronizeMovementCommandImpl) then,
  ) = __$$SynchronizeMovementCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, String playerId, GameBoardPosition destination});

  @override
  $GameBoardPositionCopyWith<$Res> get destination;
}

/// @nodoc
class __$$SynchronizeMovementCommandImplCopyWithImpl<$Res>
    extends
        _$SynchronizeMovementCommandCopyWithImpl<
          $Res,
          _$SynchronizeMovementCommandImpl
        >
    implements _$$SynchronizeMovementCommandImplCopyWith<$Res> {
  __$$SynchronizeMovementCommandImplCopyWithImpl(
    _$SynchronizeMovementCommandImpl _value,
    $Res Function(_$SynchronizeMovementCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SynchronizeMovementCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? destination = null,
  }) {
    return _then(
      _$SynchronizeMovementCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
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

class _$SynchronizeMovementCommandImpl implements _SynchronizeMovementCommand {
  const _$SynchronizeMovementCommandImpl({
    required this.roomId,
    required this.playerId,
    required this.destination,
  });

  @override
  final String roomId;
  @override
  final String playerId;
  @override
  final GameBoardPosition destination;

  @override
  String toString() {
    return 'SynchronizeMovementCommand(roomId: $roomId, playerId: $playerId, destination: $destination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SynchronizeMovementCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.destination, destination) ||
                other.destination == destination));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, playerId, destination);

  /// Create a copy of SynchronizeMovementCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SynchronizeMovementCommandImplCopyWith<_$SynchronizeMovementCommandImpl>
  get copyWith =>
      __$$SynchronizeMovementCommandImplCopyWithImpl<
        _$SynchronizeMovementCommandImpl
      >(this, _$identity);
}

abstract class _SynchronizeMovementCommand
    implements SynchronizeMovementCommand {
  const factory _SynchronizeMovementCommand({
    required final String roomId,
    required final String playerId,
    required final GameBoardPosition destination,
  }) = _$SynchronizeMovementCommandImpl;

  @override
  String get roomId;
  @override
  String get playerId;
  @override
  GameBoardPosition get destination;

  /// Create a copy of SynchronizeMovementCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SynchronizeMovementCommandImplCopyWith<_$SynchronizeMovementCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}
