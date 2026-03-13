// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_created_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RoomCreatedEvent {
  WaitingRoomModel get room => throw _privateConstructorUsedError;

  /// Create a copy of RoomCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoomCreatedEventCopyWith<RoomCreatedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomCreatedEventCopyWith<$Res> {
  factory $RoomCreatedEventCopyWith(
    RoomCreatedEvent value,
    $Res Function(RoomCreatedEvent) then,
  ) = _$RoomCreatedEventCopyWithImpl<$Res, RoomCreatedEvent>;
  @useResult
  $Res call({WaitingRoomModel room});

  $WaitingRoomModelCopyWith<$Res> get room;
}

/// @nodoc
class _$RoomCreatedEventCopyWithImpl<$Res, $Val extends RoomCreatedEvent>
    implements $RoomCreatedEventCopyWith<$Res> {
  _$RoomCreatedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoomCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? room = null}) {
    return _then(
      _value.copyWith(
            room: null == room
                ? _value.room
                : room // ignore: cast_nullable_to_non_nullable
                      as WaitingRoomModel,
          )
          as $Val,
    );
  }

  /// Create a copy of RoomCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WaitingRoomModelCopyWith<$Res> get room {
    return $WaitingRoomModelCopyWith<$Res>(_value.room, (value) {
      return _then(_value.copyWith(room: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoomCreatedEventImplCopyWith<$Res>
    implements $RoomCreatedEventCopyWith<$Res> {
  factory _$$RoomCreatedEventImplCopyWith(
    _$RoomCreatedEventImpl value,
    $Res Function(_$RoomCreatedEventImpl) then,
  ) = __$$RoomCreatedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WaitingRoomModel room});

  @override
  $WaitingRoomModelCopyWith<$Res> get room;
}

/// @nodoc
class __$$RoomCreatedEventImplCopyWithImpl<$Res>
    extends _$RoomCreatedEventCopyWithImpl<$Res, _$RoomCreatedEventImpl>
    implements _$$RoomCreatedEventImplCopyWith<$Res> {
  __$$RoomCreatedEventImplCopyWithImpl(
    _$RoomCreatedEventImpl _value,
    $Res Function(_$RoomCreatedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? room = null}) {
    return _then(
      _$RoomCreatedEventImpl(
        room: null == room
            ? _value.room
            : room // ignore: cast_nullable_to_non_nullable
                  as WaitingRoomModel,
      ),
    );
  }
}

/// @nodoc

class _$RoomCreatedEventImpl implements _RoomCreatedEvent {
  const _$RoomCreatedEventImpl({required this.room});

  @override
  final WaitingRoomModel room;

  @override
  String toString() {
    return 'RoomCreatedEvent(room: $room)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomCreatedEventImpl &&
            (identical(other.room, room) || other.room == room));
  }

  @override
  int get hashCode => Object.hash(runtimeType, room);

  /// Create a copy of RoomCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomCreatedEventImplCopyWith<_$RoomCreatedEventImpl> get copyWith =>
      __$$RoomCreatedEventImplCopyWithImpl<_$RoomCreatedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _RoomCreatedEvent implements RoomCreatedEvent {
  const factory _RoomCreatedEvent({required final WaitingRoomModel room}) =
      _$RoomCreatedEventImpl;

  @override
  WaitingRoomModel get room;

  /// Create a copy of RoomCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomCreatedEventImplCopyWith<_$RoomCreatedEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
