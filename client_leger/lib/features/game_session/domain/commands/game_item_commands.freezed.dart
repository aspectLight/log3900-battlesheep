// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_item_commands.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ItemDroppedCommand {
  String get roomId => throw _privateConstructorUsedError;
  ItemDropSource get source => throw _privateConstructorUsedError;
  GameItem get item => throw _privateConstructorUsedError;
  GameBoardPosition get coords => throw _privateConstructorUsedError;

  /// Create a copy of ItemDroppedCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemDroppedCommandCopyWith<ItemDroppedCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemDroppedCommandCopyWith<$Res> {
  factory $ItemDroppedCommandCopyWith(
    ItemDroppedCommand value,
    $Res Function(ItemDroppedCommand) then,
  ) = _$ItemDroppedCommandCopyWithImpl<$Res, ItemDroppedCommand>;
  @useResult
  $Res call({
    String roomId,
    ItemDropSource source,
    GameItem item,
    GameBoardPosition coords,
  });

  $ItemDropSourceCopyWith<$Res> get source;
  $GameItemCopyWith<$Res> get item;
  $GameBoardPositionCopyWith<$Res> get coords;
}

/// @nodoc
class _$ItemDroppedCommandCopyWithImpl<$Res, $Val extends ItemDroppedCommand>
    implements $ItemDroppedCommandCopyWith<$Res> {
  _$ItemDroppedCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemDroppedCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? source = null,
    Object? item = null,
    Object? coords = null,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as ItemDropSource,
            item: null == item
                ? _value.item
                : item // ignore: cast_nullable_to_non_nullable
                      as GameItem,
            coords: null == coords
                ? _value.coords
                : coords // ignore: cast_nullable_to_non_nullable
                      as GameBoardPosition,
          )
          as $Val,
    );
  }

  /// Create a copy of ItemDroppedCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ItemDropSourceCopyWith<$Res> get source {
    return $ItemDropSourceCopyWith<$Res>(_value.source, (value) {
      return _then(_value.copyWith(source: value) as $Val);
    });
  }

  /// Create a copy of ItemDroppedCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameItemCopyWith<$Res> get item {
    return $GameItemCopyWith<$Res>(_value.item, (value) {
      return _then(_value.copyWith(item: value) as $Val);
    });
  }

  /// Create a copy of ItemDroppedCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameBoardPositionCopyWith<$Res> get coords {
    return $GameBoardPositionCopyWith<$Res>(_value.coords, (value) {
      return _then(_value.copyWith(coords: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ItemDroppedCommandImplCopyWith<$Res>
    implements $ItemDroppedCommandCopyWith<$Res> {
  factory _$$ItemDroppedCommandImplCopyWith(
    _$ItemDroppedCommandImpl value,
    $Res Function(_$ItemDroppedCommandImpl) then,
  ) = __$$ItemDroppedCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roomId,
    ItemDropSource source,
    GameItem item,
    GameBoardPosition coords,
  });

  @override
  $ItemDropSourceCopyWith<$Res> get source;
  @override
  $GameItemCopyWith<$Res> get item;
  @override
  $GameBoardPositionCopyWith<$Res> get coords;
}

/// @nodoc
class __$$ItemDroppedCommandImplCopyWithImpl<$Res>
    extends _$ItemDroppedCommandCopyWithImpl<$Res, _$ItemDroppedCommandImpl>
    implements _$$ItemDroppedCommandImplCopyWith<$Res> {
  __$$ItemDroppedCommandImplCopyWithImpl(
    _$ItemDroppedCommandImpl _value,
    $Res Function(_$ItemDroppedCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemDroppedCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? source = null,
    Object? item = null,
    Object? coords = null,
  }) {
    return _then(
      _$ItemDroppedCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as ItemDropSource,
        item: null == item
            ? _value.item
            : item // ignore: cast_nullable_to_non_nullable
                  as GameItem,
        coords: null == coords
            ? _value.coords
            : coords // ignore: cast_nullable_to_non_nullable
                  as GameBoardPosition,
      ),
    );
  }
}

/// @nodoc

class _$ItemDroppedCommandImpl implements _ItemDroppedCommand {
  const _$ItemDroppedCommandImpl({
    required this.roomId,
    required this.source,
    required this.item,
    required this.coords,
  });

  @override
  final String roomId;
  @override
  final ItemDropSource source;
  @override
  final GameItem item;
  @override
  final GameBoardPosition coords;

  @override
  String toString() {
    return 'ItemDroppedCommand(roomId: $roomId, source: $source, item: $item, coords: $coords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemDroppedCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.coords, coords) || other.coords == coords));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, source, item, coords);

  /// Create a copy of ItemDroppedCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemDroppedCommandImplCopyWith<_$ItemDroppedCommandImpl> get copyWith =>
      __$$ItemDroppedCommandImplCopyWithImpl<_$ItemDroppedCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _ItemDroppedCommand implements ItemDroppedCommand {
  const factory _ItemDroppedCommand({
    required final String roomId,
    required final ItemDropSource source,
    required final GameItem item,
    required final GameBoardPosition coords,
  }) = _$ItemDroppedCommandImpl;

  @override
  String get roomId;
  @override
  ItemDropSource get source;
  @override
  GameItem get item;
  @override
  GameBoardPosition get coords;

  /// Create a copy of ItemDroppedCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemDroppedCommandImplCopyWith<_$ItemDroppedCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ItemCollectedCommand {
  String get roomId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  GameItem get item => throw _privateConstructorUsedError;
  GameBoardPosition get position => throw _privateConstructorUsedError;

  /// Create a copy of ItemCollectedCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemCollectedCommandCopyWith<ItemCollectedCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemCollectedCommandCopyWith<$Res> {
  factory $ItemCollectedCommandCopyWith(
    ItemCollectedCommand value,
    $Res Function(ItemCollectedCommand) then,
  ) = _$ItemCollectedCommandCopyWithImpl<$Res, ItemCollectedCommand>;
  @useResult
  $Res call({
    String roomId,
    String playerId,
    GameItem item,
    GameBoardPosition position,
  });

  $GameItemCopyWith<$Res> get item;
  $GameBoardPositionCopyWith<$Res> get position;
}

/// @nodoc
class _$ItemCollectedCommandCopyWithImpl<
  $Res,
  $Val extends ItemCollectedCommand
>
    implements $ItemCollectedCommandCopyWith<$Res> {
  _$ItemCollectedCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemCollectedCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? item = null,
    Object? position = null,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            item: null == item
                ? _value.item
                : item // ignore: cast_nullable_to_non_nullable
                      as GameItem,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as GameBoardPosition,
          )
          as $Val,
    );
  }

  /// Create a copy of ItemCollectedCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameItemCopyWith<$Res> get item {
    return $GameItemCopyWith<$Res>(_value.item, (value) {
      return _then(_value.copyWith(item: value) as $Val);
    });
  }

  /// Create a copy of ItemCollectedCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameBoardPositionCopyWith<$Res> get position {
    return $GameBoardPositionCopyWith<$Res>(_value.position, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ItemCollectedCommandImplCopyWith<$Res>
    implements $ItemCollectedCommandCopyWith<$Res> {
  factory _$$ItemCollectedCommandImplCopyWith(
    _$ItemCollectedCommandImpl value,
    $Res Function(_$ItemCollectedCommandImpl) then,
  ) = __$$ItemCollectedCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roomId,
    String playerId,
    GameItem item,
    GameBoardPosition position,
  });

  @override
  $GameItemCopyWith<$Res> get item;
  @override
  $GameBoardPositionCopyWith<$Res> get position;
}

/// @nodoc
class __$$ItemCollectedCommandImplCopyWithImpl<$Res>
    extends _$ItemCollectedCommandCopyWithImpl<$Res, _$ItemCollectedCommandImpl>
    implements _$$ItemCollectedCommandImplCopyWith<$Res> {
  __$$ItemCollectedCommandImplCopyWithImpl(
    _$ItemCollectedCommandImpl _value,
    $Res Function(_$ItemCollectedCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemCollectedCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? item = null,
    Object? position = null,
  }) {
    return _then(
      _$ItemCollectedCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        item: null == item
            ? _value.item
            : item // ignore: cast_nullable_to_non_nullable
                  as GameItem,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as GameBoardPosition,
      ),
    );
  }
}

/// @nodoc

class _$ItemCollectedCommandImpl implements _ItemCollectedCommand {
  const _$ItemCollectedCommandImpl({
    required this.roomId,
    required this.playerId,
    required this.item,
    required this.position,
  });

  @override
  final String roomId;
  @override
  final String playerId;
  @override
  final GameItem item;
  @override
  final GameBoardPosition position;

  @override
  String toString() {
    return 'ItemCollectedCommand(roomId: $roomId, playerId: $playerId, item: $item, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemCollectedCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, roomId, playerId, item, position);

  /// Create a copy of ItemCollectedCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemCollectedCommandImplCopyWith<_$ItemCollectedCommandImpl>
  get copyWith =>
      __$$ItemCollectedCommandImplCopyWithImpl<_$ItemCollectedCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _ItemCollectedCommand implements ItemCollectedCommand {
  const factory _ItemCollectedCommand({
    required final String roomId,
    required final String playerId,
    required final GameItem item,
    required final GameBoardPosition position,
  }) = _$ItemCollectedCommandImpl;

  @override
  String get roomId;
  @override
  String get playerId;
  @override
  GameItem get item;
  @override
  GameBoardPosition get position;

  /// Create a copy of ItemCollectedCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemCollectedCommandImplCopyWith<_$ItemCollectedCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}
