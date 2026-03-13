// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_updated_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RoomUpdatedEvent {
  WaitingRoomModel get room => throw _privateConstructorUsedError;

  /// Create a copy of RoomUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoomUpdatedEventCopyWith<RoomUpdatedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomUpdatedEventCopyWith<$Res> {
  factory $RoomUpdatedEventCopyWith(
    RoomUpdatedEvent value,
    $Res Function(RoomUpdatedEvent) then,
  ) = _$RoomUpdatedEventCopyWithImpl<$Res, RoomUpdatedEvent>;
  @useResult
  $Res call({WaitingRoomModel room});

  $WaitingRoomModelCopyWith<$Res> get room;
}

/// @nodoc
class _$RoomUpdatedEventCopyWithImpl<$Res, $Val extends RoomUpdatedEvent>
    implements $RoomUpdatedEventCopyWith<$Res> {
  _$RoomUpdatedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoomUpdatedEvent
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

  /// Create a copy of RoomUpdatedEvent
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
abstract class _$$RoomUpdatedEventImplCopyWith<$Res>
    implements $RoomUpdatedEventCopyWith<$Res> {
  factory _$$RoomUpdatedEventImplCopyWith(
    _$RoomUpdatedEventImpl value,
    $Res Function(_$RoomUpdatedEventImpl) then,
  ) = __$$RoomUpdatedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WaitingRoomModel room});

  @override
  $WaitingRoomModelCopyWith<$Res> get room;
}

/// @nodoc
class __$$RoomUpdatedEventImplCopyWithImpl<$Res>
    extends _$RoomUpdatedEventCopyWithImpl<$Res, _$RoomUpdatedEventImpl>
    implements _$$RoomUpdatedEventImplCopyWith<$Res> {
  __$$RoomUpdatedEventImplCopyWithImpl(
    _$RoomUpdatedEventImpl _value,
    $Res Function(_$RoomUpdatedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? room = null}) {
    return _then(
      _$RoomUpdatedEventImpl(
        room: null == room
            ? _value.room
            : room // ignore: cast_nullable_to_non_nullable
                  as WaitingRoomModel,
      ),
    );
  }
}

/// @nodoc

class _$RoomUpdatedEventImpl implements _RoomUpdatedEvent {
  const _$RoomUpdatedEventImpl({required this.room});

  @override
  final WaitingRoomModel room;

  @override
  String toString() {
    return 'RoomUpdatedEvent(room: $room)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomUpdatedEventImpl &&
            (identical(other.room, room) || other.room == room));
  }

  @override
  int get hashCode => Object.hash(runtimeType, room);

  /// Create a copy of RoomUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomUpdatedEventImplCopyWith<_$RoomUpdatedEventImpl> get copyWith =>
      __$$RoomUpdatedEventImplCopyWithImpl<_$RoomUpdatedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _RoomUpdatedEvent implements RoomUpdatedEvent {
  const factory _RoomUpdatedEvent({required final WaitingRoomModel room}) =
      _$RoomUpdatedEventImpl;

  @override
  WaitingRoomModel get room;

  /// Create a copy of RoomUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomUpdatedEventImplCopyWith<_$RoomUpdatedEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
