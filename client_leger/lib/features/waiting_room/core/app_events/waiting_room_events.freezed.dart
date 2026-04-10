// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waiting_room_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WaitingRoomEntryAppEvent {
  String get roomId => throw _privateConstructorUsedError;
  String get hostId => throw _privateConstructorUsedError;
  String get socketId => throw _privateConstructorUsedError;
  String get gameName => throw _privateConstructorUsedError;
  String get gameDescription => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      bool friendsOnly,
    )
    enteredAsHost,
    required TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      LobbyRoomModel initialRoom,
    )
    enteredAsJoin,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      bool friendsOnly,
    )?
    enteredAsHost,
    TResult? Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      LobbyRoomModel initialRoom,
    )?
    enteredAsJoin,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      bool friendsOnly,
    )?
    enteredAsHost,
    TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      LobbyRoomModel initialRoom,
    )?
    enteredAsJoin,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WaitingRoomEnteredAsHost value) enteredAsHost,
    required TResult Function(WaitingRoomEnteredAsJoin value) enteredAsJoin,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WaitingRoomEnteredAsHost value)? enteredAsHost,
    TResult? Function(WaitingRoomEnteredAsJoin value)? enteredAsJoin,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WaitingRoomEnteredAsHost value)? enteredAsHost,
    TResult Function(WaitingRoomEnteredAsJoin value)? enteredAsJoin,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of WaitingRoomEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaitingRoomEntryAppEventCopyWith<WaitingRoomEntryAppEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaitingRoomEntryAppEventCopyWith<$Res> {
  factory $WaitingRoomEntryAppEventCopyWith(
    WaitingRoomEntryAppEvent value,
    $Res Function(WaitingRoomEntryAppEvent) then,
  ) = _$WaitingRoomEntryAppEventCopyWithImpl<$Res, WaitingRoomEntryAppEvent>;
  @useResult
  $Res call({
    String roomId,
    String hostId,
    String socketId,
    String gameName,
    String gameDescription,
  });
}

/// @nodoc
class _$WaitingRoomEntryAppEventCopyWithImpl<
  $Res,
  $Val extends WaitingRoomEntryAppEvent
>
    implements $WaitingRoomEntryAppEventCopyWith<$Res> {
  _$WaitingRoomEntryAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaitingRoomEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? hostId = null,
    Object? socketId = null,
    Object? gameName = null,
    Object? gameDescription = null,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            hostId: null == hostId
                ? _value.hostId
                : hostId // ignore: cast_nullable_to_non_nullable
                      as String,
            socketId: null == socketId
                ? _value.socketId
                : socketId // ignore: cast_nullable_to_non_nullable
                      as String,
            gameName: null == gameName
                ? _value.gameName
                : gameName // ignore: cast_nullable_to_non_nullable
                      as String,
            gameDescription: null == gameDescription
                ? _value.gameDescription
                : gameDescription // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WaitingRoomEnteredAsHostImplCopyWith<$Res>
    implements $WaitingRoomEntryAppEventCopyWith<$Res> {
  factory _$$WaitingRoomEnteredAsHostImplCopyWith(
    _$WaitingRoomEnteredAsHostImpl value,
    $Res Function(_$WaitingRoomEnteredAsHostImpl) then,
  ) = __$$WaitingRoomEnteredAsHostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roomId,
    String hostId,
    String socketId,
    String gameName,
    String gameDescription,
    int boardSize,
    bool isCTF,
    bool friendsOnly,
  });
}

/// @nodoc
class __$$WaitingRoomEnteredAsHostImplCopyWithImpl<$Res>
    extends
        _$WaitingRoomEntryAppEventCopyWithImpl<
          $Res,
          _$WaitingRoomEnteredAsHostImpl
        >
    implements _$$WaitingRoomEnteredAsHostImplCopyWith<$Res> {
  __$$WaitingRoomEnteredAsHostImplCopyWithImpl(
    _$WaitingRoomEnteredAsHostImpl _value,
    $Res Function(_$WaitingRoomEnteredAsHostImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaitingRoomEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? hostId = null,
    Object? socketId = null,
    Object? gameName = null,
    Object? gameDescription = null,
    Object? boardSize = null,
    Object? isCTF = null,
    Object? friendsOnly = null,
  }) {
    return _then(
      _$WaitingRoomEnteredAsHostImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        hostId: null == hostId
            ? _value.hostId
            : hostId // ignore: cast_nullable_to_non_nullable
                  as String,
        socketId: null == socketId
            ? _value.socketId
            : socketId // ignore: cast_nullable_to_non_nullable
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
        friendsOnly: null == friendsOnly
            ? _value.friendsOnly
            : friendsOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$WaitingRoomEnteredAsHostImpl implements WaitingRoomEnteredAsHost {
  const _$WaitingRoomEnteredAsHostImpl({
    required this.roomId,
    required this.hostId,
    required this.socketId,
    required this.gameName,
    required this.gameDescription,
    required this.boardSize,
    required this.isCTF,
    this.friendsOnly = false,
  });

  @override
  final String roomId;
  @override
  final String hostId;
  @override
  final String socketId;
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
  final bool friendsOnly;

  @override
  String toString() {
    return 'WaitingRoomEntryAppEvent.enteredAsHost(roomId: $roomId, hostId: $hostId, socketId: $socketId, gameName: $gameName, gameDescription: $gameDescription, boardSize: $boardSize, isCTF: $isCTF, friendsOnly: $friendsOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitingRoomEnteredAsHostImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.socketId, socketId) ||
                other.socketId == socketId) &&
            (identical(other.gameName, gameName) ||
                other.gameName == gameName) &&
            (identical(other.gameDescription, gameDescription) ||
                other.gameDescription == gameDescription) &&
            (identical(other.boardSize, boardSize) ||
                other.boardSize == boardSize) &&
            (identical(other.isCTF, isCTF) || other.isCTF == isCTF) &&
            (identical(other.friendsOnly, friendsOnly) ||
                other.friendsOnly == friendsOnly));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    roomId,
    hostId,
    socketId,
    gameName,
    gameDescription,
    boardSize,
    isCTF,
    friendsOnly,
  );

  /// Create a copy of WaitingRoomEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitingRoomEnteredAsHostImplCopyWith<_$WaitingRoomEnteredAsHostImpl>
  get copyWith =>
      __$$WaitingRoomEnteredAsHostImplCopyWithImpl<
        _$WaitingRoomEnteredAsHostImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      bool friendsOnly,
    )
    enteredAsHost,
    required TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      LobbyRoomModel initialRoom,
    )
    enteredAsJoin,
  }) {
    return enteredAsHost(
      roomId,
      hostId,
      socketId,
      gameName,
      gameDescription,
      boardSize,
      isCTF,
      friendsOnly,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      bool friendsOnly,
    )?
    enteredAsHost,
    TResult? Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      LobbyRoomModel initialRoom,
    )?
    enteredAsJoin,
  }) {
    return enteredAsHost?.call(
      roomId,
      hostId,
      socketId,
      gameName,
      gameDescription,
      boardSize,
      isCTF,
      friendsOnly,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      bool friendsOnly,
    )?
    enteredAsHost,
    TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      LobbyRoomModel initialRoom,
    )?
    enteredAsJoin,
    required TResult orElse(),
  }) {
    if (enteredAsHost != null) {
      return enteredAsHost(
        roomId,
        hostId,
        socketId,
        gameName,
        gameDescription,
        boardSize,
        isCTF,
        friendsOnly,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WaitingRoomEnteredAsHost value) enteredAsHost,
    required TResult Function(WaitingRoomEnteredAsJoin value) enteredAsJoin,
  }) {
    return enteredAsHost(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WaitingRoomEnteredAsHost value)? enteredAsHost,
    TResult? Function(WaitingRoomEnteredAsJoin value)? enteredAsJoin,
  }) {
    return enteredAsHost?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WaitingRoomEnteredAsHost value)? enteredAsHost,
    TResult Function(WaitingRoomEnteredAsJoin value)? enteredAsJoin,
    required TResult orElse(),
  }) {
    if (enteredAsHost != null) {
      return enteredAsHost(this);
    }
    return orElse();
  }
}

abstract class WaitingRoomEnteredAsHost implements WaitingRoomEntryAppEvent {
  const factory WaitingRoomEnteredAsHost({
    required final String roomId,
    required final String hostId,
    required final String socketId,
    required final String gameName,
    required final String gameDescription,
    required final int boardSize,
    required final bool isCTF,
    final bool friendsOnly,
  }) = _$WaitingRoomEnteredAsHostImpl;

  @override
  String get roomId;
  @override
  String get hostId;
  @override
  String get socketId;
  @override
  String get gameName;
  @override
  String get gameDescription;
  int get boardSize;
  bool get isCTF;
  bool get friendsOnly;

  /// Create a copy of WaitingRoomEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaitingRoomEnteredAsHostImplCopyWith<_$WaitingRoomEnteredAsHostImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WaitingRoomEnteredAsJoinImplCopyWith<$Res>
    implements $WaitingRoomEntryAppEventCopyWith<$Res> {
  factory _$$WaitingRoomEnteredAsJoinImplCopyWith(
    _$WaitingRoomEnteredAsJoinImpl value,
    $Res Function(_$WaitingRoomEnteredAsJoinImpl) then,
  ) = __$$WaitingRoomEnteredAsJoinImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roomId,
    String hostId,
    String socketId,
    String gameName,
    String gameDescription,
    LobbyRoomModel initialRoom,
  });
}

/// @nodoc
class __$$WaitingRoomEnteredAsJoinImplCopyWithImpl<$Res>
    extends
        _$WaitingRoomEntryAppEventCopyWithImpl<
          $Res,
          _$WaitingRoomEnteredAsJoinImpl
        >
    implements _$$WaitingRoomEnteredAsJoinImplCopyWith<$Res> {
  __$$WaitingRoomEnteredAsJoinImplCopyWithImpl(
    _$WaitingRoomEnteredAsJoinImpl _value,
    $Res Function(_$WaitingRoomEnteredAsJoinImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaitingRoomEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? hostId = null,
    Object? socketId = null,
    Object? gameName = null,
    Object? gameDescription = null,
    Object? initialRoom = null,
  }) {
    return _then(
      _$WaitingRoomEnteredAsJoinImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        hostId: null == hostId
            ? _value.hostId
            : hostId // ignore: cast_nullable_to_non_nullable
                  as String,
        socketId: null == socketId
            ? _value.socketId
            : socketId // ignore: cast_nullable_to_non_nullable
                  as String,
        gameName: null == gameName
            ? _value.gameName
            : gameName // ignore: cast_nullable_to_non_nullable
                  as String,
        gameDescription: null == gameDescription
            ? _value.gameDescription
            : gameDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        initialRoom: null == initialRoom
            ? _value.initialRoom
            : initialRoom // ignore: cast_nullable_to_non_nullable
                  as LobbyRoomModel,
      ),
    );
  }
}

/// @nodoc

class _$WaitingRoomEnteredAsJoinImpl implements WaitingRoomEnteredAsJoin {
  const _$WaitingRoomEnteredAsJoinImpl({
    required this.roomId,
    required this.hostId,
    required this.socketId,
    required this.gameName,
    required this.gameDescription,
    required this.initialRoom,
  });

  @override
  final String roomId;
  @override
  final String hostId;
  @override
  final String socketId;
  @override
  final String gameName;
  @override
  final String gameDescription;
  @override
  final LobbyRoomModel initialRoom;

  @override
  String toString() {
    return 'WaitingRoomEntryAppEvent.enteredAsJoin(roomId: $roomId, hostId: $hostId, socketId: $socketId, gameName: $gameName, gameDescription: $gameDescription, initialRoom: $initialRoom)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitingRoomEnteredAsJoinImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.socketId, socketId) ||
                other.socketId == socketId) &&
            (identical(other.gameName, gameName) ||
                other.gameName == gameName) &&
            (identical(other.gameDescription, gameDescription) ||
                other.gameDescription == gameDescription) &&
            (identical(other.initialRoom, initialRoom) ||
                other.initialRoom == initialRoom));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    roomId,
    hostId,
    socketId,
    gameName,
    gameDescription,
    initialRoom,
  );

  /// Create a copy of WaitingRoomEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitingRoomEnteredAsJoinImplCopyWith<_$WaitingRoomEnteredAsJoinImpl>
  get copyWith =>
      __$$WaitingRoomEnteredAsJoinImplCopyWithImpl<
        _$WaitingRoomEnteredAsJoinImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      bool friendsOnly,
    )
    enteredAsHost,
    required TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      LobbyRoomModel initialRoom,
    )
    enteredAsJoin,
  }) {
    return enteredAsJoin(
      roomId,
      hostId,
      socketId,
      gameName,
      gameDescription,
      initialRoom,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      bool friendsOnly,
    )?
    enteredAsHost,
    TResult? Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      LobbyRoomModel initialRoom,
    )?
    enteredAsJoin,
  }) {
    return enteredAsJoin?.call(
      roomId,
      hostId,
      socketId,
      gameName,
      gameDescription,
      initialRoom,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      int boardSize,
      bool isCTF,
      bool friendsOnly,
    )?
    enteredAsHost,
    TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      LobbyRoomModel initialRoom,
    )?
    enteredAsJoin,
    required TResult orElse(),
  }) {
    if (enteredAsJoin != null) {
      return enteredAsJoin(
        roomId,
        hostId,
        socketId,
        gameName,
        gameDescription,
        initialRoom,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WaitingRoomEnteredAsHost value) enteredAsHost,
    required TResult Function(WaitingRoomEnteredAsJoin value) enteredAsJoin,
  }) {
    return enteredAsJoin(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WaitingRoomEnteredAsHost value)? enteredAsHost,
    TResult? Function(WaitingRoomEnteredAsJoin value)? enteredAsJoin,
  }) {
    return enteredAsJoin?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WaitingRoomEnteredAsHost value)? enteredAsHost,
    TResult Function(WaitingRoomEnteredAsJoin value)? enteredAsJoin,
    required TResult orElse(),
  }) {
    if (enteredAsJoin != null) {
      return enteredAsJoin(this);
    }
    return orElse();
  }
}

abstract class WaitingRoomEnteredAsJoin implements WaitingRoomEntryAppEvent {
  const factory WaitingRoomEnteredAsJoin({
    required final String roomId,
    required final String hostId,
    required final String socketId,
    required final String gameName,
    required final String gameDescription,
    required final LobbyRoomModel initialRoom,
  }) = _$WaitingRoomEnteredAsJoinImpl;

  @override
  String get roomId;
  @override
  String get hostId;
  @override
  String get socketId;
  @override
  String get gameName;
  @override
  String get gameDescription;
  LobbyRoomModel get initialRoom;

  /// Create a copy of WaitingRoomEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaitingRoomEnteredAsJoinImplCopyWith<_$WaitingRoomEnteredAsJoinImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WaitingRoomCompletedAppEvent {}

/// @nodoc
abstract class $WaitingRoomCompletedAppEventCopyWith<$Res> {
  factory $WaitingRoomCompletedAppEventCopyWith(
    WaitingRoomCompletedAppEvent value,
    $Res Function(WaitingRoomCompletedAppEvent) then,
  ) =
      _$WaitingRoomCompletedAppEventCopyWithImpl<
        $Res,
        WaitingRoomCompletedAppEvent
      >;
}

/// @nodoc
class _$WaitingRoomCompletedAppEventCopyWithImpl<
  $Res,
  $Val extends WaitingRoomCompletedAppEvent
>
    implements $WaitingRoomCompletedAppEventCopyWith<$Res> {
  _$WaitingRoomCompletedAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaitingRoomCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$WaitingRoomCompletedImplCopyWith<$Res> {
  factory _$$WaitingRoomCompletedImplCopyWith(
    _$WaitingRoomCompletedImpl value,
    $Res Function(_$WaitingRoomCompletedImpl) then,
  ) = __$$WaitingRoomCompletedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$WaitingRoomCompletedImplCopyWithImpl<$Res>
    extends
        _$WaitingRoomCompletedAppEventCopyWithImpl<
          $Res,
          _$WaitingRoomCompletedImpl
        >
    implements _$$WaitingRoomCompletedImplCopyWith<$Res> {
  __$$WaitingRoomCompletedImplCopyWithImpl(
    _$WaitingRoomCompletedImpl _value,
    $Res Function(_$WaitingRoomCompletedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaitingRoomCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$WaitingRoomCompletedImpl implements WaitingRoomCompleted {
  const _$WaitingRoomCompletedImpl();

  @override
  String toString() {
    return 'WaitingRoomCompletedAppEvent()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitingRoomCompletedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class WaitingRoomCompleted implements WaitingRoomCompletedAppEvent {
  const factory WaitingRoomCompleted() = _$WaitingRoomCompletedImpl;
}

/// @nodoc
mixin _$WaitingRoomExitAppEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() leaveRequested,
    required TResult Function(WaitingRoomLeaveReason reason) systemLeave,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? leaveRequested,
    TResult? Function(WaitingRoomLeaveReason reason)? systemLeave,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? leaveRequested,
    TResult Function(WaitingRoomLeaveReason reason)? systemLeave,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WaitingRoomLeaveRequested value) leaveRequested,
    required TResult Function(WaitingRoomSystemLeave value) systemLeave,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WaitingRoomLeaveRequested value)? leaveRequested,
    TResult? Function(WaitingRoomSystemLeave value)? systemLeave,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WaitingRoomLeaveRequested value)? leaveRequested,
    TResult Function(WaitingRoomSystemLeave value)? systemLeave,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaitingRoomExitAppEventCopyWith<$Res> {
  factory $WaitingRoomExitAppEventCopyWith(
    WaitingRoomExitAppEvent value,
    $Res Function(WaitingRoomExitAppEvent) then,
  ) = _$WaitingRoomExitAppEventCopyWithImpl<$Res, WaitingRoomExitAppEvent>;
}

/// @nodoc
class _$WaitingRoomExitAppEventCopyWithImpl<
  $Res,
  $Val extends WaitingRoomExitAppEvent
>
    implements $WaitingRoomExitAppEventCopyWith<$Res> {
  _$WaitingRoomExitAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaitingRoomExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$WaitingRoomLeaveRequestedImplCopyWith<$Res> {
  factory _$$WaitingRoomLeaveRequestedImplCopyWith(
    _$WaitingRoomLeaveRequestedImpl value,
    $Res Function(_$WaitingRoomLeaveRequestedImpl) then,
  ) = __$$WaitingRoomLeaveRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$WaitingRoomLeaveRequestedImplCopyWithImpl<$Res>
    extends
        _$WaitingRoomExitAppEventCopyWithImpl<
          $Res,
          _$WaitingRoomLeaveRequestedImpl
        >
    implements _$$WaitingRoomLeaveRequestedImplCopyWith<$Res> {
  __$$WaitingRoomLeaveRequestedImplCopyWithImpl(
    _$WaitingRoomLeaveRequestedImpl _value,
    $Res Function(_$WaitingRoomLeaveRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaitingRoomExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$WaitingRoomLeaveRequestedImpl implements WaitingRoomLeaveRequested {
  const _$WaitingRoomLeaveRequestedImpl();

  @override
  String toString() {
    return 'WaitingRoomExitAppEvent.leaveRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitingRoomLeaveRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() leaveRequested,
    required TResult Function(WaitingRoomLeaveReason reason) systemLeave,
  }) {
    return leaveRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? leaveRequested,
    TResult? Function(WaitingRoomLeaveReason reason)? systemLeave,
  }) {
    return leaveRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? leaveRequested,
    TResult Function(WaitingRoomLeaveReason reason)? systemLeave,
    required TResult orElse(),
  }) {
    if (leaveRequested != null) {
      return leaveRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WaitingRoomLeaveRequested value) leaveRequested,
    required TResult Function(WaitingRoomSystemLeave value) systemLeave,
  }) {
    return leaveRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WaitingRoomLeaveRequested value)? leaveRequested,
    TResult? Function(WaitingRoomSystemLeave value)? systemLeave,
  }) {
    return leaveRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WaitingRoomLeaveRequested value)? leaveRequested,
    TResult Function(WaitingRoomSystemLeave value)? systemLeave,
    required TResult orElse(),
  }) {
    if (leaveRequested != null) {
      return leaveRequested(this);
    }
    return orElse();
  }
}

abstract class WaitingRoomLeaveRequested implements WaitingRoomExitAppEvent {
  const factory WaitingRoomLeaveRequested() = _$WaitingRoomLeaveRequestedImpl;
}

/// @nodoc
abstract class _$$WaitingRoomSystemLeaveImplCopyWith<$Res> {
  factory _$$WaitingRoomSystemLeaveImplCopyWith(
    _$WaitingRoomSystemLeaveImpl value,
    $Res Function(_$WaitingRoomSystemLeaveImpl) then,
  ) = __$$WaitingRoomSystemLeaveImplCopyWithImpl<$Res>;
  @useResult
  $Res call({WaitingRoomLeaveReason reason});
}

/// @nodoc
class __$$WaitingRoomSystemLeaveImplCopyWithImpl<$Res>
    extends
        _$WaitingRoomExitAppEventCopyWithImpl<
          $Res,
          _$WaitingRoomSystemLeaveImpl
        >
    implements _$$WaitingRoomSystemLeaveImplCopyWith<$Res> {
  __$$WaitingRoomSystemLeaveImplCopyWithImpl(
    _$WaitingRoomSystemLeaveImpl _value,
    $Res Function(_$WaitingRoomSystemLeaveImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaitingRoomExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null}) {
    return _then(
      _$WaitingRoomSystemLeaveImpl(
        null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as WaitingRoomLeaveReason,
      ),
    );
  }
}

/// @nodoc

class _$WaitingRoomSystemLeaveImpl implements WaitingRoomSystemLeave {
  const _$WaitingRoomSystemLeaveImpl(this.reason);

  @override
  final WaitingRoomLeaveReason reason;

  @override
  String toString() {
    return 'WaitingRoomExitAppEvent.systemLeave(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitingRoomSystemLeaveImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of WaitingRoomExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitingRoomSystemLeaveImplCopyWith<_$WaitingRoomSystemLeaveImpl>
  get copyWith =>
      __$$WaitingRoomSystemLeaveImplCopyWithImpl<_$WaitingRoomSystemLeaveImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() leaveRequested,
    required TResult Function(WaitingRoomLeaveReason reason) systemLeave,
  }) {
    return systemLeave(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? leaveRequested,
    TResult? Function(WaitingRoomLeaveReason reason)? systemLeave,
  }) {
    return systemLeave?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? leaveRequested,
    TResult Function(WaitingRoomLeaveReason reason)? systemLeave,
    required TResult orElse(),
  }) {
    if (systemLeave != null) {
      return systemLeave(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WaitingRoomLeaveRequested value) leaveRequested,
    required TResult Function(WaitingRoomSystemLeave value) systemLeave,
  }) {
    return systemLeave(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WaitingRoomLeaveRequested value)? leaveRequested,
    TResult? Function(WaitingRoomSystemLeave value)? systemLeave,
  }) {
    return systemLeave?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WaitingRoomLeaveRequested value)? leaveRequested,
    TResult Function(WaitingRoomSystemLeave value)? systemLeave,
    required TResult orElse(),
  }) {
    if (systemLeave != null) {
      return systemLeave(this);
    }
    return orElse();
  }
}

abstract class WaitingRoomSystemLeave implements WaitingRoomExitAppEvent {
  const factory WaitingRoomSystemLeave(final WaitingRoomLeaveReason reason) =
      _$WaitingRoomSystemLeaveImpl;

  WaitingRoomLeaveReason get reason;

  /// Create a copy of WaitingRoomExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaitingRoomSystemLeaveImplCopyWith<_$WaitingRoomSystemLeaveImpl>
  get copyWith => throw _privateConstructorUsedError;
}
