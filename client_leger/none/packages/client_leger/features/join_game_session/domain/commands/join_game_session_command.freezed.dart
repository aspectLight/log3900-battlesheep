// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_game_session_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$JoinGameSessionCommand {
  String get roomCode => throw _privateConstructorUsedError;
  String get socketId => throw _privateConstructorUsedError;

  /// Create a copy of JoinGameSessionCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JoinGameSessionCommandCopyWith<JoinGameSessionCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinGameSessionCommandCopyWith<$Res> {
  factory $JoinGameSessionCommandCopyWith(
    JoinGameSessionCommand value,
    $Res Function(JoinGameSessionCommand) then,
  ) = _$JoinGameSessionCommandCopyWithImpl<$Res, JoinGameSessionCommand>;
  @useResult
  $Res call({String roomCode, String socketId});
}

/// @nodoc
class _$JoinGameSessionCommandCopyWithImpl<
  $Res,
  $Val extends JoinGameSessionCommand
>
    implements $JoinGameSessionCommandCopyWith<$Res> {
  _$JoinGameSessionCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JoinGameSessionCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomCode = null, Object? socketId = null}) {
    return _then(
      _value.copyWith(
            roomCode: null == roomCode
                ? _value.roomCode
                : roomCode // ignore: cast_nullable_to_non_nullable
                      as String,
            socketId: null == socketId
                ? _value.socketId
                : socketId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JoinGameSessionCommandImplCopyWith<$Res>
    implements $JoinGameSessionCommandCopyWith<$Res> {
  factory _$$JoinGameSessionCommandImplCopyWith(
    _$JoinGameSessionCommandImpl value,
    $Res Function(_$JoinGameSessionCommandImpl) then,
  ) = __$$JoinGameSessionCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomCode, String socketId});
}

/// @nodoc
class __$$JoinGameSessionCommandImplCopyWithImpl<$Res>
    extends
        _$JoinGameSessionCommandCopyWithImpl<$Res, _$JoinGameSessionCommandImpl>
    implements _$$JoinGameSessionCommandImplCopyWith<$Res> {
  __$$JoinGameSessionCommandImplCopyWithImpl(
    _$JoinGameSessionCommandImpl _value,
    $Res Function(_$JoinGameSessionCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JoinGameSessionCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomCode = null, Object? socketId = null}) {
    return _then(
      _$JoinGameSessionCommandImpl(
        roomCode: null == roomCode
            ? _value.roomCode
            : roomCode // ignore: cast_nullable_to_non_nullable
                  as String,
        socketId: null == socketId
            ? _value.socketId
            : socketId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$JoinGameSessionCommandImpl implements _JoinGameSessionCommand {
  const _$JoinGameSessionCommandImpl({
    required this.roomCode,
    required this.socketId,
  });

  @override
  final String roomCode;
  @override
  final String socketId;

  @override
  String toString() {
    return 'JoinGameSessionCommand(roomCode: $roomCode, socketId: $socketId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinGameSessionCommandImpl &&
            (identical(other.roomCode, roomCode) ||
                other.roomCode == roomCode) &&
            (identical(other.socketId, socketId) ||
                other.socketId == socketId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomCode, socketId);

  /// Create a copy of JoinGameSessionCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinGameSessionCommandImplCopyWith<_$JoinGameSessionCommandImpl>
  get copyWith =>
      __$$JoinGameSessionCommandImplCopyWithImpl<_$JoinGameSessionCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _JoinGameSessionCommand implements JoinGameSessionCommand {
  const factory _JoinGameSessionCommand({
    required final String roomCode,
    required final String socketId,
  }) = _$JoinGameSessionCommandImpl;

  @override
  String get roomCode;
  @override
  String get socketId;

  /// Create a copy of JoinGameSessionCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoinGameSessionCommandImplCopyWith<_$JoinGameSessionCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}
