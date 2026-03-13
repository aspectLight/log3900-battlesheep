// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_waiting_room_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateWaitingRoomCommand {
  String get roomId => throw _privateConstructorUsedError;
  String get gameId => throw _privateConstructorUsedError;
  WaitingRoomPlayerModel get host => throw _privateConstructorUsedError;

  /// Create a copy of CreateWaitingRoomCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateWaitingRoomCommandCopyWith<CreateWaitingRoomCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateWaitingRoomCommandCopyWith<$Res> {
  factory $CreateWaitingRoomCommandCopyWith(
    CreateWaitingRoomCommand value,
    $Res Function(CreateWaitingRoomCommand) then,
  ) = _$CreateWaitingRoomCommandCopyWithImpl<$Res, CreateWaitingRoomCommand>;
  @useResult
  $Res call({String roomId, String gameId, WaitingRoomPlayerModel host});

  $WaitingRoomPlayerModelCopyWith<$Res> get host;
}

/// @nodoc
class _$CreateWaitingRoomCommandCopyWithImpl<
  $Res,
  $Val extends CreateWaitingRoomCommand
>
    implements $CreateWaitingRoomCommandCopyWith<$Res> {
  _$CreateWaitingRoomCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateWaitingRoomCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? gameId = null,
    Object? host = null,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            gameId: null == gameId
                ? _value.gameId
                : gameId // ignore: cast_nullable_to_non_nullable
                      as String,
            host: null == host
                ? _value.host
                : host // ignore: cast_nullable_to_non_nullable
                      as WaitingRoomPlayerModel,
          )
          as $Val,
    );
  }

  /// Create a copy of CreateWaitingRoomCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WaitingRoomPlayerModelCopyWith<$Res> get host {
    return $WaitingRoomPlayerModelCopyWith<$Res>(_value.host, (value) {
      return _then(_value.copyWith(host: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateWaitingRoomCommandImplCopyWith<$Res>
    implements $CreateWaitingRoomCommandCopyWith<$Res> {
  factory _$$CreateWaitingRoomCommandImplCopyWith(
    _$CreateWaitingRoomCommandImpl value,
    $Res Function(_$CreateWaitingRoomCommandImpl) then,
  ) = __$$CreateWaitingRoomCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, String gameId, WaitingRoomPlayerModel host});

  @override
  $WaitingRoomPlayerModelCopyWith<$Res> get host;
}

/// @nodoc
class __$$CreateWaitingRoomCommandImplCopyWithImpl<$Res>
    extends
        _$CreateWaitingRoomCommandCopyWithImpl<
          $Res,
          _$CreateWaitingRoomCommandImpl
        >
    implements _$$CreateWaitingRoomCommandImplCopyWith<$Res> {
  __$$CreateWaitingRoomCommandImplCopyWithImpl(
    _$CreateWaitingRoomCommandImpl _value,
    $Res Function(_$CreateWaitingRoomCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateWaitingRoomCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? gameId = null,
    Object? host = null,
  }) {
    return _then(
      _$CreateWaitingRoomCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String,
        host: null == host
            ? _value.host
            : host // ignore: cast_nullable_to_non_nullable
                  as WaitingRoomPlayerModel,
      ),
    );
  }
}

/// @nodoc

class _$CreateWaitingRoomCommandImpl implements _CreateWaitingRoomCommand {
  const _$CreateWaitingRoomCommandImpl({
    required this.roomId,
    required this.gameId,
    required this.host,
  });

  @override
  final String roomId;
  @override
  final String gameId;
  @override
  final WaitingRoomPlayerModel host;

  @override
  String toString() {
    return 'CreateWaitingRoomCommand(roomId: $roomId, gameId: $gameId, host: $host)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateWaitingRoomCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.host, host) || other.host == host));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, gameId, host);

  /// Create a copy of CreateWaitingRoomCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateWaitingRoomCommandImplCopyWith<_$CreateWaitingRoomCommandImpl>
  get copyWith =>
      __$$CreateWaitingRoomCommandImplCopyWithImpl<
        _$CreateWaitingRoomCommandImpl
      >(this, _$identity);
}

abstract class _CreateWaitingRoomCommand implements CreateWaitingRoomCommand {
  const factory _CreateWaitingRoomCommand({
    required final String roomId,
    required final String gameId,
    required final WaitingRoomPlayerModel host,
  }) = _$CreateWaitingRoomCommandImpl;

  @override
  String get roomId;
  @override
  String get gameId;
  @override
  WaitingRoomPlayerModel get host;

  /// Create a copy of CreateWaitingRoomCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateWaitingRoomCommandImplCopyWith<_$CreateWaitingRoomCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}
