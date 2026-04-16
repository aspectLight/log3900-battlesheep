// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_debug_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameDebugState {
  bool get isDebugMode => throw _privateConstructorUsedError;

  /// Create a copy of GameDebugState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameDebugStateCopyWith<GameDebugState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameDebugStateCopyWith<$Res> {
  factory $GameDebugStateCopyWith(
    GameDebugState value,
    $Res Function(GameDebugState) then,
  ) = _$GameDebugStateCopyWithImpl<$Res, GameDebugState>;
  @useResult
  $Res call({bool isDebugMode});
}

/// @nodoc
class _$GameDebugStateCopyWithImpl<$Res, $Val extends GameDebugState>
    implements $GameDebugStateCopyWith<$Res> {
  _$GameDebugStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameDebugState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isDebugMode = null}) {
    return _then(
      _value.copyWith(
            isDebugMode: null == isDebugMode
                ? _value.isDebugMode
                : isDebugMode // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameDebugStateImplCopyWith<$Res>
    implements $GameDebugStateCopyWith<$Res> {
  factory _$$GameDebugStateImplCopyWith(
    _$GameDebugStateImpl value,
    $Res Function(_$GameDebugStateImpl) then,
  ) = __$$GameDebugStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isDebugMode});
}

/// @nodoc
class __$$GameDebugStateImplCopyWithImpl<$Res>
    extends _$GameDebugStateCopyWithImpl<$Res, _$GameDebugStateImpl>
    implements _$$GameDebugStateImplCopyWith<$Res> {
  __$$GameDebugStateImplCopyWithImpl(
    _$GameDebugStateImpl _value,
    $Res Function(_$GameDebugStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameDebugState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isDebugMode = null}) {
    return _then(
      _$GameDebugStateImpl(
        isDebugMode: null == isDebugMode
            ? _value.isDebugMode
            : isDebugMode // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$GameDebugStateImpl implements _GameDebugState {
  const _$GameDebugStateImpl({required this.isDebugMode});

  @override
  final bool isDebugMode;

  @override
  String toString() {
    return 'GameDebugState(isDebugMode: $isDebugMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameDebugStateImpl &&
            (identical(other.isDebugMode, isDebugMode) ||
                other.isDebugMode == isDebugMode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isDebugMode);

  /// Create a copy of GameDebugState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameDebugStateImplCopyWith<_$GameDebugStateImpl> get copyWith =>
      __$$GameDebugStateImplCopyWithImpl<_$GameDebugStateImpl>(
        this,
        _$identity,
      );
}

abstract class _GameDebugState implements GameDebugState {
  const factory _GameDebugState({required final bool isDebugMode}) =
      _$GameDebugStateImpl;

  @override
  bool get isDebugMode;

  /// Create a copy of GameDebugState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameDebugStateImplCopyWith<_$GameDebugStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
