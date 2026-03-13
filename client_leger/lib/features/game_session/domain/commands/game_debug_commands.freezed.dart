// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_debug_commands.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ToggleDebugModeCommand {
  String get roomId => throw _privateConstructorUsedError;

  /// Create a copy of ToggleDebugModeCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ToggleDebugModeCommandCopyWith<ToggleDebugModeCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToggleDebugModeCommandCopyWith<$Res> {
  factory $ToggleDebugModeCommandCopyWith(
    ToggleDebugModeCommand value,
    $Res Function(ToggleDebugModeCommand) then,
  ) = _$ToggleDebugModeCommandCopyWithImpl<$Res, ToggleDebugModeCommand>;
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class _$ToggleDebugModeCommandCopyWithImpl<
  $Res,
  $Val extends ToggleDebugModeCommand
>
    implements $ToggleDebugModeCommandCopyWith<$Res> {
  _$ToggleDebugModeCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ToggleDebugModeCommand
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
abstract class _$$ToggleDebugModeCommandImplCopyWith<$Res>
    implements $ToggleDebugModeCommandCopyWith<$Res> {
  factory _$$ToggleDebugModeCommandImplCopyWith(
    _$ToggleDebugModeCommandImpl value,
    $Res Function(_$ToggleDebugModeCommandImpl) then,
  ) = __$$ToggleDebugModeCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class __$$ToggleDebugModeCommandImplCopyWithImpl<$Res>
    extends
        _$ToggleDebugModeCommandCopyWithImpl<$Res, _$ToggleDebugModeCommandImpl>
    implements _$$ToggleDebugModeCommandImplCopyWith<$Res> {
  __$$ToggleDebugModeCommandImplCopyWithImpl(
    _$ToggleDebugModeCommandImpl _value,
    $Res Function(_$ToggleDebugModeCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ToggleDebugModeCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _$ToggleDebugModeCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ToggleDebugModeCommandImpl implements _ToggleDebugModeCommand {
  const _$ToggleDebugModeCommandImpl({required this.roomId});

  @override
  final String roomId;

  @override
  String toString() {
    return 'ToggleDebugModeCommand(roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToggleDebugModeCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId);

  /// Create a copy of ToggleDebugModeCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToggleDebugModeCommandImplCopyWith<_$ToggleDebugModeCommandImpl>
  get copyWith =>
      __$$ToggleDebugModeCommandImplCopyWithImpl<_$ToggleDebugModeCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _ToggleDebugModeCommand implements ToggleDebugModeCommand {
  const factory _ToggleDebugModeCommand({required final String roomId}) =
      _$ToggleDebugModeCommandImpl;

  @override
  String get roomId;

  /// Create a copy of ToggleDebugModeCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToggleDebugModeCommandImplCopyWith<_$ToggleDebugModeCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}
