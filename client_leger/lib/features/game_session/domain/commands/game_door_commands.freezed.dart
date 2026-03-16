// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_door_commands.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ToggleDoorCommand {
  String get roomId => throw _privateConstructorUsedError;
  int get x => throw _privateConstructorUsedError;
  int get y => throw _privateConstructorUsedError;

  /// Create a copy of ToggleDoorCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ToggleDoorCommandCopyWith<ToggleDoorCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToggleDoorCommandCopyWith<$Res> {
  factory $ToggleDoorCommandCopyWith(
    ToggleDoorCommand value,
    $Res Function(ToggleDoorCommand) then,
  ) = _$ToggleDoorCommandCopyWithImpl<$Res, ToggleDoorCommand>;
  @useResult
  $Res call({String roomId, int x, int y});
}

/// @nodoc
class _$ToggleDoorCommandCopyWithImpl<$Res, $Val extends ToggleDoorCommand>
    implements $ToggleDoorCommandCopyWith<$Res> {
  _$ToggleDoorCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ToggleDoorCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? x = null, Object? y = null}) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            x: null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as int,
            y: null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ToggleDoorCommandImplCopyWith<$Res>
    implements $ToggleDoorCommandCopyWith<$Res> {
  factory _$$ToggleDoorCommandImplCopyWith(
    _$ToggleDoorCommandImpl value,
    $Res Function(_$ToggleDoorCommandImpl) then,
  ) = __$$ToggleDoorCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, int x, int y});
}

/// @nodoc
class __$$ToggleDoorCommandImplCopyWithImpl<$Res>
    extends _$ToggleDoorCommandCopyWithImpl<$Res, _$ToggleDoorCommandImpl>
    implements _$$ToggleDoorCommandImplCopyWith<$Res> {
  __$$ToggleDoorCommandImplCopyWithImpl(
    _$ToggleDoorCommandImpl _value,
    $Res Function(_$ToggleDoorCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ToggleDoorCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? x = null, Object? y = null}) {
    return _then(
      _$ToggleDoorCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        x: null == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as int,
        y: null == y
            ? _value.y
            : y // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$ToggleDoorCommandImpl implements _ToggleDoorCommand {
  const _$ToggleDoorCommandImpl({
    required this.roomId,
    required this.x,
    required this.y,
  });

  @override
  final String roomId;
  @override
  final int x;
  @override
  final int y;

  @override
  String toString() {
    return 'ToggleDoorCommand(roomId: $roomId, x: $x, y: $y)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToggleDoorCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, x, y);

  /// Create a copy of ToggleDoorCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToggleDoorCommandImplCopyWith<_$ToggleDoorCommandImpl> get copyWith =>
      __$$ToggleDoorCommandImplCopyWithImpl<_$ToggleDoorCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _ToggleDoorCommand implements ToggleDoorCommand {
  const factory _ToggleDoorCommand({
    required final String roomId,
    required final int x,
    required final int y,
  }) = _$ToggleDoorCommandImpl;

  @override
  String get roomId;
  @override
  int get x;
  @override
  int get y;

  /// Create a copy of ToggleDoorCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToggleDoorCommandImplCopyWith<_$ToggleDoorCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
