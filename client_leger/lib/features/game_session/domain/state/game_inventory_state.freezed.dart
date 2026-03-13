// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_inventory_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameInventoryState {
  Option<String> get playerWithFlagId => throw _privateConstructorUsedError;
  Map<String, List<GameItem>> get itemsByPlayerId =>
      throw _privateConstructorUsedError;

  /// Create a copy of GameInventoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameInventoryStateCopyWith<GameInventoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameInventoryStateCopyWith<$Res> {
  factory $GameInventoryStateCopyWith(
    GameInventoryState value,
    $Res Function(GameInventoryState) then,
  ) = _$GameInventoryStateCopyWithImpl<$Res, GameInventoryState>;
  @useResult
  $Res call({
    Option<String> playerWithFlagId,
    Map<String, List<GameItem>> itemsByPlayerId,
  });
}

/// @nodoc
class _$GameInventoryStateCopyWithImpl<$Res, $Val extends GameInventoryState>
    implements $GameInventoryStateCopyWith<$Res> {
  _$GameInventoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameInventoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerWithFlagId = null, Object? itemsByPlayerId = null}) {
    return _then(
      _value.copyWith(
            playerWithFlagId: null == playerWithFlagId
                ? _value.playerWithFlagId
                : playerWithFlagId // ignore: cast_nullable_to_non_nullable
                      as Option<String>,
            itemsByPlayerId: null == itemsByPlayerId
                ? _value.itemsByPlayerId
                : itemsByPlayerId // ignore: cast_nullable_to_non_nullable
                      as Map<String, List<GameItem>>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameInventoryStateImplCopyWith<$Res>
    implements $GameInventoryStateCopyWith<$Res> {
  factory _$$GameInventoryStateImplCopyWith(
    _$GameInventoryStateImpl value,
    $Res Function(_$GameInventoryStateImpl) then,
  ) = __$$GameInventoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Option<String> playerWithFlagId,
    Map<String, List<GameItem>> itemsByPlayerId,
  });
}

/// @nodoc
class __$$GameInventoryStateImplCopyWithImpl<$Res>
    extends _$GameInventoryStateCopyWithImpl<$Res, _$GameInventoryStateImpl>
    implements _$$GameInventoryStateImplCopyWith<$Res> {
  __$$GameInventoryStateImplCopyWithImpl(
    _$GameInventoryStateImpl _value,
    $Res Function(_$GameInventoryStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameInventoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerWithFlagId = null, Object? itemsByPlayerId = null}) {
    return _then(
      _$GameInventoryStateImpl(
        playerWithFlagId: null == playerWithFlagId
            ? _value.playerWithFlagId
            : playerWithFlagId // ignore: cast_nullable_to_non_nullable
                  as Option<String>,
        itemsByPlayerId: null == itemsByPlayerId
            ? _value._itemsByPlayerId
            : itemsByPlayerId // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<GameItem>>,
      ),
    );
  }
}

/// @nodoc

class _$GameInventoryStateImpl extends _GameInventoryState {
  const _$GameInventoryStateImpl({
    required this.playerWithFlagId,
    final Map<String, List<GameItem>> itemsByPlayerId = const {},
  }) : _itemsByPlayerId = itemsByPlayerId,
       super._();

  @override
  final Option<String> playerWithFlagId;
  final Map<String, List<GameItem>> _itemsByPlayerId;
  @override
  @JsonKey()
  Map<String, List<GameItem>> get itemsByPlayerId {
    if (_itemsByPlayerId is EqualUnmodifiableMapView) return _itemsByPlayerId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_itemsByPlayerId);
  }

  @override
  String toString() {
    return 'GameInventoryState(playerWithFlagId: $playerWithFlagId, itemsByPlayerId: $itemsByPlayerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameInventoryStateImpl &&
            (identical(other.playerWithFlagId, playerWithFlagId) ||
                other.playerWithFlagId == playerWithFlagId) &&
            const DeepCollectionEquality().equals(
              other._itemsByPlayerId,
              _itemsByPlayerId,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    playerWithFlagId,
    const DeepCollectionEquality().hash(_itemsByPlayerId),
  );

  /// Create a copy of GameInventoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameInventoryStateImplCopyWith<_$GameInventoryStateImpl> get copyWith =>
      __$$GameInventoryStateImplCopyWithImpl<_$GameInventoryStateImpl>(
        this,
        _$identity,
      );
}

abstract class _GameInventoryState extends GameInventoryState {
  const factory _GameInventoryState({
    required final Option<String> playerWithFlagId,
    final Map<String, List<GameItem>> itemsByPlayerId,
  }) = _$GameInventoryStateImpl;
  const _GameInventoryState._() : super._();

  @override
  Option<String> get playerWithFlagId;
  @override
  Map<String, List<GameItem>> get itemsByPlayerId;

  /// Create a copy of GameInventoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameInventoryStateImplCopyWith<_$GameInventoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
