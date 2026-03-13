// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_board_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameBoardState {
  Board get board => throw _privateConstructorUsedError;
  Map<GameBoardPosition, GameItem> get items =>
      throw _privateConstructorUsedError;
  Map<String, GameBoardPosition> get playerPositions =>
      throw _privateConstructorUsedError;
  Set<GameBoardPosition> get reachableCellCoords =>
      throw _privateConstructorUsedError;
  Map<GameBoardPosition, List<GameBoardPosition>>
  get reachablePathsByDestination => throw _privateConstructorUsedError;
  List<GameBoardPosition> get selectedPathCoords =>
      throw _privateConstructorUsedError;
  Option<PendingItemPickup> get pendingItemPickup =>
      throw _privateConstructorUsedError;

  /// Create a copy of GameBoardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameBoardStateCopyWith<GameBoardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameBoardStateCopyWith<$Res> {
  factory $GameBoardStateCopyWith(
    GameBoardState value,
    $Res Function(GameBoardState) then,
  ) = _$GameBoardStateCopyWithImpl<$Res, GameBoardState>;
  @useResult
  $Res call({
    Board board,
    Map<GameBoardPosition, GameItem> items,
    Map<String, GameBoardPosition> playerPositions,
    Set<GameBoardPosition> reachableCellCoords,
    Map<GameBoardPosition, List<GameBoardPosition>> reachablePathsByDestination,
    List<GameBoardPosition> selectedPathCoords,
    Option<PendingItemPickup> pendingItemPickup,
  });
}

/// @nodoc
class _$GameBoardStateCopyWithImpl<$Res, $Val extends GameBoardState>
    implements $GameBoardStateCopyWith<$Res> {
  _$GameBoardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameBoardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? items = null,
    Object? playerPositions = null,
    Object? reachableCellCoords = null,
    Object? reachablePathsByDestination = null,
    Object? selectedPathCoords = null,
    Object? pendingItemPickup = null,
  }) {
    return _then(
      _value.copyWith(
            board: null == board
                ? _value.board
                : board // ignore: cast_nullable_to_non_nullable
                      as Board,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as Map<GameBoardPosition, GameItem>,
            playerPositions: null == playerPositions
                ? _value.playerPositions
                : playerPositions // ignore: cast_nullable_to_non_nullable
                      as Map<String, GameBoardPosition>,
            reachableCellCoords: null == reachableCellCoords
                ? _value.reachableCellCoords
                : reachableCellCoords // ignore: cast_nullable_to_non_nullable
                      as Set<GameBoardPosition>,
            reachablePathsByDestination: null == reachablePathsByDestination
                ? _value.reachablePathsByDestination
                : reachablePathsByDestination // ignore: cast_nullable_to_non_nullable
                      as Map<GameBoardPosition, List<GameBoardPosition>>,
            selectedPathCoords: null == selectedPathCoords
                ? _value.selectedPathCoords
                : selectedPathCoords // ignore: cast_nullable_to_non_nullable
                      as List<GameBoardPosition>,
            pendingItemPickup: null == pendingItemPickup
                ? _value.pendingItemPickup
                : pendingItemPickup // ignore: cast_nullable_to_non_nullable
                      as Option<PendingItemPickup>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameBoardStateImplCopyWith<$Res>
    implements $GameBoardStateCopyWith<$Res> {
  factory _$$GameBoardStateImplCopyWith(
    _$GameBoardStateImpl value,
    $Res Function(_$GameBoardStateImpl) then,
  ) = __$$GameBoardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Board board,
    Map<GameBoardPosition, GameItem> items,
    Map<String, GameBoardPosition> playerPositions,
    Set<GameBoardPosition> reachableCellCoords,
    Map<GameBoardPosition, List<GameBoardPosition>> reachablePathsByDestination,
    List<GameBoardPosition> selectedPathCoords,
    Option<PendingItemPickup> pendingItemPickup,
  });
}

/// @nodoc
class __$$GameBoardStateImplCopyWithImpl<$Res>
    extends _$GameBoardStateCopyWithImpl<$Res, _$GameBoardStateImpl>
    implements _$$GameBoardStateImplCopyWith<$Res> {
  __$$GameBoardStateImplCopyWithImpl(
    _$GameBoardStateImpl _value,
    $Res Function(_$GameBoardStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameBoardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? items = null,
    Object? playerPositions = null,
    Object? reachableCellCoords = null,
    Object? reachablePathsByDestination = null,
    Object? selectedPathCoords = null,
    Object? pendingItemPickup = null,
  }) {
    return _then(
      _$GameBoardStateImpl(
        board: null == board
            ? _value.board
            : board // ignore: cast_nullable_to_non_nullable
                  as Board,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as Map<GameBoardPosition, GameItem>,
        playerPositions: null == playerPositions
            ? _value._playerPositions
            : playerPositions // ignore: cast_nullable_to_non_nullable
                  as Map<String, GameBoardPosition>,
        reachableCellCoords: null == reachableCellCoords
            ? _value._reachableCellCoords
            : reachableCellCoords // ignore: cast_nullable_to_non_nullable
                  as Set<GameBoardPosition>,
        reachablePathsByDestination: null == reachablePathsByDestination
            ? _value._reachablePathsByDestination
            : reachablePathsByDestination // ignore: cast_nullable_to_non_nullable
                  as Map<GameBoardPosition, List<GameBoardPosition>>,
        selectedPathCoords: null == selectedPathCoords
            ? _value._selectedPathCoords
            : selectedPathCoords // ignore: cast_nullable_to_non_nullable
                  as List<GameBoardPosition>,
        pendingItemPickup: null == pendingItemPickup
            ? _value.pendingItemPickup
            : pendingItemPickup // ignore: cast_nullable_to_non_nullable
                  as Option<PendingItemPickup>,
      ),
    );
  }
}

/// @nodoc

class _$GameBoardStateImpl extends _GameBoardState {
  const _$GameBoardStateImpl({
    required this.board,
    required final Map<GameBoardPosition, GameItem> items,
    required final Map<String, GameBoardPosition> playerPositions,
    required final Set<GameBoardPosition> reachableCellCoords,
    required final Map<GameBoardPosition, List<GameBoardPosition>>
    reachablePathsByDestination,
    required final List<GameBoardPosition> selectedPathCoords,
    this.pendingItemPickup = const Option.none(),
  }) : _items = items,
       _playerPositions = playerPositions,
       _reachableCellCoords = reachableCellCoords,
       _reachablePathsByDestination = reachablePathsByDestination,
       _selectedPathCoords = selectedPathCoords,
       super._();

  @override
  final Board board;
  final Map<GameBoardPosition, GameItem> _items;
  @override
  Map<GameBoardPosition, GameItem> get items {
    if (_items is EqualUnmodifiableMapView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_items);
  }

  final Map<String, GameBoardPosition> _playerPositions;
  @override
  Map<String, GameBoardPosition> get playerPositions {
    if (_playerPositions is EqualUnmodifiableMapView) return _playerPositions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_playerPositions);
  }

  final Set<GameBoardPosition> _reachableCellCoords;
  @override
  Set<GameBoardPosition> get reachableCellCoords {
    if (_reachableCellCoords is EqualUnmodifiableSetView)
      return _reachableCellCoords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_reachableCellCoords);
  }

  final Map<GameBoardPosition, List<GameBoardPosition>>
  _reachablePathsByDestination;
  @override
  Map<GameBoardPosition, List<GameBoardPosition>>
  get reachablePathsByDestination {
    if (_reachablePathsByDestination is EqualUnmodifiableMapView)
      return _reachablePathsByDestination;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_reachablePathsByDestination);
  }

  final List<GameBoardPosition> _selectedPathCoords;
  @override
  List<GameBoardPosition> get selectedPathCoords {
    if (_selectedPathCoords is EqualUnmodifiableListView)
      return _selectedPathCoords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedPathCoords);
  }

  @override
  @JsonKey()
  final Option<PendingItemPickup> pendingItemPickup;

  @override
  String toString() {
    return 'GameBoardState(board: $board, items: $items, playerPositions: $playerPositions, reachableCellCoords: $reachableCellCoords, reachablePathsByDestination: $reachablePathsByDestination, selectedPathCoords: $selectedPathCoords, pendingItemPickup: $pendingItemPickup)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameBoardStateImpl &&
            (identical(other.board, board) || other.board == board) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(
              other._playerPositions,
              _playerPositions,
            ) &&
            const DeepCollectionEquality().equals(
              other._reachableCellCoords,
              _reachableCellCoords,
            ) &&
            const DeepCollectionEquality().equals(
              other._reachablePathsByDestination,
              _reachablePathsByDestination,
            ) &&
            const DeepCollectionEquality().equals(
              other._selectedPathCoords,
              _selectedPathCoords,
            ) &&
            (identical(other.pendingItemPickup, pendingItemPickup) ||
                other.pendingItemPickup == pendingItemPickup));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    board,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_playerPositions),
    const DeepCollectionEquality().hash(_reachableCellCoords),
    const DeepCollectionEquality().hash(_reachablePathsByDestination),
    const DeepCollectionEquality().hash(_selectedPathCoords),
    pendingItemPickup,
  );

  /// Create a copy of GameBoardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameBoardStateImplCopyWith<_$GameBoardStateImpl> get copyWith =>
      __$$GameBoardStateImplCopyWithImpl<_$GameBoardStateImpl>(
        this,
        _$identity,
      );
}

abstract class _GameBoardState extends GameBoardState {
  const factory _GameBoardState({
    required final Board board,
    required final Map<GameBoardPosition, GameItem> items,
    required final Map<String, GameBoardPosition> playerPositions,
    required final Set<GameBoardPosition> reachableCellCoords,
    required final Map<GameBoardPosition, List<GameBoardPosition>>
    reachablePathsByDestination,
    required final List<GameBoardPosition> selectedPathCoords,
    final Option<PendingItemPickup> pendingItemPickup,
  }) = _$GameBoardStateImpl;
  const _GameBoardState._() : super._();

  @override
  Board get board;
  @override
  Map<GameBoardPosition, GameItem> get items;
  @override
  Map<String, GameBoardPosition> get playerPositions;
  @override
  Set<GameBoardPosition> get reachableCellCoords;
  @override
  Map<GameBoardPosition, List<GameBoardPosition>>
  get reachablePathsByDestination;
  @override
  List<GameBoardPosition> get selectedPathCoords;
  @override
  Option<PendingItemPickup> get pendingItemPickup;

  /// Create a copy of GameBoardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameBoardStateImplCopyWith<_$GameBoardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
