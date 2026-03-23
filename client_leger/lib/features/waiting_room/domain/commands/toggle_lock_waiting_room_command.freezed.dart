// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'toggle_lock_waiting_room_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ToggleLockWaitingRoomCommand {
  String get roomId => throw _privateConstructorUsedError;

  /// Create a copy of ToggleLockWaitingRoomCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ToggleLockWaitingRoomCommandCopyWith<ToggleLockWaitingRoomCommand>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToggleLockWaitingRoomCommandCopyWith<$Res> {
  factory $ToggleLockWaitingRoomCommandCopyWith(
    ToggleLockWaitingRoomCommand value,
    $Res Function(ToggleLockWaitingRoomCommand) then,
  ) =
      _$ToggleLockWaitingRoomCommandCopyWithImpl<
        $Res,
        ToggleLockWaitingRoomCommand
      >;
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class _$ToggleLockWaitingRoomCommandCopyWithImpl<
  $Res,
  $Val extends ToggleLockWaitingRoomCommand
>
    implements $ToggleLockWaitingRoomCommandCopyWith<$Res> {
  _$ToggleLockWaitingRoomCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ToggleLockWaitingRoomCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ToggleLockWaitingRoomCommandImplCopyWith<$Res>
    implements $ToggleLockWaitingRoomCommandCopyWith<$Res> {
  factory _$$ToggleLockWaitingRoomCommandImplCopyWith(
    _$ToggleLockWaitingRoomCommandImpl value,
    $Res Function(_$ToggleLockWaitingRoomCommandImpl) then,
  ) = __$$ToggleLockWaitingRoomCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class __$$ToggleLockWaitingRoomCommandImplCopyWithImpl<$Res>
    extends
        _$ToggleLockWaitingRoomCommandCopyWithImpl<
          $Res,
          _$ToggleLockWaitingRoomCommandImpl
        >
    implements _$$ToggleLockWaitingRoomCommandImplCopyWith<$Res> {
  __$$ToggleLockWaitingRoomCommandImplCopyWithImpl(
    _$ToggleLockWaitingRoomCommandImpl _value,
    $Res Function(_$ToggleLockWaitingRoomCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ToggleLockWaitingRoomCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _$ToggleLockWaitingRoomCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ToggleLockWaitingRoomCommandImpl
    implements _ToggleLockWaitingRoomCommand {
  const _$ToggleLockWaitingRoomCommandImpl({required this.roomId});

  @override
  final String roomId;

  @override
  String toString() {
    return 'ToggleLockWaitingRoomCommand(roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToggleLockWaitingRoomCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId);

  /// Create a copy of ToggleLockWaitingRoomCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToggleLockWaitingRoomCommandImplCopyWith<
    _$ToggleLockWaitingRoomCommandImpl
  >
  get copyWith =>
      __$$ToggleLockWaitingRoomCommandImplCopyWithImpl<
        _$ToggleLockWaitingRoomCommandImpl
      >(this, _$identity);
}

abstract class _ToggleLockWaitingRoomCommand
    implements ToggleLockWaitingRoomCommand {
  const factory _ToggleLockWaitingRoomCommand({required final String roomId}) =
      _$ToggleLockWaitingRoomCommandImpl;

  @override
  String get roomId;

  /// Create a copy of ToggleLockWaitingRoomCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToggleLockWaitingRoomCommandImplCopyWith<
    _$ToggleLockWaitingRoomCommandImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
