// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_item_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ItemDroppedEvent {
  String get roomId => throw _privateConstructorUsedError;
  String? get playerId => throw _privateConstructorUsedError;
  GameItem get item => throw _privateConstructorUsedError;
  GameBoardPosition get coords => throw _privateConstructorUsedError;

  /// Create a copy of ItemDroppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemDroppedEventCopyWith<ItemDroppedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemDroppedEventCopyWith<$Res> {
  factory $ItemDroppedEventCopyWith(
    ItemDroppedEvent value,
    $Res Function(ItemDroppedEvent) then,
  ) = _$ItemDroppedEventCopyWithImpl<$Res, ItemDroppedEvent>;
  @useResult
  $Res call({
    String roomId,
    String? playerId,
    GameItem item,
    GameBoardPosition coords,
  });

  $GameItemCopyWith<$Res> get item;
  $GameBoardPositionCopyWith<$Res> get coords;
}

/// @nodoc
class _$ItemDroppedEventCopyWithImpl<$Res, $Val extends ItemDroppedEvent>
    implements $ItemDroppedEventCopyWith<$Res> {
  _$ItemDroppedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemDroppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = freezed,
    Object? item = null,
    Object? coords = null,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerId: freezed == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String?,
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

  /// Create a copy of ItemDroppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameItemCopyWith<$Res> get item {
    return $GameItemCopyWith<$Res>(_value.item, (value) {
      return _then(_value.copyWith(item: value) as $Val);
    });
  }

  /// Create a copy of ItemDroppedEvent
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
abstract class _$$ItemDroppedEventImplCopyWith<$Res>
    implements $ItemDroppedEventCopyWith<$Res> {
  factory _$$ItemDroppedEventImplCopyWith(
    _$ItemDroppedEventImpl value,
    $Res Function(_$ItemDroppedEventImpl) then,
  ) = __$$ItemDroppedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roomId,
    String? playerId,
    GameItem item,
    GameBoardPosition coords,
  });

  @override
  $GameItemCopyWith<$Res> get item;
  @override
  $GameBoardPositionCopyWith<$Res> get coords;
}

/// @nodoc
class __$$ItemDroppedEventImplCopyWithImpl<$Res>
    extends _$ItemDroppedEventCopyWithImpl<$Res, _$ItemDroppedEventImpl>
    implements _$$ItemDroppedEventImplCopyWith<$Res> {
  __$$ItemDroppedEventImplCopyWithImpl(
    _$ItemDroppedEventImpl _value,
    $Res Function(_$ItemDroppedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemDroppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = freezed,
    Object? item = null,
    Object? coords = null,
  }) {
    return _then(
      _$ItemDroppedEventImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: freezed == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String?,
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

class _$ItemDroppedEventImpl implements _ItemDroppedEvent {
  const _$ItemDroppedEventImpl({
    required this.roomId,
    required this.playerId,
    required this.item,
    required this.coords,
  });

  @override
  final String roomId;
  @override
  final String? playerId;
  @override
  final GameItem item;
  @override
  final GameBoardPosition coords;

  @override
  String toString() {
    return 'ItemDroppedEvent(roomId: $roomId, playerId: $playerId, item: $item, coords: $coords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemDroppedEventImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.coords, coords) || other.coords == coords));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, playerId, item, coords);

  /// Create a copy of ItemDroppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemDroppedEventImplCopyWith<_$ItemDroppedEventImpl> get copyWith =>
      __$$ItemDroppedEventImplCopyWithImpl<_$ItemDroppedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _ItemDroppedEvent implements ItemDroppedEvent {
  const factory _ItemDroppedEvent({
    required final String roomId,
    required final String? playerId,
    required final GameItem item,
    required final GameBoardPosition coords,
  }) = _$ItemDroppedEventImpl;

  @override
  String get roomId;
  @override
  String? get playerId;
  @override
  GameItem get item;
  @override
  GameBoardPosition get coords;

  /// Create a copy of ItemDroppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemDroppedEventImplCopyWith<_$ItemDroppedEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ItemDroppedDisconnectedEvent {
  List<GameItem> get items => throw _privateConstructorUsedError;
  GameBoardPosition get coords => throw _privateConstructorUsedError;
  String get roomId => throw _privateConstructorUsedError;

  /// Create a copy of ItemDroppedDisconnectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemDroppedDisconnectedEventCopyWith<ItemDroppedDisconnectedEvent>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemDroppedDisconnectedEventCopyWith<$Res> {
  factory $ItemDroppedDisconnectedEventCopyWith(
    ItemDroppedDisconnectedEvent value,
    $Res Function(ItemDroppedDisconnectedEvent) then,
  ) =
      _$ItemDroppedDisconnectedEventCopyWithImpl<
        $Res,
        ItemDroppedDisconnectedEvent
      >;
  @useResult
  $Res call({List<GameItem> items, GameBoardPosition coords, String roomId});

  $GameBoardPositionCopyWith<$Res> get coords;
}

/// @nodoc
class _$ItemDroppedDisconnectedEventCopyWithImpl<
  $Res,
  $Val extends ItemDroppedDisconnectedEvent
>
    implements $ItemDroppedDisconnectedEventCopyWith<$Res> {
  _$ItemDroppedDisconnectedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemDroppedDisconnectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? coords = null,
    Object? roomId = null,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<GameItem>,
            coords: null == coords
                ? _value.coords
                : coords // ignore: cast_nullable_to_non_nullable
                      as GameBoardPosition,
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of ItemDroppedDisconnectedEvent
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
abstract class _$$ItemDroppedDisconnectedEventImplCopyWith<$Res>
    implements $ItemDroppedDisconnectedEventCopyWith<$Res> {
  factory _$$ItemDroppedDisconnectedEventImplCopyWith(
    _$ItemDroppedDisconnectedEventImpl value,
    $Res Function(_$ItemDroppedDisconnectedEventImpl) then,
  ) = __$$ItemDroppedDisconnectedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<GameItem> items, GameBoardPosition coords, String roomId});

  @override
  $GameBoardPositionCopyWith<$Res> get coords;
}

/// @nodoc
class __$$ItemDroppedDisconnectedEventImplCopyWithImpl<$Res>
    extends
        _$ItemDroppedDisconnectedEventCopyWithImpl<
          $Res,
          _$ItemDroppedDisconnectedEventImpl
        >
    implements _$$ItemDroppedDisconnectedEventImplCopyWith<$Res> {
  __$$ItemDroppedDisconnectedEventImplCopyWithImpl(
    _$ItemDroppedDisconnectedEventImpl _value,
    $Res Function(_$ItemDroppedDisconnectedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemDroppedDisconnectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? coords = null,
    Object? roomId = null,
  }) {
    return _then(
      _$ItemDroppedDisconnectedEventImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<GameItem>,
        coords: null == coords
            ? _value.coords
            : coords // ignore: cast_nullable_to_non_nullable
                  as GameBoardPosition,
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ItemDroppedDisconnectedEventImpl
    implements _ItemDroppedDisconnectedEvent {
  const _$ItemDroppedDisconnectedEventImpl({
    required final List<GameItem> items,
    required this.coords,
    required this.roomId,
  }) : _items = items;

  final List<GameItem> _items;
  @override
  List<GameItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final GameBoardPosition coords;
  @override
  final String roomId;

  @override
  String toString() {
    return 'ItemDroppedDisconnectedEvent(items: $items, coords: $coords, roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemDroppedDisconnectedEventImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.coords, coords) || other.coords == coords) &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    coords,
    roomId,
  );

  /// Create a copy of ItemDroppedDisconnectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemDroppedDisconnectedEventImplCopyWith<
    _$ItemDroppedDisconnectedEventImpl
  >
  get copyWith =>
      __$$ItemDroppedDisconnectedEventImplCopyWithImpl<
        _$ItemDroppedDisconnectedEventImpl
      >(this, _$identity);
}

abstract class _ItemDroppedDisconnectedEvent
    implements ItemDroppedDisconnectedEvent {
  const factory _ItemDroppedDisconnectedEvent({
    required final List<GameItem> items,
    required final GameBoardPosition coords,
    required final String roomId,
  }) = _$ItemDroppedDisconnectedEventImpl;

  @override
  List<GameItem> get items;
  @override
  GameBoardPosition get coords;
  @override
  String get roomId;

  /// Create a copy of ItemDroppedDisconnectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemDroppedDisconnectedEventImplCopyWith<
    _$ItemDroppedDisconnectedEventImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ItemCollectedEvent {
  String get playerId => throw _privateConstructorUsedError;
  GameItem get item => throw _privateConstructorUsedError;

  /// Create a copy of ItemCollectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemCollectedEventCopyWith<ItemCollectedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemCollectedEventCopyWith<$Res> {
  factory $ItemCollectedEventCopyWith(
    ItemCollectedEvent value,
    $Res Function(ItemCollectedEvent) then,
  ) = _$ItemCollectedEventCopyWithImpl<$Res, ItemCollectedEvent>;
  @useResult
  $Res call({String playerId, GameItem item});

  $GameItemCopyWith<$Res> get item;
}

/// @nodoc
class _$ItemCollectedEventCopyWithImpl<$Res, $Val extends ItemCollectedEvent>
    implements $ItemCollectedEventCopyWith<$Res> {
  _$ItemCollectedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemCollectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null, Object? item = null}) {
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
          )
          as $Val,
    );
  }

  /// Create a copy of ItemCollectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameItemCopyWith<$Res> get item {
    return $GameItemCopyWith<$Res>(_value.item, (value) {
      return _then(_value.copyWith(item: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ItemCollectedEventImplCopyWith<$Res>
    implements $ItemCollectedEventCopyWith<$Res> {
  factory _$$ItemCollectedEventImplCopyWith(
    _$ItemCollectedEventImpl value,
    $Res Function(_$ItemCollectedEventImpl) then,
  ) = __$$ItemCollectedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId, GameItem item});

  @override
  $GameItemCopyWith<$Res> get item;
}

/// @nodoc
class __$$ItemCollectedEventImplCopyWithImpl<$Res>
    extends _$ItemCollectedEventCopyWithImpl<$Res, _$ItemCollectedEventImpl>
    implements _$$ItemCollectedEventImplCopyWith<$Res> {
  __$$ItemCollectedEventImplCopyWithImpl(
    _$ItemCollectedEventImpl _value,
    $Res Function(_$ItemCollectedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemCollectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null, Object? item = null}) {
    return _then(
      _$ItemCollectedEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        item: null == item
            ? _value.item
            : item // ignore: cast_nullable_to_non_nullable
                  as GameItem,
      ),
    );
  }
}

/// @nodoc

class _$ItemCollectedEventImpl implements _ItemCollectedEvent {
  const _$ItemCollectedEventImpl({required this.playerId, required this.item});

  @override
  final String playerId;
  @override
  final GameItem item;

  @override
  String toString() {
    return 'ItemCollectedEvent(playerId: $playerId, item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemCollectedEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId, item);

  /// Create a copy of ItemCollectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemCollectedEventImplCopyWith<_$ItemCollectedEventImpl> get copyWith =>
      __$$ItemCollectedEventImplCopyWithImpl<_$ItemCollectedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _ItemCollectedEvent implements ItemCollectedEvent {
  const factory _ItemCollectedEvent({
    required final String playerId,
    required final GameItem item,
  }) = _$ItemCollectedEventImpl;

  @override
  String get playerId;
  @override
  GameItem get item;

  /// Create a copy of ItemCollectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemCollectedEventImplCopyWith<_$ItemCollectedEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FlagCollectedEvent {
  String get playerId => throw _privateConstructorUsedError;

  /// Create a copy of FlagCollectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlagCollectedEventCopyWith<FlagCollectedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlagCollectedEventCopyWith<$Res> {
  factory $FlagCollectedEventCopyWith(
    FlagCollectedEvent value,
    $Res Function(FlagCollectedEvent) then,
  ) = _$FlagCollectedEventCopyWithImpl<$Res, FlagCollectedEvent>;
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class _$FlagCollectedEventCopyWithImpl<$Res, $Val extends FlagCollectedEvent>
    implements $FlagCollectedEventCopyWith<$Res> {
  _$FlagCollectedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlagCollectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null}) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FlagCollectedEventImplCopyWith<$Res>
    implements $FlagCollectedEventCopyWith<$Res> {
  factory _$$FlagCollectedEventImplCopyWith(
    _$FlagCollectedEventImpl value,
    $Res Function(_$FlagCollectedEventImpl) then,
  ) = __$$FlagCollectedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class __$$FlagCollectedEventImplCopyWithImpl<$Res>
    extends _$FlagCollectedEventCopyWithImpl<$Res, _$FlagCollectedEventImpl>
    implements _$$FlagCollectedEventImplCopyWith<$Res> {
  __$$FlagCollectedEventImplCopyWithImpl(
    _$FlagCollectedEventImpl _value,
    $Res Function(_$FlagCollectedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlagCollectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null}) {
    return _then(
      _$FlagCollectedEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FlagCollectedEventImpl implements _FlagCollectedEvent {
  const _$FlagCollectedEventImpl({required this.playerId});

  @override
  final String playerId;

  @override
  String toString() {
    return 'FlagCollectedEvent(playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlagCollectedEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId);

  /// Create a copy of FlagCollectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlagCollectedEventImplCopyWith<_$FlagCollectedEventImpl> get copyWith =>
      __$$FlagCollectedEventImplCopyWithImpl<_$FlagCollectedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _FlagCollectedEvent implements FlagCollectedEvent {
  const factory _FlagCollectedEvent({required final String playerId}) =
      _$FlagCollectedEventImpl;

  @override
  String get playerId;

  /// Create a copy of FlagCollectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlagCollectedEventImplCopyWith<_$FlagCollectedEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlayerInventorySetEvent {
  String get playerId => throw _privateConstructorUsedError;
  List<GameItem> get items => throw _privateConstructorUsedError;

  /// Create a copy of PlayerInventorySetEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerInventorySetEventCopyWith<PlayerInventorySetEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerInventorySetEventCopyWith<$Res> {
  factory $PlayerInventorySetEventCopyWith(
    PlayerInventorySetEvent value,
    $Res Function(PlayerInventorySetEvent) then,
  ) = _$PlayerInventorySetEventCopyWithImpl<$Res, PlayerInventorySetEvent>;
  @useResult
  $Res call({String playerId, List<GameItem> items});
}

/// @nodoc
class _$PlayerInventorySetEventCopyWithImpl<
  $Res,
  $Val extends PlayerInventorySetEvent
>
    implements $PlayerInventorySetEventCopyWith<$Res> {
  _$PlayerInventorySetEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerInventorySetEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null, Object? items = null}) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<GameItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerInventorySetEventImplCopyWith<$Res>
    implements $PlayerInventorySetEventCopyWith<$Res> {
  factory _$$PlayerInventorySetEventImplCopyWith(
    _$PlayerInventorySetEventImpl value,
    $Res Function(_$PlayerInventorySetEventImpl) then,
  ) = __$$PlayerInventorySetEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId, List<GameItem> items});
}

/// @nodoc
class __$$PlayerInventorySetEventImplCopyWithImpl<$Res>
    extends
        _$PlayerInventorySetEventCopyWithImpl<
          $Res,
          _$PlayerInventorySetEventImpl
        >
    implements _$$PlayerInventorySetEventImplCopyWith<$Res> {
  __$$PlayerInventorySetEventImplCopyWithImpl(
    _$PlayerInventorySetEventImpl _value,
    $Res Function(_$PlayerInventorySetEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerInventorySetEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null, Object? items = null}) {
    return _then(
      _$PlayerInventorySetEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<GameItem>,
      ),
    );
  }
}

/// @nodoc

class _$PlayerInventorySetEventImpl implements _PlayerInventorySetEvent {
  const _$PlayerInventorySetEventImpl({
    required this.playerId,
    required final List<GameItem> items,
  }) : _items = items;

  @override
  final String playerId;
  final List<GameItem> _items;
  @override
  List<GameItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PlayerInventorySetEvent(playerId: $playerId, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerInventorySetEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    playerId,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of PlayerInventorySetEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerInventorySetEventImplCopyWith<_$PlayerInventorySetEventImpl>
  get copyWith =>
      __$$PlayerInventorySetEventImplCopyWithImpl<
        _$PlayerInventorySetEventImpl
      >(this, _$identity);
}

abstract class _PlayerInventorySetEvent implements PlayerInventorySetEvent {
  const factory _PlayerInventorySetEvent({
    required final String playerId,
    required final List<GameItem> items,
  }) = _$PlayerInventorySetEventImpl;

  @override
  String get playerId;
  @override
  List<GameItem> get items;

  /// Create a copy of PlayerInventorySetEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerInventorySetEventImplCopyWith<_$PlayerInventorySetEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}
