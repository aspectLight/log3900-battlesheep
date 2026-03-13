// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_left_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PlayerLeftEvent {
  String get playerId => throw _privateConstructorUsedError;

  /// Create a copy of PlayerLeftEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerLeftEventCopyWith<PlayerLeftEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerLeftEventCopyWith<$Res> {
  factory $PlayerLeftEventCopyWith(
    PlayerLeftEvent value,
    $Res Function(PlayerLeftEvent) then,
  ) = _$PlayerLeftEventCopyWithImpl<$Res, PlayerLeftEvent>;
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class _$PlayerLeftEventCopyWithImpl<$Res, $Val extends PlayerLeftEvent>
    implements $PlayerLeftEventCopyWith<$Res> {
  _$PlayerLeftEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerLeftEvent
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
abstract class _$$PlayerLeftEventImplCopyWith<$Res>
    implements $PlayerLeftEventCopyWith<$Res> {
  factory _$$PlayerLeftEventImplCopyWith(
    _$PlayerLeftEventImpl value,
    $Res Function(_$PlayerLeftEventImpl) then,
  ) = __$$PlayerLeftEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class __$$PlayerLeftEventImplCopyWithImpl<$Res>
    extends _$PlayerLeftEventCopyWithImpl<$Res, _$PlayerLeftEventImpl>
    implements _$$PlayerLeftEventImplCopyWith<$Res> {
  __$$PlayerLeftEventImplCopyWithImpl(
    _$PlayerLeftEventImpl _value,
    $Res Function(_$PlayerLeftEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerLeftEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null}) {
    return _then(
      _$PlayerLeftEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PlayerLeftEventImpl implements _PlayerLeftEvent {
  const _$PlayerLeftEventImpl({required this.playerId});

  @override
  final String playerId;

  @override
  String toString() {
    return 'PlayerLeftEvent(playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerLeftEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId);

  /// Create a copy of PlayerLeftEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerLeftEventImplCopyWith<_$PlayerLeftEventImpl> get copyWith =>
      __$$PlayerLeftEventImplCopyWithImpl<_$PlayerLeftEventImpl>(
        this,
        _$identity,
      );
}

abstract class _PlayerLeftEvent implements PlayerLeftEvent {
  const factory _PlayerLeftEvent({required final String playerId}) =
      _$PlayerLeftEventImpl;

  @override
  String get playerId;

  /// Create a copy of PlayerLeftEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerLeftEventImplCopyWith<_$PlayerLeftEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
