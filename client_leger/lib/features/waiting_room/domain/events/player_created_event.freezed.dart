// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_created_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PlayerCreatedEvent {
  List<WaitingRoomPlayerModel> get players =>
      throw _privateConstructorUsedError;

  /// Create a copy of PlayerCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerCreatedEventCopyWith<PlayerCreatedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerCreatedEventCopyWith<$Res> {
  factory $PlayerCreatedEventCopyWith(
    PlayerCreatedEvent value,
    $Res Function(PlayerCreatedEvent) then,
  ) = _$PlayerCreatedEventCopyWithImpl<$Res, PlayerCreatedEvent>;
  @useResult
  $Res call({List<WaitingRoomPlayerModel> players});
}

/// @nodoc
class _$PlayerCreatedEventCopyWithImpl<$Res, $Val extends PlayerCreatedEvent>
    implements $PlayerCreatedEventCopyWith<$Res> {
  _$PlayerCreatedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? players = null}) {
    return _then(
      _value.copyWith(
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<WaitingRoomPlayerModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerCreatedEventImplCopyWith<$Res>
    implements $PlayerCreatedEventCopyWith<$Res> {
  factory _$$PlayerCreatedEventImplCopyWith(
    _$PlayerCreatedEventImpl value,
    $Res Function(_$PlayerCreatedEventImpl) then,
  ) = __$$PlayerCreatedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<WaitingRoomPlayerModel> players});
}

/// @nodoc
class __$$PlayerCreatedEventImplCopyWithImpl<$Res>
    extends _$PlayerCreatedEventCopyWithImpl<$Res, _$PlayerCreatedEventImpl>
    implements _$$PlayerCreatedEventImplCopyWith<$Res> {
  __$$PlayerCreatedEventImplCopyWithImpl(
    _$PlayerCreatedEventImpl _value,
    $Res Function(_$PlayerCreatedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? players = null}) {
    return _then(
      _$PlayerCreatedEventImpl(
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<WaitingRoomPlayerModel>,
      ),
    );
  }
}

/// @nodoc

class _$PlayerCreatedEventImpl implements _PlayerCreatedEvent {
  const _$PlayerCreatedEventImpl({
    required final List<WaitingRoomPlayerModel> players,
  }) : _players = players;

  final List<WaitingRoomPlayerModel> _players;
  @override
  List<WaitingRoomPlayerModel> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  String toString() {
    return 'PlayerCreatedEvent(players: $players)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerCreatedEventImpl &&
            const DeepCollectionEquality().equals(other._players, _players));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_players));

  /// Create a copy of PlayerCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerCreatedEventImplCopyWith<_$PlayerCreatedEventImpl> get copyWith =>
      __$$PlayerCreatedEventImplCopyWithImpl<_$PlayerCreatedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _PlayerCreatedEvent implements PlayerCreatedEvent {
  const factory _PlayerCreatedEvent({
    required final List<WaitingRoomPlayerModel> players,
  }) = _$PlayerCreatedEventImpl;

  @override
  List<WaitingRoomPlayerModel> get players;

  /// Create a copy of PlayerCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerCreatedEventImplCopyWith<_$PlayerCreatedEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
