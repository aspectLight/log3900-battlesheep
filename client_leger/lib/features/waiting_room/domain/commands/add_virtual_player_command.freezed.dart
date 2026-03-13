// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_virtual_player_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AddVirtualPlayerCommand {
  String get roomId => throw _privateConstructorUsedError;
  WaitingRoomPlayerModel get player => throw _privateConstructorUsedError;

  /// Create a copy of AddVirtualPlayerCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddVirtualPlayerCommandCopyWith<AddVirtualPlayerCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddVirtualPlayerCommandCopyWith<$Res> {
  factory $AddVirtualPlayerCommandCopyWith(
    AddVirtualPlayerCommand value,
    $Res Function(AddVirtualPlayerCommand) then,
  ) = _$AddVirtualPlayerCommandCopyWithImpl<$Res, AddVirtualPlayerCommand>;
  @useResult
  $Res call({String roomId, WaitingRoomPlayerModel player});

  $WaitingRoomPlayerModelCopyWith<$Res> get player;
}

/// @nodoc
class _$AddVirtualPlayerCommandCopyWithImpl<
  $Res,
  $Val extends AddVirtualPlayerCommand
>
    implements $AddVirtualPlayerCommandCopyWith<$Res> {
  _$AddVirtualPlayerCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddVirtualPlayerCommand
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

  /// Create a copy of AddVirtualPlayerCommand
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
abstract class _$$AddVirtualPlayerCommandImplCopyWith<$Res>
    implements $AddVirtualPlayerCommandCopyWith<$Res> {
  factory _$$AddVirtualPlayerCommandImplCopyWith(
    _$AddVirtualPlayerCommandImpl value,
    $Res Function(_$AddVirtualPlayerCommandImpl) then,
  ) = __$$AddVirtualPlayerCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, WaitingRoomPlayerModel player});

  @override
  $WaitingRoomPlayerModelCopyWith<$Res> get player;
}

/// @nodoc
class __$$AddVirtualPlayerCommandImplCopyWithImpl<$Res>
    extends
        _$AddVirtualPlayerCommandCopyWithImpl<
          $Res,
          _$AddVirtualPlayerCommandImpl
        >
    implements _$$AddVirtualPlayerCommandImplCopyWith<$Res> {
  __$$AddVirtualPlayerCommandImplCopyWithImpl(
    _$AddVirtualPlayerCommandImpl _value,
    $Res Function(_$AddVirtualPlayerCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddVirtualPlayerCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? player = null}) {
    return _then(
      _$AddVirtualPlayerCommandImpl(
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

class _$AddVirtualPlayerCommandImpl implements _AddVirtualPlayerCommand {
  const _$AddVirtualPlayerCommandImpl({
    required this.roomId,
    required this.player,
  });

  @override
  final String roomId;
  @override
  final WaitingRoomPlayerModel player;

  @override
  String toString() {
    return 'AddVirtualPlayerCommand(roomId: $roomId, player: $player)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddVirtualPlayerCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.player, player) || other.player == player));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, player);

  /// Create a copy of AddVirtualPlayerCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddVirtualPlayerCommandImplCopyWith<_$AddVirtualPlayerCommandImpl>
  get copyWith =>
      __$$AddVirtualPlayerCommandImplCopyWithImpl<
        _$AddVirtualPlayerCommandImpl
      >(this, _$identity);
}

abstract class _AddVirtualPlayerCommand implements AddVirtualPlayerCommand {
  const factory _AddVirtualPlayerCommand({
    required final String roomId,
    required final WaitingRoomPlayerModel player,
  }) = _$AddVirtualPlayerCommandImpl;

  @override
  String get roomId;
  @override
  WaitingRoomPlayerModel get player;

  /// Create a copy of AddVirtualPlayerCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddVirtualPlayerCommandImplCopyWith<_$AddVirtualPlayerCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}
