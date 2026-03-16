// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameItem {
  ItemType get type => throw _privateConstructorUsedError;

  /// Create a copy of GameItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameItemCopyWith<GameItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameItemCopyWith<$Res> {
  factory $GameItemCopyWith(GameItem value, $Res Function(GameItem) then) =
      _$GameItemCopyWithImpl<$Res, GameItem>;
  @useResult
  $Res call({ItemType type});
}

/// @nodoc
class _$GameItemCopyWithImpl<$Res, $Val extends GameItem>
    implements $GameItemCopyWith<$Res> {
  _$GameItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null}) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ItemType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameItemImplCopyWith<$Res>
    implements $GameItemCopyWith<$Res> {
  factory _$$GameItemImplCopyWith(
    _$GameItemImpl value,
    $Res Function(_$GameItemImpl) then,
  ) = __$$GameItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ItemType type});
}

/// @nodoc
class __$$GameItemImplCopyWithImpl<$Res>
    extends _$GameItemCopyWithImpl<$Res, _$GameItemImpl>
    implements _$$GameItemImplCopyWith<$Res> {
  __$$GameItemImplCopyWithImpl(
    _$GameItemImpl _value,
    $Res Function(_$GameItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null}) {
    return _then(
      _$GameItemImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ItemType,
      ),
    );
  }
}

/// @nodoc

class _$GameItemImpl implements _GameItem {
  const _$GameItemImpl({required this.type});

  @override
  final ItemType type;

  @override
  String toString() {
    return 'GameItem(type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameItemImpl &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type);

  /// Create a copy of GameItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameItemImplCopyWith<_$GameItemImpl> get copyWith =>
      __$$GameItemImplCopyWithImpl<_$GameItemImpl>(this, _$identity);
}

abstract class _GameItem implements GameItem {
  const factory _GameItem({required final ItemType type}) = _$GameItemImpl;

  @override
  ItemType get type;

  /// Create a copy of GameItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameItemImplCopyWith<_$GameItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ItemDropSource {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String playerId) player,
    required TResult Function() disconnected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String playerId)? player,
    TResult? Function()? disconnected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String playerId)? player,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerItemDropSource value) player,
    required TResult Function(DisconnectedItemDropSource value) disconnected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerItemDropSource value)? player,
    TResult? Function(DisconnectedItemDropSource value)? disconnected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerItemDropSource value)? player,
    TResult Function(DisconnectedItemDropSource value)? disconnected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemDropSourceCopyWith<$Res> {
  factory $ItemDropSourceCopyWith(
    ItemDropSource value,
    $Res Function(ItemDropSource) then,
  ) = _$ItemDropSourceCopyWithImpl<$Res, ItemDropSource>;
}

/// @nodoc
class _$ItemDropSourceCopyWithImpl<$Res, $Val extends ItemDropSource>
    implements $ItemDropSourceCopyWith<$Res> {
  _$ItemDropSourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemDropSource
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PlayerItemDropSourceImplCopyWith<$Res> {
  factory _$$PlayerItemDropSourceImplCopyWith(
    _$PlayerItemDropSourceImpl value,
    $Res Function(_$PlayerItemDropSourceImpl) then,
  ) = __$$PlayerItemDropSourceImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class __$$PlayerItemDropSourceImplCopyWithImpl<$Res>
    extends _$ItemDropSourceCopyWithImpl<$Res, _$PlayerItemDropSourceImpl>
    implements _$$PlayerItemDropSourceImplCopyWith<$Res> {
  __$$PlayerItemDropSourceImplCopyWithImpl(
    _$PlayerItemDropSourceImpl _value,
    $Res Function(_$PlayerItemDropSourceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemDropSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null}) {
    return _then(
      _$PlayerItemDropSourceImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PlayerItemDropSourceImpl implements PlayerItemDropSource {
  const _$PlayerItemDropSourceImpl({required this.playerId});

  @override
  final String playerId;

  @override
  String toString() {
    return 'ItemDropSource.player(playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerItemDropSourceImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId);

  /// Create a copy of ItemDropSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerItemDropSourceImplCopyWith<_$PlayerItemDropSourceImpl>
  get copyWith =>
      __$$PlayerItemDropSourceImplCopyWithImpl<_$PlayerItemDropSourceImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String playerId) player,
    required TResult Function() disconnected,
  }) {
    return player(playerId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String playerId)? player,
    TResult? Function()? disconnected,
  }) {
    return player?.call(playerId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String playerId)? player,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) {
    if (player != null) {
      return player(playerId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerItemDropSource value) player,
    required TResult Function(DisconnectedItemDropSource value) disconnected,
  }) {
    return player(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerItemDropSource value)? player,
    TResult? Function(DisconnectedItemDropSource value)? disconnected,
  }) {
    return player?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerItemDropSource value)? player,
    TResult Function(DisconnectedItemDropSource value)? disconnected,
    required TResult orElse(),
  }) {
    if (player != null) {
      return player(this);
    }
    return orElse();
  }
}

abstract class PlayerItemDropSource implements ItemDropSource {
  const factory PlayerItemDropSource({required final String playerId}) =
      _$PlayerItemDropSourceImpl;

  String get playerId;

  /// Create a copy of ItemDropSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerItemDropSourceImplCopyWith<_$PlayerItemDropSourceImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DisconnectedItemDropSourceImplCopyWith<$Res> {
  factory _$$DisconnectedItemDropSourceImplCopyWith(
    _$DisconnectedItemDropSourceImpl value,
    $Res Function(_$DisconnectedItemDropSourceImpl) then,
  ) = __$$DisconnectedItemDropSourceImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DisconnectedItemDropSourceImplCopyWithImpl<$Res>
    extends _$ItemDropSourceCopyWithImpl<$Res, _$DisconnectedItemDropSourceImpl>
    implements _$$DisconnectedItemDropSourceImplCopyWith<$Res> {
  __$$DisconnectedItemDropSourceImplCopyWithImpl(
    _$DisconnectedItemDropSourceImpl _value,
    $Res Function(_$DisconnectedItemDropSourceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemDropSource
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DisconnectedItemDropSourceImpl implements DisconnectedItemDropSource {
  const _$DisconnectedItemDropSourceImpl();

  @override
  String toString() {
    return 'ItemDropSource.disconnected()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DisconnectedItemDropSourceImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String playerId) player,
    required TResult Function() disconnected,
  }) {
    return disconnected();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String playerId)? player,
    TResult? Function()? disconnected,
  }) {
    return disconnected?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String playerId)? player,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerItemDropSource value) player,
    required TResult Function(DisconnectedItemDropSource value) disconnected,
  }) {
    return disconnected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerItemDropSource value)? player,
    TResult? Function(DisconnectedItemDropSource value)? disconnected,
  }) {
    return disconnected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerItemDropSource value)? player,
    TResult Function(DisconnectedItemDropSource value)? disconnected,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected(this);
    }
    return orElse();
  }
}

abstract class DisconnectedItemDropSource implements ItemDropSource {
  const factory DisconnectedItemDropSource() = _$DisconnectedItemDropSourceImpl;
}

/// @nodoc
mixin _$PendingItemPickup {
  String get playerId => throw _privateConstructorUsedError;
  GameItem get item => throw _privateConstructorUsedError;
  GameBoardPosition get cellCoords => throw _privateConstructorUsedError;

  /// Create a copy of PendingItemPickup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PendingItemPickupCopyWith<PendingItemPickup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PendingItemPickupCopyWith<$Res> {
  factory $PendingItemPickupCopyWith(
    PendingItemPickup value,
    $Res Function(PendingItemPickup) then,
  ) = _$PendingItemPickupCopyWithImpl<$Res, PendingItemPickup>;
  @useResult
  $Res call({String playerId, GameItem item, GameBoardPosition cellCoords});

  $GameItemCopyWith<$Res> get item;
  $GameBoardPositionCopyWith<$Res> get cellCoords;
}

/// @nodoc
class _$PendingItemPickupCopyWithImpl<$Res, $Val extends PendingItemPickup>
    implements $PendingItemPickupCopyWith<$Res> {
  _$PendingItemPickupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PendingItemPickup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? item = null,
    Object? cellCoords = null,
  }) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            item: null == item
                ? _value.item
                : item // ignore: cast_nullable_to_non_nullable
                      as GameItem,
            cellCoords: null == cellCoords
                ? _value.cellCoords
                : cellCoords // ignore: cast_nullable_to_non_nullable
                      as GameBoardPosition,
          )
          as $Val,
    );
  }

  /// Create a copy of PendingItemPickup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameItemCopyWith<$Res> get item {
    return $GameItemCopyWith<$Res>(_value.item, (value) {
      return _then(_value.copyWith(item: value) as $Val);
    });
  }

  /// Create a copy of PendingItemPickup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameBoardPositionCopyWith<$Res> get cellCoords {
    return $GameBoardPositionCopyWith<$Res>(_value.cellCoords, (value) {
      return _then(_value.copyWith(cellCoords: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PendingItemPickupImplCopyWith<$Res>
    implements $PendingItemPickupCopyWith<$Res> {
  factory _$$PendingItemPickupImplCopyWith(
    _$PendingItemPickupImpl value,
    $Res Function(_$PendingItemPickupImpl) then,
  ) = __$$PendingItemPickupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId, GameItem item, GameBoardPosition cellCoords});

  @override
  $GameItemCopyWith<$Res> get item;
  @override
  $GameBoardPositionCopyWith<$Res> get cellCoords;
}

/// @nodoc
class __$$PendingItemPickupImplCopyWithImpl<$Res>
    extends _$PendingItemPickupCopyWithImpl<$Res, _$PendingItemPickupImpl>
    implements _$$PendingItemPickupImplCopyWith<$Res> {
  __$$PendingItemPickupImplCopyWithImpl(
    _$PendingItemPickupImpl _value,
    $Res Function(_$PendingItemPickupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PendingItemPickup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? item = null,
    Object? cellCoords = null,
  }) {
    return _then(
      _$PendingItemPickupImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        item: null == item
            ? _value.item
            : item // ignore: cast_nullable_to_non_nullable
                  as GameItem,
        cellCoords: null == cellCoords
            ? _value.cellCoords
            : cellCoords // ignore: cast_nullable_to_non_nullable
                  as GameBoardPosition,
      ),
    );
  }
}

/// @nodoc

class _$PendingItemPickupImpl implements _PendingItemPickup {
  const _$PendingItemPickupImpl({
    required this.playerId,
    required this.item,
    required this.cellCoords,
  });

  @override
  final String playerId;
  @override
  final GameItem item;
  @override
  final GameBoardPosition cellCoords;

  @override
  String toString() {
    return 'PendingItemPickup(playerId: $playerId, item: $item, cellCoords: $cellCoords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingItemPickupImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.cellCoords, cellCoords) ||
                other.cellCoords == cellCoords));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId, item, cellCoords);

  /// Create a copy of PendingItemPickup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingItemPickupImplCopyWith<_$PendingItemPickupImpl> get copyWith =>
      __$$PendingItemPickupImplCopyWithImpl<_$PendingItemPickupImpl>(
        this,
        _$identity,
      );
}

abstract class _PendingItemPickup implements PendingItemPickup {
  const factory _PendingItemPickup({
    required final String playerId,
    required final GameItem item,
    required final GameBoardPosition cellCoords,
  }) = _$PendingItemPickupImpl;

  @override
  String get playerId;
  @override
  GameItem get item;
  @override
  GameBoardPosition get cellCoords;

  /// Create a copy of PendingItemPickup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingItemPickupImplCopyWith<_$PendingItemPickupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
