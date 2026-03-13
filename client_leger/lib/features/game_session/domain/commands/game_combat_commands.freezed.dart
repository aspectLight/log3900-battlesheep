// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_combat_commands.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StartCombatCommand {
  String get roomId => throw _privateConstructorUsedError;
  String get opponentId => throw _privateConstructorUsedError;

  /// Create a copy of StartCombatCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StartCombatCommandCopyWith<StartCombatCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StartCombatCommandCopyWith<$Res> {
  factory $StartCombatCommandCopyWith(
    StartCombatCommand value,
    $Res Function(StartCombatCommand) then,
  ) = _$StartCombatCommandCopyWithImpl<$Res, StartCombatCommand>;
  @useResult
  $Res call({String roomId, String opponentId});
}

/// @nodoc
class _$StartCombatCommandCopyWithImpl<$Res, $Val extends StartCombatCommand>
    implements $StartCombatCommandCopyWith<$Res> {
  _$StartCombatCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StartCombatCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? opponentId = null}) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            opponentId: null == opponentId
                ? _value.opponentId
                : opponentId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StartCombatCommandImplCopyWith<$Res>
    implements $StartCombatCommandCopyWith<$Res> {
  factory _$$StartCombatCommandImplCopyWith(
    _$StartCombatCommandImpl value,
    $Res Function(_$StartCombatCommandImpl) then,
  ) = __$$StartCombatCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, String opponentId});
}

/// @nodoc
class __$$StartCombatCommandImplCopyWithImpl<$Res>
    extends _$StartCombatCommandCopyWithImpl<$Res, _$StartCombatCommandImpl>
    implements _$$StartCombatCommandImplCopyWith<$Res> {
  __$$StartCombatCommandImplCopyWithImpl(
    _$StartCombatCommandImpl _value,
    $Res Function(_$StartCombatCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StartCombatCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? opponentId = null}) {
    return _then(
      _$StartCombatCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        opponentId: null == opponentId
            ? _value.opponentId
            : opponentId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$StartCombatCommandImpl implements _StartCombatCommand {
  const _$StartCombatCommandImpl({
    required this.roomId,
    required this.opponentId,
  });

  @override
  final String roomId;
  @override
  final String opponentId;

  @override
  String toString() {
    return 'StartCombatCommand(roomId: $roomId, opponentId: $opponentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartCombatCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.opponentId, opponentId) ||
                other.opponentId == opponentId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, opponentId);

  /// Create a copy of StartCombatCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartCombatCommandImplCopyWith<_$StartCombatCommandImpl> get copyWith =>
      __$$StartCombatCommandImplCopyWithImpl<_$StartCombatCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _StartCombatCommand implements StartCombatCommand {
  const factory _StartCombatCommand({
    required final String roomId,
    required final String opponentId,
  }) = _$StartCombatCommandImpl;

  @override
  String get roomId;
  @override
  String get opponentId;

  /// Create a copy of StartCombatCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartCombatCommandImplCopyWith<_$StartCombatCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StartVirtualCombatCommand {
  String get roomId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get opponentId => throw _privateConstructorUsedError;

  /// Create a copy of StartVirtualCombatCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StartVirtualCombatCommandCopyWith<StartVirtualCombatCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StartVirtualCombatCommandCopyWith<$Res> {
  factory $StartVirtualCombatCommandCopyWith(
    StartVirtualCombatCommand value,
    $Res Function(StartVirtualCombatCommand) then,
  ) = _$StartVirtualCombatCommandCopyWithImpl<$Res, StartVirtualCombatCommand>;
  @useResult
  $Res call({String roomId, String playerId, String opponentId});
}

/// @nodoc
class _$StartVirtualCombatCommandCopyWithImpl<
  $Res,
  $Val extends StartVirtualCombatCommand
>
    implements $StartVirtualCombatCommandCopyWith<$Res> {
  _$StartVirtualCombatCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StartVirtualCombatCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? opponentId = null,
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
            opponentId: null == opponentId
                ? _value.opponentId
                : opponentId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StartVirtualCombatCommandImplCopyWith<$Res>
    implements $StartVirtualCombatCommandCopyWith<$Res> {
  factory _$$StartVirtualCombatCommandImplCopyWith(
    _$StartVirtualCombatCommandImpl value,
    $Res Function(_$StartVirtualCombatCommandImpl) then,
  ) = __$$StartVirtualCombatCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, String playerId, String opponentId});
}

/// @nodoc
class __$$StartVirtualCombatCommandImplCopyWithImpl<$Res>
    extends
        _$StartVirtualCombatCommandCopyWithImpl<
          $Res,
          _$StartVirtualCombatCommandImpl
        >
    implements _$$StartVirtualCombatCommandImplCopyWith<$Res> {
  __$$StartVirtualCombatCommandImplCopyWithImpl(
    _$StartVirtualCombatCommandImpl _value,
    $Res Function(_$StartVirtualCombatCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StartVirtualCombatCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? opponentId = null,
  }) {
    return _then(
      _$StartVirtualCombatCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        opponentId: null == opponentId
            ? _value.opponentId
            : opponentId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$StartVirtualCombatCommandImpl implements _StartVirtualCombatCommand {
  const _$StartVirtualCombatCommandImpl({
    required this.roomId,
    required this.playerId,
    required this.opponentId,
  });

  @override
  final String roomId;
  @override
  final String playerId;
  @override
  final String opponentId;

  @override
  String toString() {
    return 'StartVirtualCombatCommand(roomId: $roomId, playerId: $playerId, opponentId: $opponentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartVirtualCombatCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.opponentId, opponentId) ||
                other.opponentId == opponentId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, playerId, opponentId);

  /// Create a copy of StartVirtualCombatCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartVirtualCombatCommandImplCopyWith<_$StartVirtualCombatCommandImpl>
  get copyWith =>
      __$$StartVirtualCombatCommandImplCopyWithImpl<
        _$StartVirtualCombatCommandImpl
      >(this, _$identity);
}

abstract class _StartVirtualCombatCommand implements StartVirtualCombatCommand {
  const factory _StartVirtualCombatCommand({
    required final String roomId,
    required final String playerId,
    required final String opponentId,
  }) = _$StartVirtualCombatCommandImpl;

  @override
  String get roomId;
  @override
  String get playerId;
  @override
  String get opponentId;

  /// Create a copy of StartVirtualCombatCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartVirtualCombatCommandImplCopyWith<_$StartVirtualCombatCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AttackCommand {
  String get roomId => throw _privateConstructorUsedError;

  /// Create a copy of AttackCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttackCommandCopyWith<AttackCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttackCommandCopyWith<$Res> {
  factory $AttackCommandCopyWith(
    AttackCommand value,
    $Res Function(AttackCommand) then,
  ) = _$AttackCommandCopyWithImpl<$Res, AttackCommand>;
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class _$AttackCommandCopyWithImpl<$Res, $Val extends AttackCommand>
    implements $AttackCommandCopyWith<$Res> {
  _$AttackCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttackCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttackCommandImplCopyWith<$Res>
    implements $AttackCommandCopyWith<$Res> {
  factory _$$AttackCommandImplCopyWith(
    _$AttackCommandImpl value,
    $Res Function(_$AttackCommandImpl) then,
  ) = __$$AttackCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class __$$AttackCommandImplCopyWithImpl<$Res>
    extends _$AttackCommandCopyWithImpl<$Res, _$AttackCommandImpl>
    implements _$$AttackCommandImplCopyWith<$Res> {
  __$$AttackCommandImplCopyWithImpl(
    _$AttackCommandImpl _value,
    $Res Function(_$AttackCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AttackCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _$AttackCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AttackCommandImpl implements _AttackCommand {
  const _$AttackCommandImpl({required this.roomId});

  @override
  final String roomId;

  @override
  String toString() {
    return 'AttackCommand(roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttackCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId);

  /// Create a copy of AttackCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttackCommandImplCopyWith<_$AttackCommandImpl> get copyWith =>
      __$$AttackCommandImplCopyWithImpl<_$AttackCommandImpl>(this, _$identity);
}

abstract class _AttackCommand implements AttackCommand {
  const factory _AttackCommand({required final String roomId}) =
      _$AttackCommandImpl;

  @override
  String get roomId;

  /// Create a copy of AttackCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttackCommandImplCopyWith<_$AttackCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FlightAttemptCommand {
  String get roomId => throw _privateConstructorUsedError;

  /// Create a copy of FlightAttemptCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlightAttemptCommandCopyWith<FlightAttemptCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlightAttemptCommandCopyWith<$Res> {
  factory $FlightAttemptCommandCopyWith(
    FlightAttemptCommand value,
    $Res Function(FlightAttemptCommand) then,
  ) = _$FlightAttemptCommandCopyWithImpl<$Res, FlightAttemptCommand>;
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class _$FlightAttemptCommandCopyWithImpl<
  $Res,
  $Val extends FlightAttemptCommand
>
    implements $FlightAttemptCommandCopyWith<$Res> {
  _$FlightAttemptCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlightAttemptCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FlightAttemptCommandImplCopyWith<$Res>
    implements $FlightAttemptCommandCopyWith<$Res> {
  factory _$$FlightAttemptCommandImplCopyWith(
    _$FlightAttemptCommandImpl value,
    $Res Function(_$FlightAttemptCommandImpl) then,
  ) = __$$FlightAttemptCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class __$$FlightAttemptCommandImplCopyWithImpl<$Res>
    extends _$FlightAttemptCommandCopyWithImpl<$Res, _$FlightAttemptCommandImpl>
    implements _$$FlightAttemptCommandImplCopyWith<$Res> {
  __$$FlightAttemptCommandImplCopyWithImpl(
    _$FlightAttemptCommandImpl _value,
    $Res Function(_$FlightAttemptCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlightAttemptCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _$FlightAttemptCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FlightAttemptCommandImpl implements _FlightAttemptCommand {
  const _$FlightAttemptCommandImpl({required this.roomId});

  @override
  final String roomId;

  @override
  String toString() {
    return 'FlightAttemptCommand(roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlightAttemptCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId);

  /// Create a copy of FlightAttemptCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlightAttemptCommandImplCopyWith<_$FlightAttemptCommandImpl>
  get copyWith =>
      __$$FlightAttemptCommandImplCopyWithImpl<_$FlightAttemptCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _FlightAttemptCommand implements FlightAttemptCommand {
  const factory _FlightAttemptCommand({required final String roomId}) =
      _$FlightAttemptCommandImpl;

  @override
  String get roomId;

  /// Create a copy of FlightAttemptCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlightAttemptCommandImplCopyWith<_$FlightAttemptCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}
