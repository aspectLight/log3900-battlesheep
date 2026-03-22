// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameModelInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  GameMode get mode => throw _privateConstructorUsedError;
  int get boardSize => throw _privateConstructorUsedError;
  List<List<GameBoardPreviewCell>> get boardMatrix =>
      throw _privateConstructorUsedError;
  bool get isVisible => throw _privateConstructorUsedError;
  String get lastModified => throw _privateConstructorUsedError;

  /// Create a copy of GameModelInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameModelInfoCopyWith<GameModelInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameModelInfoCopyWith<$Res> {
  factory $GameModelInfoCopyWith(
    GameModelInfo value,
    $Res Function(GameModelInfo) then,
  ) = _$GameModelInfoCopyWithImpl<$Res, GameModelInfo>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    GameMode mode,
    int boardSize,
    List<List<GameBoardPreviewCell>> boardMatrix,
    bool isVisible,
    String lastModified,
  });
}

/// @nodoc
class _$GameModelInfoCopyWithImpl<$Res, $Val extends GameModelInfo>
    implements $GameModelInfoCopyWith<$Res> {
  _$GameModelInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameModelInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? mode = null,
    Object? boardSize = null,
    Object? boardMatrix = null,
    Object? isVisible = null,
    Object? lastModified = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            mode: null == mode
                ? _value.mode
                : mode // ignore: cast_nullable_to_non_nullable
                      as GameMode,
            boardSize: null == boardSize
                ? _value.boardSize
                : boardSize // ignore: cast_nullable_to_non_nullable
                      as int,
            boardMatrix: null == boardMatrix
                ? _value.boardMatrix
                : boardMatrix // ignore: cast_nullable_to_non_nullable
                      as List<List<GameBoardPreviewCell>>,
            isVisible: null == isVisible
                ? _value.isVisible
                : isVisible // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastModified: null == lastModified
                ? _value.lastModified
                : lastModified // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameModelInfoImplCopyWith<$Res>
    implements $GameModelInfoCopyWith<$Res> {
  factory _$$GameModelInfoImplCopyWith(
    _$GameModelInfoImpl value,
    $Res Function(_$GameModelInfoImpl) then,
  ) = __$$GameModelInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    GameMode mode,
    int boardSize,
    List<List<GameBoardPreviewCell>> boardMatrix,
    bool isVisible,
    String lastModified,
  });
}

/// @nodoc
class __$$GameModelInfoImplCopyWithImpl<$Res>
    extends _$GameModelInfoCopyWithImpl<$Res, _$GameModelInfoImpl>
    implements _$$GameModelInfoImplCopyWith<$Res> {
  __$$GameModelInfoImplCopyWithImpl(
    _$GameModelInfoImpl _value,
    $Res Function(_$GameModelInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameModelInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? mode = null,
    Object? boardSize = null,
    Object? boardMatrix = null,
    Object? isVisible = null,
    Object? lastModified = null,
  }) {
    return _then(
      _$GameModelInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        mode: null == mode
            ? _value.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as GameMode,
        boardSize: null == boardSize
            ? _value.boardSize
            : boardSize // ignore: cast_nullable_to_non_nullable
                  as int,
        boardMatrix: null == boardMatrix
            ? _value._boardMatrix
            : boardMatrix // ignore: cast_nullable_to_non_nullable
                  as List<List<GameBoardPreviewCell>>,
        isVisible: null == isVisible
            ? _value.isVisible
            : isVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastModified: null == lastModified
            ? _value.lastModified
            : lastModified // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GameModelInfoImpl implements _GameModelInfo {
  const _$GameModelInfoImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.mode,
    required this.boardSize,
    required final List<List<GameBoardPreviewCell>> boardMatrix,
    required this.isVisible,
    required this.lastModified,
  }) : _boardMatrix = boardMatrix;

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final GameMode mode;
  @override
  final int boardSize;
  final List<List<GameBoardPreviewCell>> _boardMatrix;
  @override
  List<List<GameBoardPreviewCell>> get boardMatrix {
    if (_boardMatrix is EqualUnmodifiableListView) return _boardMatrix;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_boardMatrix);
  }

  @override
  final bool isVisible;
  @override
  final String lastModified;

  @override
  String toString() {
    return 'GameModelInfo(id: $id, name: $name, description: $description, mode: $mode, boardSize: $boardSize, boardMatrix: $boardMatrix, isVisible: $isVisible, lastModified: $lastModified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameModelInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.boardSize, boardSize) ||
                other.boardSize == boardSize) &&
            const DeepCollectionEquality().equals(
              other._boardMatrix,
              _boardMatrix,
            ) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    mode,
    boardSize,
    const DeepCollectionEquality().hash(_boardMatrix),
    isVisible,
    lastModified,
  );

  /// Create a copy of GameModelInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameModelInfoImplCopyWith<_$GameModelInfoImpl> get copyWith =>
      __$$GameModelInfoImplCopyWithImpl<_$GameModelInfoImpl>(this, _$identity);
}

abstract class _GameModelInfo implements GameModelInfo {
  const factory _GameModelInfo({
    required final String id,
    required final String name,
    required final String description,
    required final GameMode mode,
    required final int boardSize,
    required final List<List<GameBoardPreviewCell>> boardMatrix,
    required final bool isVisible,
    required final String lastModified,
  }) = _$GameModelInfoImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  GameMode get mode;
  @override
  int get boardSize;
  @override
  List<List<GameBoardPreviewCell>> get boardMatrix;
  @override
  bool get isVisible;
  @override
  String get lastModified;

  /// Create a copy of GameModelInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameModelInfoImplCopyWith<_$GameModelInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
