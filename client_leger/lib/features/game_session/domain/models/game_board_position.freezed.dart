// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_board_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameBoardPosition {
  int get x => throw _privateConstructorUsedError;
  int get y => throw _privateConstructorUsedError;

  /// Create a copy of GameBoardPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameBoardPositionCopyWith<GameBoardPosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameBoardPositionCopyWith<$Res> {
  factory $GameBoardPositionCopyWith(
    GameBoardPosition value,
    $Res Function(GameBoardPosition) then,
  ) = _$GameBoardPositionCopyWithImpl<$Res, GameBoardPosition>;
  @useResult
  $Res call({int x, int y});
}

/// @nodoc
class _$GameBoardPositionCopyWithImpl<$Res, $Val extends GameBoardPosition>
    implements $GameBoardPositionCopyWith<$Res> {
  _$GameBoardPositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameBoardPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? x = null, Object? y = null}) {
    return _then(
      _value.copyWith(
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
abstract class _$$GameBoardPositionImplCopyWith<$Res>
    implements $GameBoardPositionCopyWith<$Res> {
  factory _$$GameBoardPositionImplCopyWith(
    _$GameBoardPositionImpl value,
    $Res Function(_$GameBoardPositionImpl) then,
  ) = __$$GameBoardPositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int x, int y});
}

/// @nodoc
class __$$GameBoardPositionImplCopyWithImpl<$Res>
    extends _$GameBoardPositionCopyWithImpl<$Res, _$GameBoardPositionImpl>
    implements _$$GameBoardPositionImplCopyWith<$Res> {
  __$$GameBoardPositionImplCopyWithImpl(
    _$GameBoardPositionImpl _value,
    $Res Function(_$GameBoardPositionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameBoardPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? x = null, Object? y = null}) {
    return _then(
      _$GameBoardPositionImpl(
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

class _$GameBoardPositionImpl
    with DiagnosticableTreeMixin
    implements _GameBoardPosition {
  const _$GameBoardPositionImpl({required this.x, required this.y});

  @override
  final int x;
  @override
  final int y;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GameBoardPosition(x: $x, y: $y)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GameBoardPosition'))
      ..add(DiagnosticsProperty('x', x))
      ..add(DiagnosticsProperty('y', y));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameBoardPositionImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @override
  int get hashCode => Object.hash(runtimeType, x, y);

  /// Create a copy of GameBoardPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameBoardPositionImplCopyWith<_$GameBoardPositionImpl> get copyWith =>
      __$$GameBoardPositionImplCopyWithImpl<_$GameBoardPositionImpl>(
        this,
        _$identity,
      );
}

abstract class _GameBoardPosition implements GameBoardPosition {
  const factory _GameBoardPosition({
    required final int x,
    required final int y,
  }) = _$GameBoardPositionImpl;

  @override
  int get x;
  @override
  int get y;

  /// Create a copy of GameBoardPosition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameBoardPositionImplCopyWith<_$GameBoardPositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
