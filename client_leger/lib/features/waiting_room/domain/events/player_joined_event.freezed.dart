// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_joined_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PlayerJoinedEvent {
  WaitingRoomPlayerModel get player => throw _privateConstructorUsedError;

  /// Create a copy of PlayerJoinedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerJoinedEventCopyWith<PlayerJoinedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerJoinedEventCopyWith<$Res> {
  factory $PlayerJoinedEventCopyWith(
    PlayerJoinedEvent value,
    $Res Function(PlayerJoinedEvent) then,
  ) = _$PlayerJoinedEventCopyWithImpl<$Res, PlayerJoinedEvent>;
  @useResult
  $Res call({WaitingRoomPlayerModel player});

  $WaitingRoomPlayerModelCopyWith<$Res> get player;
}

/// @nodoc
class _$PlayerJoinedEventCopyWithImpl<$Res, $Val extends PlayerJoinedEvent>
    implements $PlayerJoinedEventCopyWith<$Res> {
  _$PlayerJoinedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerJoinedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? player = null}) {
    return _then(
      _value.copyWith(
            player: null == player
                ? _value.player
                : player // ignore: cast_nullable_to_non_nullable
                      as WaitingRoomPlayerModel,
          )
          as $Val,
    );
  }

  /// Create a copy of PlayerJoinedEvent
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
abstract class _$$PlayerJoinedEventImplCopyWith<$Res>
    implements $PlayerJoinedEventCopyWith<$Res> {
  factory _$$PlayerJoinedEventImplCopyWith(
    _$PlayerJoinedEventImpl value,
    $Res Function(_$PlayerJoinedEventImpl) then,
  ) = __$$PlayerJoinedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WaitingRoomPlayerModel player});

  @override
  $WaitingRoomPlayerModelCopyWith<$Res> get player;
}

/// @nodoc
class __$$PlayerJoinedEventImplCopyWithImpl<$Res>
    extends _$PlayerJoinedEventCopyWithImpl<$Res, _$PlayerJoinedEventImpl>
    implements _$$PlayerJoinedEventImplCopyWith<$Res> {
  __$$PlayerJoinedEventImplCopyWithImpl(
    _$PlayerJoinedEventImpl _value,
    $Res Function(_$PlayerJoinedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerJoinedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? player = null}) {
    return _then(
      _$PlayerJoinedEventImpl(
        player: null == player
            ? _value.player
            : player // ignore: cast_nullable_to_non_nullable
                  as WaitingRoomPlayerModel,
      ),
    );
  }
}

/// @nodoc

class _$PlayerJoinedEventImpl implements _PlayerJoinedEvent {
  const _$PlayerJoinedEventImpl({required this.player});

  @override
  final WaitingRoomPlayerModel player;

  @override
  String toString() {
    return 'PlayerJoinedEvent(player: $player)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerJoinedEventImpl &&
            (identical(other.player, player) || other.player == player));
  }

  @override
  int get hashCode => Object.hash(runtimeType, player);

  /// Create a copy of PlayerJoinedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerJoinedEventImplCopyWith<_$PlayerJoinedEventImpl> get copyWith =>
      __$$PlayerJoinedEventImplCopyWithImpl<_$PlayerJoinedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _PlayerJoinedEvent implements PlayerJoinedEvent {
  const factory _PlayerJoinedEvent({
    required final WaitingRoomPlayerModel player,
  }) = _$PlayerJoinedEventImpl;

  @override
  WaitingRoomPlayerModel get player;

  /// Create a copy of PlayerJoinedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerJoinedEventImplCopyWith<_$PlayerJoinedEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
