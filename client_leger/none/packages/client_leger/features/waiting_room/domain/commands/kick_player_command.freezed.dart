// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kick_player_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$KickPlayerCommand {
  String get roomId => throw _privateConstructorUsedError;
  WaitingRoomPlayerModel get player => throw _privateConstructorUsedError;

  /// Create a copy of KickPlayerCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KickPlayerCommandCopyWith<KickPlayerCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KickPlayerCommandCopyWith<$Res> {
  factory $KickPlayerCommandCopyWith(
    KickPlayerCommand value,
    $Res Function(KickPlayerCommand) then,
  ) = _$KickPlayerCommandCopyWithImpl<$Res, KickPlayerCommand>;
  @useResult
  $Res call({String roomId, WaitingRoomPlayerModel player});

  $WaitingRoomPlayerModelCopyWith<$Res> get player;
}

/// @nodoc
class _$KickPlayerCommandCopyWithImpl<$Res, $Val extends KickPlayerCommand>
    implements $KickPlayerCommandCopyWith<$Res> {
  _$KickPlayerCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KickPlayerCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? player = null}) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            player: null == player
                ? _value.player
                : player // ignore: cast_nullable_to_non_nullable
                      as WaitingRoomPlayerModel,
          )
          as $Val,
    );
  }

  /// Create a copy of KickPlayerCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WaitingRoomPlayerModelCopyWith<$Res> get player {
    return $WaitingRoomPlayerModelCopyWith<$Res>(_value.player, (value) {
      return _then(_value.copyWith(player: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$KickPlayerCommandImplCopyWith<$Res>
    implements $KickPlayerCommandCopyWith<$Res> {
  factory _$$KickPlayerCommandImplCopyWith(
    _$KickPlayerCommandImpl value,
    $Res Function(_$KickPlayerCommandImpl) then,
  ) = __$$KickPlayerCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, WaitingRoomPlayerModel player});

  @override
  $WaitingRoomPlayerModelCopyWith<$Res> get player;
}

/// @nodoc
class __$$KickPlayerCommandImplCopyWithImpl<$Res>
    extends _$KickPlayerCommandCopyWithImpl<$Res, _$KickPlayerCommandImpl>
    implements _$$KickPlayerCommandImplCopyWith<$Res> {
  __$$KickPlayerCommandImplCopyWithImpl(
    _$KickPlayerCommandImpl _value,
    $Res Function(_$KickPlayerCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KickPlayerCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? player = null}) {
    return _then(
      _$KickPlayerCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        player: null == player
            ? _value.player
            : player // ignore: cast_nullable_to_non_nullable
                  as WaitingRoomPlayerModel,
      ),
    );
  }
}

/// @nodoc

class _$KickPlayerCommandImpl implements _KickPlayerCommand {
  const _$KickPlayerCommandImpl({required this.roomId, required this.player});

  @override
  final String roomId;
  @override
  final WaitingRoomPlayerModel player;

  @override
  String toString() {
    return 'KickPlayerCommand(roomId: $roomId, player: $player)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KickPlayerCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.player, player) || other.player == player));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, player);

  /// Create a copy of KickPlayerCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KickPlayerCommandImplCopyWith<_$KickPlayerCommandImpl> get copyWith =>
      __$$KickPlayerCommandImplCopyWithImpl<_$KickPlayerCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _KickPlayerCommand implements KickPlayerCommand {
  const factory _KickPlayerCommand({
    required final String roomId,
    required final WaitingRoomPlayerModel player,
  }) = _$KickPlayerCommandImpl;

  @override
  String get roomId;
  @override
  WaitingRoomPlayerModel get player;

  /// Create a copy of KickPlayerCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KickPlayerCommandImplCopyWith<_$KickPlayerCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
