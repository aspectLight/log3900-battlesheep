// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waiting_room_room_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WaitingRoomRoomState {
  WaitingRoomModel get room => throw _privateConstructorUsedError;
  String get socketId => throw _privateConstructorUsedError;

  /// Create a copy of WaitingRoomRoomState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaitingRoomRoomStateCopyWith<WaitingRoomRoomState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaitingRoomRoomStateCopyWith<$Res> {
  factory $WaitingRoomRoomStateCopyWith(
    WaitingRoomRoomState value,
    $Res Function(WaitingRoomRoomState) then,
  ) = _$WaitingRoomRoomStateCopyWithImpl<$Res, WaitingRoomRoomState>;
  @useResult
  $Res call({WaitingRoomModel room, String socketId});

  $WaitingRoomModelCopyWith<$Res> get room;
}

/// @nodoc
class _$WaitingRoomRoomStateCopyWithImpl<
  $Res,
  $Val extends WaitingRoomRoomState
>
    implements $WaitingRoomRoomStateCopyWith<$Res> {
  _$WaitingRoomRoomStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaitingRoomRoomState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? room = null, Object? socketId = null}) {
    return _then(
      _value.copyWith(
            room: null == room
                ? _value.room
                : room // ignore: cast_nullable_to_non_nullable
                      as WaitingRoomModel,
            socketId: null == socketId
                ? _value.socketId
                : socketId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of WaitingRoomRoomState
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
abstract class _$$WaitingRoomRoomStateImplCopyWith<$Res>
    implements $WaitingRoomRoomStateCopyWith<$Res> {
  factory _$$WaitingRoomRoomStateImplCopyWith(
    _$WaitingRoomRoomStateImpl value,
    $Res Function(_$WaitingRoomRoomStateImpl) then,
  ) = __$$WaitingRoomRoomStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WaitingRoomModel room, String socketId});

  @override
  $WaitingRoomModelCopyWith<$Res> get room;
}

/// @nodoc
class __$$WaitingRoomRoomStateImplCopyWithImpl<$Res>
    extends _$WaitingRoomRoomStateCopyWithImpl<$Res, _$WaitingRoomRoomStateImpl>
    implements _$$WaitingRoomRoomStateImplCopyWith<$Res> {
  __$$WaitingRoomRoomStateImplCopyWithImpl(
    _$WaitingRoomRoomStateImpl _value,
    $Res Function(_$WaitingRoomRoomStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaitingRoomRoomState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? room = null, Object? socketId = null}) {
    return _then(
      _$WaitingRoomRoomStateImpl(
        room: null == room
            ? _value.room
            : room // ignore: cast_nullable_to_non_nullable
                  as WaitingRoomModel,
        socketId: null == socketId
            ? _value.socketId
            : socketId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$WaitingRoomRoomStateImpl implements _WaitingRoomRoomState {
  const _$WaitingRoomRoomStateImpl({
    required this.room,
    required this.socketId,
  });

  @override
  final WaitingRoomModel room;
  @override
  final String socketId;

  @override
  String toString() {
    return 'WaitingRoomRoomState(room: $room, socketId: $socketId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitingRoomRoomStateImpl &&
            (identical(other.room, room) || other.room == room) &&
            (identical(other.socketId, socketId) ||
                other.socketId == socketId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, room, socketId);

  /// Create a copy of WaitingRoomRoomState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitingRoomRoomStateImplCopyWith<_$WaitingRoomRoomStateImpl>
  get copyWith =>
      __$$WaitingRoomRoomStateImplCopyWithImpl<_$WaitingRoomRoomStateImpl>(
        this,
        _$identity,
      );
}

abstract class _WaitingRoomRoomState implements WaitingRoomRoomState {
  const factory _WaitingRoomRoomState({
    required final WaitingRoomModel room,
    required final String socketId,
  }) = _$WaitingRoomRoomStateImpl;

  @override
  WaitingRoomModel get room;
  @override
  String get socketId;

  /// Create a copy of WaitingRoomRoomState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaitingRoomRoomStateImplCopyWith<_$WaitingRoomRoomStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
