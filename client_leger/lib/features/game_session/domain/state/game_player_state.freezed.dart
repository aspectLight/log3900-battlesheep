// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GamePlayer {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  BoardCharacterType get characterType => throw _privateConstructorUsedError;
  BoardCharacterColor get color => throw _privateConstructorUsedError;
  BoardCharacterOrientation get orientation =>
      throw _privateConstructorUsedError;
  BoardCharacterState get state => throw _privateConstructorUsedError;
  int get actionPoints => throw _privateConstructorUsedError;
  int get movementPoints => throw _privateConstructorUsedError;
  Map<StatType, int> get stats => throw _privateConstructorUsedError;
  StatType get diceChoice => throw _privateConstructorUsedError;
  List<GameItem?> get inventory => throw _privateConstructorUsedError;
  bool get isVirtual => throw _privateConstructorUsedError;
  int get team => throw _privateConstructorUsedError;
  GameBoardPosition get spawnPoint => throw _privateConstructorUsedError;
  bool get propagandaActive => throw _privateConstructorUsedError;

  /// Create a copy of GamePlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GamePlayerCopyWith<GamePlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GamePlayerCopyWith<$Res> {
  factory $GamePlayerCopyWith(
    GamePlayer value,
    $Res Function(GamePlayer) then,
  ) = _$GamePlayerCopyWithImpl<$Res, GamePlayer>;
  @useResult
  $Res call({
    String id,
    String name,
    BoardCharacterType characterType,
    BoardCharacterColor color,
    BoardCharacterOrientation orientation,
    BoardCharacterState state,
    int actionPoints,
    int movementPoints,
    Map<StatType, int> stats,
    StatType diceChoice,
    List<GameItem?> inventory,
    bool isVirtual,
    int team,
    GameBoardPosition spawnPoint,
    bool propagandaActive,
  });

  $GameBoardPositionCopyWith<$Res> get spawnPoint;
}

/// @nodoc
class _$GamePlayerCopyWithImpl<$Res, $Val extends GamePlayer>
    implements $GamePlayerCopyWith<$Res> {
  _$GamePlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GamePlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? characterType = null,
    Object? color = null,
    Object? orientation = null,
    Object? state = null,
    Object? actionPoints = null,
    Object? movementPoints = null,
    Object? stats = null,
    Object? diceChoice = null,
    Object? inventory = null,
    Object? isVirtual = null,
    Object? team = null,
    Object? spawnPoint = null,
    Object? propagandaActive = null,
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
            characterType: null == characterType
                ? _value.characterType
                : characterType // ignore: cast_nullable_to_non_nullable
                      as BoardCharacterType,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as BoardCharacterColor,
            orientation: null == orientation
                ? _value.orientation
                : orientation // ignore: cast_nullable_to_non_nullable
                      as BoardCharacterOrientation,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as BoardCharacterState,
            actionPoints: null == actionPoints
                ? _value.actionPoints
                : actionPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            movementPoints: null == movementPoints
                ? _value.movementPoints
                : movementPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            stats: null == stats
                ? _value.stats
                : stats // ignore: cast_nullable_to_non_nullable
                      as Map<StatType, int>,
            diceChoice: null == diceChoice
                ? _value.diceChoice
                : diceChoice // ignore: cast_nullable_to_non_nullable
                      as StatType,
            inventory: null == inventory
                ? _value.inventory
                : inventory // ignore: cast_nullable_to_non_nullable
                      as List<GameItem?>,
            isVirtual: null == isVirtual
                ? _value.isVirtual
                : isVirtual // ignore: cast_nullable_to_non_nullable
                      as bool,
            team: null == team
                ? _value.team
                : team // ignore: cast_nullable_to_non_nullable
                      as int,
            spawnPoint: null == spawnPoint
                ? _value.spawnPoint
                : spawnPoint // ignore: cast_nullable_to_non_nullable
                      as GameBoardPosition,
            propagandaActive: null == propagandaActive
                ? _value.propagandaActive
                : propagandaActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of GamePlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameBoardPositionCopyWith<$Res> get spawnPoint {
    return $GameBoardPositionCopyWith<$Res>(_value.spawnPoint, (value) {
      return _then(_value.copyWith(spawnPoint: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GamePlayerImplCopyWith<$Res>
    implements $GamePlayerCopyWith<$Res> {
  factory _$$GamePlayerImplCopyWith(
    _$GamePlayerImpl value,
    $Res Function(_$GamePlayerImpl) then,
  ) = __$$GamePlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    BoardCharacterType characterType,
    BoardCharacterColor color,
    BoardCharacterOrientation orientation,
    BoardCharacterState state,
    int actionPoints,
    int movementPoints,
    Map<StatType, int> stats,
    StatType diceChoice,
    List<GameItem?> inventory,
    bool isVirtual,
    int team,
    GameBoardPosition spawnPoint,
    bool propagandaActive,
  });

  @override
  $GameBoardPositionCopyWith<$Res> get spawnPoint;
}

/// @nodoc
class __$$GamePlayerImplCopyWithImpl<$Res>
    extends _$GamePlayerCopyWithImpl<$Res, _$GamePlayerImpl>
    implements _$$GamePlayerImplCopyWith<$Res> {
  __$$GamePlayerImplCopyWithImpl(
    _$GamePlayerImpl _value,
    $Res Function(_$GamePlayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GamePlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? characterType = null,
    Object? color = null,
    Object? orientation = null,
    Object? state = null,
    Object? actionPoints = null,
    Object? movementPoints = null,
    Object? stats = null,
    Object? diceChoice = null,
    Object? inventory = null,
    Object? isVirtual = null,
    Object? team = null,
    Object? spawnPoint = null,
    Object? propagandaActive = null,
  }) {
    return _then(
      _$GamePlayerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        characterType: null == characterType
            ? _value.characterType
            : characterType // ignore: cast_nullable_to_non_nullable
                  as BoardCharacterType,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as BoardCharacterColor,
        orientation: null == orientation
            ? _value.orientation
            : orientation // ignore: cast_nullable_to_non_nullable
                  as BoardCharacterOrientation,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as BoardCharacterState,
        actionPoints: null == actionPoints
            ? _value.actionPoints
            : actionPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        movementPoints: null == movementPoints
            ? _value.movementPoints
            : movementPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        stats: null == stats
            ? _value._stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as Map<StatType, int>,
        diceChoice: null == diceChoice
            ? _value.diceChoice
            : diceChoice // ignore: cast_nullable_to_non_nullable
                  as StatType,
        inventory: null == inventory
            ? _value._inventory
            : inventory // ignore: cast_nullable_to_non_nullable
                  as List<GameItem?>,
        isVirtual: null == isVirtual
            ? _value.isVirtual
            : isVirtual // ignore: cast_nullable_to_non_nullable
                  as bool,
        team: null == team
            ? _value.team
            : team // ignore: cast_nullable_to_non_nullable
                  as int,
        spawnPoint: null == spawnPoint
            ? _value.spawnPoint
            : spawnPoint // ignore: cast_nullable_to_non_nullable
                  as GameBoardPosition,
        propagandaActive: null == propagandaActive
            ? _value.propagandaActive
            : propagandaActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$GamePlayerImpl extends _GamePlayer {
  const _$GamePlayerImpl({
    required this.id,
    required this.name,
    required this.characterType,
    required this.color,
    required this.orientation,
    required this.state,
    required this.actionPoints,
    required this.movementPoints,
    required final Map<StatType, int> stats,
    required this.diceChoice,
    required final List<GameItem?> inventory,
    required this.isVirtual,
    required this.team,
    required this.spawnPoint,
    this.propagandaActive = false,
  }) : _stats = stats,
       _inventory = inventory,
       super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final BoardCharacterType characterType;
  @override
  final BoardCharacterColor color;
  @override
  final BoardCharacterOrientation orientation;
  @override
  final BoardCharacterState state;
  @override
  final int actionPoints;
  @override
  final int movementPoints;
  final Map<StatType, int> _stats;
  @override
  Map<StatType, int> get stats {
    if (_stats is EqualUnmodifiableMapView) return _stats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_stats);
  }

  @override
  final StatType diceChoice;
  final List<GameItem?> _inventory;
  @override
  List<GameItem?> get inventory {
    if (_inventory is EqualUnmodifiableListView) return _inventory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inventory);
  }

  @override
  final bool isVirtual;
  @override
  final int team;
  @override
  final GameBoardPosition spawnPoint;
  @override
  @JsonKey()
  final bool propagandaActive;

  @override
  String toString() {
    return 'GamePlayer(id: $id, name: $name, characterType: $characterType, color: $color, orientation: $orientation, state: $state, actionPoints: $actionPoints, movementPoints: $movementPoints, stats: $stats, diceChoice: $diceChoice, inventory: $inventory, isVirtual: $isVirtual, team: $team, spawnPoint: $spawnPoint, propagandaActive: $propagandaActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GamePlayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.characterType, characterType) ||
                other.characterType == characterType) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.orientation, orientation) ||
                other.orientation == orientation) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.actionPoints, actionPoints) ||
                other.actionPoints == actionPoints) &&
            (identical(other.movementPoints, movementPoints) ||
                other.movementPoints == movementPoints) &&
            const DeepCollectionEquality().equals(other._stats, _stats) &&
            (identical(other.diceChoice, diceChoice) ||
                other.diceChoice == diceChoice) &&
            const DeepCollectionEquality().equals(
              other._inventory,
              _inventory,
            ) &&
            (identical(other.isVirtual, isVirtual) ||
                other.isVirtual == isVirtual) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.spawnPoint, spawnPoint) ||
                other.spawnPoint == spawnPoint) &&
            (identical(other.propagandaActive, propagandaActive) ||
                other.propagandaActive == propagandaActive));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    characterType,
    color,
    orientation,
    state,
    actionPoints,
    movementPoints,
    const DeepCollectionEquality().hash(_stats),
    diceChoice,
    const DeepCollectionEquality().hash(_inventory),
    isVirtual,
    team,
    spawnPoint,
    propagandaActive,
  );

  /// Create a copy of GamePlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GamePlayerImplCopyWith<_$GamePlayerImpl> get copyWith =>
      __$$GamePlayerImplCopyWithImpl<_$GamePlayerImpl>(this, _$identity);
}

abstract class _GamePlayer extends GamePlayer {
  const factory _GamePlayer({
    required final String id,
    required final String name,
    required final BoardCharacterType characterType,
    required final BoardCharacterColor color,
    required final BoardCharacterOrientation orientation,
    required final BoardCharacterState state,
    required final int actionPoints,
    required final int movementPoints,
    required final Map<StatType, int> stats,
    required final StatType diceChoice,
    required final List<GameItem?> inventory,
    required final bool isVirtual,
    required final int team,
    required final GameBoardPosition spawnPoint,
    final bool propagandaActive,
  }) = _$GamePlayerImpl;
  const _GamePlayer._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  BoardCharacterType get characterType;
  @override
  BoardCharacterColor get color;
  @override
  BoardCharacterOrientation get orientation;
  @override
  BoardCharacterState get state;
  @override
  int get actionPoints;
  @override
  int get movementPoints;
  @override
  Map<StatType, int> get stats;
  @override
  StatType get diceChoice;
  @override
  List<GameItem?> get inventory;
  @override
  bool get isVirtual;
  @override
  int get team;
  @override
  GameBoardPosition get spawnPoint;
  @override
  bool get propagandaActive;

  /// Create a copy of GamePlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GamePlayerImplCopyWith<_$GamePlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GamePlayerState {
  List<GamePlayer> get players => throw _privateConstructorUsedError;
  Option<String> get activePlayerId => throw _privateConstructorUsedError;
  List<String> get disconnectedPlayerIds => throw _privateConstructorUsedError;
  Map<String, int> get winsByPlayerId => throw _privateConstructorUsedError;

  /// Create a copy of GamePlayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GamePlayerStateCopyWith<GamePlayerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GamePlayerStateCopyWith<$Res> {
  factory $GamePlayerStateCopyWith(
    GamePlayerState value,
    $Res Function(GamePlayerState) then,
  ) = _$GamePlayerStateCopyWithImpl<$Res, GamePlayerState>;
  @useResult
  $Res call({
    List<GamePlayer> players,
    Option<String> activePlayerId,
    List<String> disconnectedPlayerIds,
    Map<String, int> winsByPlayerId,
  });
}

/// @nodoc
class _$GamePlayerStateCopyWithImpl<$Res, $Val extends GamePlayerState>
    implements $GamePlayerStateCopyWith<$Res> {
  _$GamePlayerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GamePlayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
    Object? activePlayerId = null,
    Object? disconnectedPlayerIds = null,
    Object? winsByPlayerId = null,
  }) {
    return _then(
      _value.copyWith(
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<GamePlayer>,
            activePlayerId: null == activePlayerId
                ? _value.activePlayerId
                : activePlayerId // ignore: cast_nullable_to_non_nullable
                      as Option<String>,
            disconnectedPlayerIds: null == disconnectedPlayerIds
                ? _value.disconnectedPlayerIds
                : disconnectedPlayerIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            winsByPlayerId: null == winsByPlayerId
                ? _value.winsByPlayerId
                : winsByPlayerId // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GamePlayerStateImplCopyWith<$Res>
    implements $GamePlayerStateCopyWith<$Res> {
  factory _$$GamePlayerStateImplCopyWith(
    _$GamePlayerStateImpl value,
    $Res Function(_$GamePlayerStateImpl) then,
  ) = __$$GamePlayerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<GamePlayer> players,
    Option<String> activePlayerId,
    List<String> disconnectedPlayerIds,
    Map<String, int> winsByPlayerId,
  });
}

/// @nodoc
class __$$GamePlayerStateImplCopyWithImpl<$Res>
    extends _$GamePlayerStateCopyWithImpl<$Res, _$GamePlayerStateImpl>
    implements _$$GamePlayerStateImplCopyWith<$Res> {
  __$$GamePlayerStateImplCopyWithImpl(
    _$GamePlayerStateImpl _value,
    $Res Function(_$GamePlayerStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GamePlayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
    Object? activePlayerId = null,
    Object? disconnectedPlayerIds = null,
    Object? winsByPlayerId = null,
  }) {
    return _then(
      _$GamePlayerStateImpl(
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<GamePlayer>,
        activePlayerId: null == activePlayerId
            ? _value.activePlayerId
            : activePlayerId // ignore: cast_nullable_to_non_nullable
                  as Option<String>,
        disconnectedPlayerIds: null == disconnectedPlayerIds
            ? _value._disconnectedPlayerIds
            : disconnectedPlayerIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        winsByPlayerId: null == winsByPlayerId
            ? _value._winsByPlayerId
            : winsByPlayerId // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
      ),
    );
  }
}

/// @nodoc

class _$GamePlayerStateImpl extends _GamePlayerState {
  const _$GamePlayerStateImpl({
    required final List<GamePlayer> players,
    required this.activePlayerId,
    required final List<String> disconnectedPlayerIds,
    required final Map<String, int> winsByPlayerId,
  }) : _players = players,
       _disconnectedPlayerIds = disconnectedPlayerIds,
       _winsByPlayerId = winsByPlayerId,
       super._();

  final List<GamePlayer> _players;
  @override
  List<GamePlayer> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  final Option<String> activePlayerId;
  final List<String> _disconnectedPlayerIds;
  @override
  List<String> get disconnectedPlayerIds {
    if (_disconnectedPlayerIds is EqualUnmodifiableListView)
      return _disconnectedPlayerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_disconnectedPlayerIds);
  }

  final Map<String, int> _winsByPlayerId;
  @override
  Map<String, int> get winsByPlayerId {
    if (_winsByPlayerId is EqualUnmodifiableMapView) return _winsByPlayerId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_winsByPlayerId);
  }

  @override
  String toString() {
    return 'GamePlayerState(players: $players, activePlayerId: $activePlayerId, disconnectedPlayerIds: $disconnectedPlayerIds, winsByPlayerId: $winsByPlayerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GamePlayerStateImpl &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.activePlayerId, activePlayerId) ||
                other.activePlayerId == activePlayerId) &&
            const DeepCollectionEquality().equals(
              other._disconnectedPlayerIds,
              _disconnectedPlayerIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._winsByPlayerId,
              _winsByPlayerId,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_players),
    activePlayerId,
    const DeepCollectionEquality().hash(_disconnectedPlayerIds),
    const DeepCollectionEquality().hash(_winsByPlayerId),
  );

  /// Create a copy of GamePlayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GamePlayerStateImplCopyWith<_$GamePlayerStateImpl> get copyWith =>
      __$$GamePlayerStateImplCopyWithImpl<_$GamePlayerStateImpl>(
        this,
        _$identity,
      );
}

abstract class _GamePlayerState extends GamePlayerState {
  const factory _GamePlayerState({
    required final List<GamePlayer> players,
    required final Option<String> activePlayerId,
    required final List<String> disconnectedPlayerIds,
    required final Map<String, int> winsByPlayerId,
  }) = _$GamePlayerStateImpl;
  const _GamePlayerState._() : super._();

  @override
  List<GamePlayer> get players;
  @override
  Option<String> get activePlayerId;
  @override
  List<String> get disconnectedPlayerIds;
  @override
  Map<String, int> get winsByPlayerId;

  /// Create a copy of GamePlayerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GamePlayerStateImplCopyWith<_$GamePlayerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
