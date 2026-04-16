// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_creation_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CharacterCreationEntryAppEvent {
  String get socketId => throw _privateConstructorUsedError;
  String get roomCode => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String socketId,
      String roomCode,
      String gameId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      int entryFee,
      bool friendsOnly,
    )
    hostEntered,
    required TResult Function(
      String socketId,
      String roomCode,
      String hostId,
      LobbyRoomModel initialRoom,
      bool isDropIn,
    )
    joinEntered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String socketId,
      String roomCode,
      String gameId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      int entryFee,
      bool friendsOnly,
    )?
    hostEntered,
    TResult? Function(
      String socketId,
      String roomCode,
      String hostId,
      LobbyRoomModel initialRoom,
      bool isDropIn,
    )?
    joinEntered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String socketId,
      String roomCode,
      String gameId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      int entryFee,
      bool friendsOnly,
    )?
    hostEntered,
    TResult Function(
      String socketId,
      String roomCode,
      String hostId,
      LobbyRoomModel initialRoom,
      bool isDropIn,
    )?
    joinEntered,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CharacterCreationHostEntered value) hostEntered,
    required TResult Function(CharacterCreationJoinEntered value) joinEntered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CharacterCreationHostEntered value)? hostEntered,
    TResult? Function(CharacterCreationJoinEntered value)? joinEntered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CharacterCreationHostEntered value)? hostEntered,
    TResult Function(CharacterCreationJoinEntered value)? joinEntered,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of CharacterCreationEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterCreationEntryAppEventCopyWith<CharacterCreationEntryAppEvent>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterCreationEntryAppEventCopyWith<$Res> {
  factory $CharacterCreationEntryAppEventCopyWith(
    CharacterCreationEntryAppEvent value,
    $Res Function(CharacterCreationEntryAppEvent) then,
  ) =
      _$CharacterCreationEntryAppEventCopyWithImpl<
        $Res,
        CharacterCreationEntryAppEvent
      >;
  @useResult
  $Res call({String socketId, String roomCode});
}

/// @nodoc
class _$CharacterCreationEntryAppEventCopyWithImpl<
  $Res,
  $Val extends CharacterCreationEntryAppEvent
>
    implements $CharacterCreationEntryAppEventCopyWith<$Res> {
  _$CharacterCreationEntryAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CharacterCreationEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? socketId = null, Object? roomCode = null}) {
    return _then(
      _value.copyWith(
            socketId: null == socketId
                ? _value.socketId
                : socketId // ignore: cast_nullable_to_non_nullable
                      as String,
            roomCode: null == roomCode
                ? _value.roomCode
                : roomCode // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CharacterCreationHostEnteredImplCopyWith<$Res>
    implements $CharacterCreationEntryAppEventCopyWith<$Res> {
  factory _$$CharacterCreationHostEnteredImplCopyWith(
    _$CharacterCreationHostEnteredImpl value,
    $Res Function(_$CharacterCreationHostEnteredImpl) then,
  ) = __$$CharacterCreationHostEnteredImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String socketId,
    String roomCode,
    String gameId,
    String gameName,
    String gameDescription,
    int boardSize,
    bool isCTF,
    int entryFee,
    bool friendsOnly,
  });
}

/// @nodoc
class __$$CharacterCreationHostEnteredImplCopyWithImpl<$Res>
    extends
        _$CharacterCreationEntryAppEventCopyWithImpl<
          $Res,
          _$CharacterCreationHostEnteredImpl
        >
    implements _$$CharacterCreationHostEnteredImplCopyWith<$Res> {
  __$$CharacterCreationHostEnteredImplCopyWithImpl(
    _$CharacterCreationHostEnteredImpl _value,
    $Res Function(_$CharacterCreationHostEnteredImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CharacterCreationEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? socketId = null,
    Object? roomCode = null,
    Object? gameId = null,
    Object? gameName = null,
    Object? gameDescription = null,
    Object? boardSize = null,
    Object? isCTF = null,
    Object? entryFee = null,
    Object? friendsOnly = null,
  }) {
    return _then(
      _$CharacterCreationHostEnteredImpl(
        socketId: null == socketId
            ? _value.socketId
            : socketId // ignore: cast_nullable_to_non_nullable
                  as String,
        roomCode: null == roomCode
            ? _value.roomCode
            : roomCode // ignore: cast_nullable_to_non_nullable
                  as String,
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String,
        gameName: null == gameName
            ? _value.gameName
            : gameName // ignore: cast_nullable_to_non_nullable
                  as String,
        gameDescription: null == gameDescription
            ? _value.gameDescription
            : gameDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        boardSize: null == boardSize
            ? _value.boardSize
            : boardSize // ignore: cast_nullable_to_non_nullable
                  as int,
        isCTF: null == isCTF
            ? _value.isCTF
            : isCTF // ignore: cast_nullable_to_non_nullable
                  as bool,
        entryFee: null == entryFee
            ? _value.entryFee
            : entryFee // ignore: cast_nullable_to_non_nullable
                  as int,
        friendsOnly: null == friendsOnly
            ? _value.friendsOnly
            : friendsOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$CharacterCreationHostEnteredImpl
    implements CharacterCreationHostEntered {
  const _$CharacterCreationHostEnteredImpl({
    required this.socketId,
    required this.roomCode,
    required this.gameId,
    required this.gameName,
    required this.gameDescription,
    required this.boardSize,
    required this.isCTF,
    this.entryFee = 0,
    this.friendsOnly = false,
  });

  @override
  final String socketId;
  @override
  final String roomCode;
  @override
  final String gameId;
  @override
  final String gameName;
  @override
  final String gameDescription;
  @override
  final int boardSize;
  @override
  final bool isCTF;
  @override
  @JsonKey()
  final int entryFee;
  @override
  @JsonKey()
  final bool friendsOnly;

  @override
  String toString() {
    return 'CharacterCreationEntryAppEvent.hostEntered(socketId: $socketId, roomCode: $roomCode, gameId: $gameId, gameName: $gameName, gameDescription: $gameDescription, boardSize: $boardSize, isCTF: $isCTF, entryFee: $entryFee, friendsOnly: $friendsOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterCreationHostEnteredImpl &&
            (identical(other.socketId, socketId) ||
                other.socketId == socketId) &&
            (identical(other.roomCode, roomCode) ||
                other.roomCode == roomCode) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.gameName, gameName) ||
                other.gameName == gameName) &&
            (identical(other.gameDescription, gameDescription) ||
                other.gameDescription == gameDescription) &&
            (identical(other.boardSize, boardSize) ||
                other.boardSize == boardSize) &&
            (identical(other.isCTF, isCTF) || other.isCTF == isCTF) &&
            (identical(other.entryFee, entryFee) ||
                other.entryFee == entryFee) &&
            (identical(other.friendsOnly, friendsOnly) ||
                other.friendsOnly == friendsOnly));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    socketId,
    roomCode,
    gameId,
    gameName,
    gameDescription,
    boardSize,
    isCTF,
    entryFee,
    friendsOnly,
  );

  /// Create a copy of CharacterCreationEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterCreationHostEnteredImplCopyWith<
    _$CharacterCreationHostEnteredImpl
  >
  get copyWith =>
      __$$CharacterCreationHostEnteredImplCopyWithImpl<
        _$CharacterCreationHostEnteredImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String socketId,
      String roomCode,
      String gameId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      int entryFee,
      bool friendsOnly,
    )
    hostEntered,
    required TResult Function(
      String socketId,
      String roomCode,
      String hostId,
      LobbyRoomModel initialRoom,
      bool isDropIn,
    )
    joinEntered,
  }) {
    return hostEntered(
      socketId,
      roomCode,
      gameId,
      gameName,
      gameDescription,
      boardSize,
      isCTF,
      entryFee,
      friendsOnly,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String socketId,
      String roomCode,
      String gameId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      int entryFee,
      bool friendsOnly,
    )?
    hostEntered,
    TResult? Function(
      String socketId,
      String roomCode,
      String hostId,
      LobbyRoomModel initialRoom,
      bool isDropIn,
    )?
    joinEntered,
  }) {
    return hostEntered?.call(
      socketId,
      roomCode,
      gameId,
      gameName,
      gameDescription,
      boardSize,
      isCTF,
      entryFee,
      friendsOnly,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String socketId,
      String roomCode,
      String gameId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      int entryFee,
      bool friendsOnly,
    )?
    hostEntered,
    TResult Function(
      String socketId,
      String roomCode,
      String hostId,
      LobbyRoomModel initialRoom,
      bool isDropIn,
    )?
    joinEntered,
    required TResult orElse(),
  }) {
    if (hostEntered != null) {
      return hostEntered(
        socketId,
        roomCode,
        gameId,
        gameName,
        gameDescription,
        boardSize,
        isCTF,
        entryFee,
        friendsOnly,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CharacterCreationHostEntered value) hostEntered,
    required TResult Function(CharacterCreationJoinEntered value) joinEntered,
  }) {
    return hostEntered(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CharacterCreationHostEntered value)? hostEntered,
    TResult? Function(CharacterCreationJoinEntered value)? joinEntered,
  }) {
    return hostEntered?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CharacterCreationHostEntered value)? hostEntered,
    TResult Function(CharacterCreationJoinEntered value)? joinEntered,
    required TResult orElse(),
  }) {
    if (hostEntered != null) {
      return hostEntered(this);
    }
    return orElse();
  }
}

abstract class CharacterCreationHostEntered
    implements CharacterCreationEntryAppEvent {
  const factory CharacterCreationHostEntered({
    required final String socketId,
    required final String roomCode,
    required final String gameId,
    required final String gameName,
    required final String gameDescription,
    required final int boardSize,
    required final bool isCTF,
    final int entryFee,
    final bool friendsOnly,
  }) = _$CharacterCreationHostEnteredImpl;

  @override
  String get socketId;
  @override
  String get roomCode;
  String get gameId;
  String get gameName;
  String get gameDescription;
  int get boardSize;
  bool get isCTF;
  int get entryFee;
  bool get friendsOnly;

  /// Create a copy of CharacterCreationEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterCreationHostEnteredImplCopyWith<
    _$CharacterCreationHostEnteredImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CharacterCreationJoinEnteredImplCopyWith<$Res>
    implements $CharacterCreationEntryAppEventCopyWith<$Res> {
  factory _$$CharacterCreationJoinEnteredImplCopyWith(
    _$CharacterCreationJoinEnteredImpl value,
    $Res Function(_$CharacterCreationJoinEnteredImpl) then,
  ) = __$$CharacterCreationJoinEnteredImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String socketId,
    String roomCode,
    String hostId,
    LobbyRoomModel initialRoom,
    bool isDropIn,
  });
}

/// @nodoc
class __$$CharacterCreationJoinEnteredImplCopyWithImpl<$Res>
    extends
        _$CharacterCreationEntryAppEventCopyWithImpl<
          $Res,
          _$CharacterCreationJoinEnteredImpl
        >
    implements _$$CharacterCreationJoinEnteredImplCopyWith<$Res> {
  __$$CharacterCreationJoinEnteredImplCopyWithImpl(
    _$CharacterCreationJoinEnteredImpl _value,
    $Res Function(_$CharacterCreationJoinEnteredImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CharacterCreationEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? socketId = null,
    Object? roomCode = null,
    Object? hostId = null,
    Object? initialRoom = null,
    Object? isDropIn = null,
  }) {
    return _then(
      _$CharacterCreationJoinEnteredImpl(
        socketId: null == socketId
            ? _value.socketId
            : socketId // ignore: cast_nullable_to_non_nullable
                  as String,
        roomCode: null == roomCode
            ? _value.roomCode
            : roomCode // ignore: cast_nullable_to_non_nullable
                  as String,
        hostId: null == hostId
            ? _value.hostId
            : hostId // ignore: cast_nullable_to_non_nullable
                  as String,
        initialRoom: null == initialRoom
            ? _value.initialRoom
            : initialRoom // ignore: cast_nullable_to_non_nullable
                  as LobbyRoomModel,
        isDropIn: null == isDropIn
            ? _value.isDropIn
            : isDropIn // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$CharacterCreationJoinEnteredImpl
    implements CharacterCreationJoinEntered {
  const _$CharacterCreationJoinEnteredImpl({
    required this.socketId,
    required this.roomCode,
    required this.hostId,
    required this.initialRoom,
    this.isDropIn = false,
  });

  @override
  final String socketId;
  @override
  final String roomCode;
  @override
  final String hostId;
  @override
  final LobbyRoomModel initialRoom;
  @override
  @JsonKey()
  final bool isDropIn;

  @override
  String toString() {
    return 'CharacterCreationEntryAppEvent.joinEntered(socketId: $socketId, roomCode: $roomCode, hostId: $hostId, initialRoom: $initialRoom, isDropIn: $isDropIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterCreationJoinEnteredImpl &&
            (identical(other.socketId, socketId) ||
                other.socketId == socketId) &&
            (identical(other.roomCode, roomCode) ||
                other.roomCode == roomCode) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.initialRoom, initialRoom) ||
                other.initialRoom == initialRoom) &&
            (identical(other.isDropIn, isDropIn) ||
                other.isDropIn == isDropIn));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    socketId,
    roomCode,
    hostId,
    initialRoom,
    isDropIn,
  );

  /// Create a copy of CharacterCreationEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterCreationJoinEnteredImplCopyWith<
    _$CharacterCreationJoinEnteredImpl
  >
  get copyWith =>
      __$$CharacterCreationJoinEnteredImplCopyWithImpl<
        _$CharacterCreationJoinEnteredImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String socketId,
      String roomCode,
      String gameId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      int entryFee,
      bool friendsOnly,
    )
    hostEntered,
    required TResult Function(
      String socketId,
      String roomCode,
      String hostId,
      LobbyRoomModel initialRoom,
      bool isDropIn,
    )
    joinEntered,
  }) {
    return joinEntered(socketId, roomCode, hostId, initialRoom, isDropIn);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String socketId,
      String roomCode,
      String gameId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      int entryFee,
      bool friendsOnly,
    )?
    hostEntered,
    TResult? Function(
      String socketId,
      String roomCode,
      String hostId,
      LobbyRoomModel initialRoom,
      bool isDropIn,
    )?
    joinEntered,
  }) {
    return joinEntered?.call(socketId, roomCode, hostId, initialRoom, isDropIn);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String socketId,
      String roomCode,
      String gameId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      int entryFee,
      bool friendsOnly,
    )?
    hostEntered,
    TResult Function(
      String socketId,
      String roomCode,
      String hostId,
      LobbyRoomModel initialRoom,
      bool isDropIn,
    )?
    joinEntered,
    required TResult orElse(),
  }) {
    if (joinEntered != null) {
      return joinEntered(socketId, roomCode, hostId, initialRoom, isDropIn);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CharacterCreationHostEntered value) hostEntered,
    required TResult Function(CharacterCreationJoinEntered value) joinEntered,
  }) {
    return joinEntered(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CharacterCreationHostEntered value)? hostEntered,
    TResult? Function(CharacterCreationJoinEntered value)? joinEntered,
  }) {
    return joinEntered?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CharacterCreationHostEntered value)? hostEntered,
    TResult Function(CharacterCreationJoinEntered value)? joinEntered,
    required TResult orElse(),
  }) {
    if (joinEntered != null) {
      return joinEntered(this);
    }
    return orElse();
  }
}

abstract class CharacterCreationJoinEntered
    implements CharacterCreationEntryAppEvent {
  const factory CharacterCreationJoinEntered({
    required final String socketId,
    required final String roomCode,
    required final String hostId,
    required final LobbyRoomModel initialRoom,
    final bool isDropIn,
  }) = _$CharacterCreationJoinEnteredImpl;

  @override
  String get socketId;
  @override
  String get roomCode;
  String get hostId;
  LobbyRoomModel get initialRoom;
  bool get isDropIn;

  /// Create a copy of CharacterCreationEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterCreationJoinEnteredImplCopyWith<
    _$CharacterCreationJoinEnteredImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CharacterCreationCompletedAppEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({required TResult Function() ready}) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({TResult? Function()? ready}) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? ready,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CharacterCreationReady value) ready,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CharacterCreationReady value)? ready,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CharacterCreationReady value)? ready,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterCreationCompletedAppEventCopyWith<$Res> {
  factory $CharacterCreationCompletedAppEventCopyWith(
    CharacterCreationCompletedAppEvent value,
    $Res Function(CharacterCreationCompletedAppEvent) then,
  ) =
      _$CharacterCreationCompletedAppEventCopyWithImpl<
        $Res,
        CharacterCreationCompletedAppEvent
      >;
}

/// @nodoc
class _$CharacterCreationCompletedAppEventCopyWithImpl<
  $Res,
  $Val extends CharacterCreationCompletedAppEvent
>
    implements $CharacterCreationCompletedAppEventCopyWith<$Res> {
  _$CharacterCreationCompletedAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CharacterCreationCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CharacterCreationReadyImplCopyWith<$Res> {
  factory _$$CharacterCreationReadyImplCopyWith(
    _$CharacterCreationReadyImpl value,
    $Res Function(_$CharacterCreationReadyImpl) then,
  ) = __$$CharacterCreationReadyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CharacterCreationReadyImplCopyWithImpl<$Res>
    extends
        _$CharacterCreationCompletedAppEventCopyWithImpl<
          $Res,
          _$CharacterCreationReadyImpl
        >
    implements _$$CharacterCreationReadyImplCopyWith<$Res> {
  __$$CharacterCreationReadyImplCopyWithImpl(
    _$CharacterCreationReadyImpl _value,
    $Res Function(_$CharacterCreationReadyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CharacterCreationCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CharacterCreationReadyImpl implements CharacterCreationReady {
  const _$CharacterCreationReadyImpl();

  @override
  String toString() {
    return 'CharacterCreationCompletedAppEvent.ready()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterCreationReadyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({required TResult Function() ready}) {
    return ready();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({TResult? Function()? ready}) {
    return ready?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? ready,
    required TResult orElse(),
  }) {
    if (ready != null) {
      return ready();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CharacterCreationReady value) ready,
  }) {
    return ready(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CharacterCreationReady value)? ready,
  }) {
    return ready?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CharacterCreationReady value)? ready,
    required TResult orElse(),
  }) {
    if (ready != null) {
      return ready(this);
    }
    return orElse();
  }
}

abstract class CharacterCreationReady
    implements CharacterCreationCompletedAppEvent {
  const factory CharacterCreationReady() = _$CharacterCreationReadyImpl;
}

/// @nodoc
mixin _$CharacterCreationExitAppEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() exitRequested,
    required TResult Function(String roomCode) transitionToWaitingRoom,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? exitRequested,
    TResult? Function(String roomCode)? transitionToWaitingRoom,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? exitRequested,
    TResult Function(String roomCode)? transitionToWaitingRoom,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CharacterCreationExitRequested value)
    exitRequested,
    required TResult Function(CharacterCreationTransitionToWaitingRoom value)
    transitionToWaitingRoom,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CharacterCreationExitRequested value)? exitRequested,
    TResult? Function(CharacterCreationTransitionToWaitingRoom value)?
    transitionToWaitingRoom,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CharacterCreationExitRequested value)? exitRequested,
    TResult Function(CharacterCreationTransitionToWaitingRoom value)?
    transitionToWaitingRoom,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterCreationExitAppEventCopyWith<$Res> {
  factory $CharacterCreationExitAppEventCopyWith(
    CharacterCreationExitAppEvent value,
    $Res Function(CharacterCreationExitAppEvent) then,
  ) =
      _$CharacterCreationExitAppEventCopyWithImpl<
        $Res,
        CharacterCreationExitAppEvent
      >;
}

/// @nodoc
class _$CharacterCreationExitAppEventCopyWithImpl<
  $Res,
  $Val extends CharacterCreationExitAppEvent
>
    implements $CharacterCreationExitAppEventCopyWith<$Res> {
  _$CharacterCreationExitAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CharacterCreationExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CharacterCreationExitRequestedImplCopyWith<$Res> {
  factory _$$CharacterCreationExitRequestedImplCopyWith(
    _$CharacterCreationExitRequestedImpl value,
    $Res Function(_$CharacterCreationExitRequestedImpl) then,
  ) = __$$CharacterCreationExitRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CharacterCreationExitRequestedImplCopyWithImpl<$Res>
    extends
        _$CharacterCreationExitAppEventCopyWithImpl<
          $Res,
          _$CharacterCreationExitRequestedImpl
        >
    implements _$$CharacterCreationExitRequestedImplCopyWith<$Res> {
  __$$CharacterCreationExitRequestedImplCopyWithImpl(
    _$CharacterCreationExitRequestedImpl _value,
    $Res Function(_$CharacterCreationExitRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CharacterCreationExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CharacterCreationExitRequestedImpl
    implements CharacterCreationExitRequested {
  const _$CharacterCreationExitRequestedImpl();

  @override
  String toString() {
    return 'CharacterCreationExitAppEvent.exitRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterCreationExitRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() exitRequested,
    required TResult Function(String roomCode) transitionToWaitingRoom,
  }) {
    return exitRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? exitRequested,
    TResult? Function(String roomCode)? transitionToWaitingRoom,
  }) {
    return exitRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? exitRequested,
    TResult Function(String roomCode)? transitionToWaitingRoom,
    required TResult orElse(),
  }) {
    if (exitRequested != null) {
      return exitRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CharacterCreationExitRequested value)
    exitRequested,
    required TResult Function(CharacterCreationTransitionToWaitingRoom value)
    transitionToWaitingRoom,
  }) {
    return exitRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CharacterCreationExitRequested value)? exitRequested,
    TResult? Function(CharacterCreationTransitionToWaitingRoom value)?
    transitionToWaitingRoom,
  }) {
    return exitRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CharacterCreationExitRequested value)? exitRequested,
    TResult Function(CharacterCreationTransitionToWaitingRoom value)?
    transitionToWaitingRoom,
    required TResult orElse(),
  }) {
    if (exitRequested != null) {
      return exitRequested(this);
    }
    return orElse();
  }
}

abstract class CharacterCreationExitRequested
    implements CharacterCreationExitAppEvent {
  const factory CharacterCreationExitRequested() =
      _$CharacterCreationExitRequestedImpl;
}

/// @nodoc
abstract class _$$CharacterCreationTransitionToWaitingRoomImplCopyWith<$Res> {
  factory _$$CharacterCreationTransitionToWaitingRoomImplCopyWith(
    _$CharacterCreationTransitionToWaitingRoomImpl value,
    $Res Function(_$CharacterCreationTransitionToWaitingRoomImpl) then,
  ) = __$$CharacterCreationTransitionToWaitingRoomImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String roomCode});
}

/// @nodoc
class __$$CharacterCreationTransitionToWaitingRoomImplCopyWithImpl<$Res>
    extends
        _$CharacterCreationExitAppEventCopyWithImpl<
          $Res,
          _$CharacterCreationTransitionToWaitingRoomImpl
        >
    implements _$$CharacterCreationTransitionToWaitingRoomImplCopyWith<$Res> {
  __$$CharacterCreationTransitionToWaitingRoomImplCopyWithImpl(
    _$CharacterCreationTransitionToWaitingRoomImpl _value,
    $Res Function(_$CharacterCreationTransitionToWaitingRoomImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CharacterCreationExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomCode = null}) {
    return _then(
      _$CharacterCreationTransitionToWaitingRoomImpl(
        roomCode: null == roomCode
            ? _value.roomCode
            : roomCode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CharacterCreationTransitionToWaitingRoomImpl
    implements CharacterCreationTransitionToWaitingRoom {
  const _$CharacterCreationTransitionToWaitingRoomImpl({
    required this.roomCode,
  });

  @override
  final String roomCode;

  @override
  String toString() {
    return 'CharacterCreationExitAppEvent.transitionToWaitingRoom(roomCode: $roomCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterCreationTransitionToWaitingRoomImpl &&
            (identical(other.roomCode, roomCode) ||
                other.roomCode == roomCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomCode);

  /// Create a copy of CharacterCreationExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterCreationTransitionToWaitingRoomImplCopyWith<
    _$CharacterCreationTransitionToWaitingRoomImpl
  >
  get copyWith =>
      __$$CharacterCreationTransitionToWaitingRoomImplCopyWithImpl<
        _$CharacterCreationTransitionToWaitingRoomImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() exitRequested,
    required TResult Function(String roomCode) transitionToWaitingRoom,
  }) {
    return transitionToWaitingRoom(roomCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? exitRequested,
    TResult? Function(String roomCode)? transitionToWaitingRoom,
  }) {
    return transitionToWaitingRoom?.call(roomCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? exitRequested,
    TResult Function(String roomCode)? transitionToWaitingRoom,
    required TResult orElse(),
  }) {
    if (transitionToWaitingRoom != null) {
      return transitionToWaitingRoom(roomCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CharacterCreationExitRequested value)
    exitRequested,
    required TResult Function(CharacterCreationTransitionToWaitingRoom value)
    transitionToWaitingRoom,
  }) {
    return transitionToWaitingRoom(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CharacterCreationExitRequested value)? exitRequested,
    TResult? Function(CharacterCreationTransitionToWaitingRoom value)?
    transitionToWaitingRoom,
  }) {
    return transitionToWaitingRoom?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CharacterCreationExitRequested value)? exitRequested,
    TResult Function(CharacterCreationTransitionToWaitingRoom value)?
    transitionToWaitingRoom,
    required TResult orElse(),
  }) {
    if (transitionToWaitingRoom != null) {
      return transitionToWaitingRoom(this);
    }
    return orElse();
  }
}

abstract class CharacterCreationTransitionToWaitingRoom
    implements CharacterCreationExitAppEvent {
  const factory CharacterCreationTransitionToWaitingRoom({
    required final String roomCode,
  }) = _$CharacterCreationTransitionToWaitingRoomImpl;

  String get roomCode;

  /// Create a copy of CharacterCreationExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterCreationTransitionToWaitingRoomImplCopyWith<
    _$CharacterCreationTransitionToWaitingRoomImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
