// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_session_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameSessionEntryAppEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String roomId,
      String gameId,
      String socketId,
      String gameName,
      String gameDescription,
    )
    startRequested,
    required TResult Function(
      String roomId,
      String gameId,
      String socketId,
      bool isHost,
      String gameRoomHostId,
      String gameName,
      String gameDescription,
    )
    startConfirmed,
    required TResult Function() loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String roomId,
      String gameId,
      String socketId,
      String gameName,
      String gameDescription,
    )?
    startRequested,
    TResult? Function(
      String roomId,
      String gameId,
      String socketId,
      bool isHost,
      String gameRoomHostId,
      String gameName,
      String gameDescription,
    )?
    startConfirmed,
    TResult? Function()? loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String roomId,
      String gameId,
      String socketId,
      String gameName,
      String gameDescription,
    )?
    startRequested,
    TResult Function(
      String roomId,
      String gameId,
      String socketId,
      bool isHost,
      String gameRoomHostId,
      String gameName,
      String gameDescription,
    )?
    startConfirmed,
    TResult Function()? loaded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StartGameSessionRequestedCommand value)
    startRequested,
    required TResult Function(GameSessionStartConfirmedEvent value)
    startConfirmed,
    required TResult Function(GameSessionLoadedEvent value) loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StartGameSessionRequestedCommand value)? startRequested,
    TResult? Function(GameSessionStartConfirmedEvent value)? startConfirmed,
    TResult? Function(GameSessionLoadedEvent value)? loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StartGameSessionRequestedCommand value)? startRequested,
    TResult Function(GameSessionStartConfirmedEvent value)? startConfirmed,
    TResult Function(GameSessionLoadedEvent value)? loaded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSessionEntryAppEventCopyWith<$Res> {
  factory $GameSessionEntryAppEventCopyWith(
    GameSessionEntryAppEvent value,
    $Res Function(GameSessionEntryAppEvent) then,
  ) = _$GameSessionEntryAppEventCopyWithImpl<$Res, GameSessionEntryAppEvent>;
}

/// @nodoc
class _$GameSessionEntryAppEventCopyWithImpl<
  $Res,
  $Val extends GameSessionEntryAppEvent
>
    implements $GameSessionEntryAppEventCopyWith<$Res> {
  _$GameSessionEntryAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameSessionEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$StartGameSessionRequestedCommandImplCopyWith<$Res> {
  factory _$$StartGameSessionRequestedCommandImplCopyWith(
    _$StartGameSessionRequestedCommandImpl value,
    $Res Function(_$StartGameSessionRequestedCommandImpl) then,
  ) = __$$StartGameSessionRequestedCommandImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String roomId,
    String gameId,
    String socketId,
    String gameName,
    String gameDescription,
  });
}

/// @nodoc
class __$$StartGameSessionRequestedCommandImplCopyWithImpl<$Res>
    extends
        _$GameSessionEntryAppEventCopyWithImpl<
          $Res,
          _$StartGameSessionRequestedCommandImpl
        >
    implements _$$StartGameSessionRequestedCommandImplCopyWith<$Res> {
  __$$StartGameSessionRequestedCommandImplCopyWithImpl(
    _$StartGameSessionRequestedCommandImpl _value,
    $Res Function(_$StartGameSessionRequestedCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSessionEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? gameId = null,
    Object? socketId = null,
    Object? gameName = null,
    Object? gameDescription = null,
  }) {
    return _then(
      _$StartGameSessionRequestedCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc

class _$StartGameSessionRequestedCommandImpl
    implements StartGameSessionRequestedCommand {
  const _$StartGameSessionRequestedCommandImpl({
    required this.roomId,
    required this.gameId,
    required this.socketId,
    required this.gameName,
    required this.gameDescription,
  });

  @override
  final String roomId;
  @override
  final String gameId;
  @override
  final String socketId;
  @override
  final String gameName;
  @override
  final String gameDescription;

  @override
  String toString() {
    return 'GameSessionEntryAppEvent.startRequested(roomId: $roomId, gameId: $gameId, socketId: $socketId, gameName: $gameName, gameDescription: $gameDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartGameSessionRequestedCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.socketId, socketId) ||
                other.socketId == socketId) &&
            (identical(other.gameName, gameName) ||
                other.gameName == gameName) &&
            (identical(other.gameDescription, gameDescription) ||
                other.gameDescription == gameDescription));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    roomId,
    gameId,
    socketId,
    gameName,
    gameDescription,
  );

  /// Create a copy of GameSessionEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartGameSessionRequestedCommandImplCopyWith<
    _$StartGameSessionRequestedCommandImpl
  >
  get copyWith =>
      __$$StartGameSessionRequestedCommandImplCopyWithImpl<
        _$StartGameSessionRequestedCommandImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String roomId,
      String gameId,
      String socketId,
      String gameName,
      String gameDescription,
    )
    startRequested,
    required TResult Function(
      String roomId,
      String gameId,
      String socketId,
      bool isHost,
      String gameRoomHostId,
      String gameName,
      String gameDescription,
    )
    startConfirmed,
    required TResult Function() loaded,
  }) {
    return startRequested(roomId, gameId, socketId, gameName, gameDescription);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String roomId,
      String gameId,
      String socketId,
      String gameName,
      String gameDescription,
    )?
    startRequested,
    TResult? Function(
      String roomId,
      String gameId,
      String socketId,
      bool isHost,
      String gameRoomHostId,
      String gameName,
      String gameDescription,
    )?
    startConfirmed,
    TResult? Function()? loaded,
  }) {
    return startRequested?.call(
      roomId,
      gameId,
      socketId,
      gameName,
      gameDescription,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String roomId,
      String gameId,
      String socketId,
      String gameName,
      String gameDescription,
    )?
    startRequested,
    TResult Function(
      String roomId,
      String gameId,
      String socketId,
      bool isHost,
      String gameRoomHostId,
      String gameName,
      String gameDescription,
    )?
    startConfirmed,
    TResult Function()? loaded,
    required TResult orElse(),
  }) {
    if (startRequested != null) {
      return startRequested(
        roomId,
        gameId,
        socketId,
        gameName,
        gameDescription,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StartGameSessionRequestedCommand value)
    startRequested,
    required TResult Function(GameSessionStartConfirmedEvent value)
    startConfirmed,
    required TResult Function(GameSessionLoadedEvent value) loaded,
  }) {
    return startRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StartGameSessionRequestedCommand value)? startRequested,
    TResult? Function(GameSessionStartConfirmedEvent value)? startConfirmed,
    TResult? Function(GameSessionLoadedEvent value)? loaded,
  }) {
    return startRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StartGameSessionRequestedCommand value)? startRequested,
    TResult Function(GameSessionStartConfirmedEvent value)? startConfirmed,
    TResult Function(GameSessionLoadedEvent value)? loaded,
    required TResult orElse(),
  }) {
    if (startRequested != null) {
      return startRequested(this);
    }
    return orElse();
  }
}

abstract class StartGameSessionRequestedCommand
    implements GameSessionEntryAppEvent {
  const factory StartGameSessionRequestedCommand({
    required final String roomId,
    required final String gameId,
    required final String socketId,
    required final String gameName,
    required final String gameDescription,
  }) = _$StartGameSessionRequestedCommandImpl;

  String get roomId;
  String get gameId;
  String get socketId;
  String get gameName;
  String get gameDescription;

  /// Create a copy of GameSessionEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartGameSessionRequestedCommandImplCopyWith<
    _$StartGameSessionRequestedCommandImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GameSessionStartConfirmedEventImplCopyWith<$Res> {
  factory _$$GameSessionStartConfirmedEventImplCopyWith(
    _$GameSessionStartConfirmedEventImpl value,
    $Res Function(_$GameSessionStartConfirmedEventImpl) then,
  ) = __$$GameSessionStartConfirmedEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String roomId,
    String gameId,
    String socketId,
    bool isHost,
    String gameRoomHostId,
    String gameName,
    String gameDescription,
  });
}

/// @nodoc
class __$$GameSessionStartConfirmedEventImplCopyWithImpl<$Res>
    extends
        _$GameSessionEntryAppEventCopyWithImpl<
          $Res,
          _$GameSessionStartConfirmedEventImpl
        >
    implements _$$GameSessionStartConfirmedEventImplCopyWith<$Res> {
  __$$GameSessionStartConfirmedEventImplCopyWithImpl(
    _$GameSessionStartConfirmedEventImpl _value,
    $Res Function(_$GameSessionStartConfirmedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSessionEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? gameId = null,
    Object? socketId = null,
    Object? isHost = null,
    Object? gameRoomHostId = null,
    Object? gameName = null,
    Object? gameDescription = null,
  }) {
    return _then(
      _$GameSessionStartConfirmedEventImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String,
        socketId: null == socketId
            ? _value.socketId
            : socketId // ignore: cast_nullable_to_non_nullable
                  as String,
        isHost: null == isHost
            ? _value.isHost
            : isHost // ignore: cast_nullable_to_non_nullable
                  as bool,
        gameRoomHostId: null == gameRoomHostId
            ? _value.gameRoomHostId
            : gameRoomHostId // ignore: cast_nullable_to_non_nullable
                  as String,
        gameName: null == gameName
            ? _value.gameName
            : gameName // ignore: cast_nullable_to_non_nullable
                  as String,
        gameDescription: null == gameDescription
            ? _value.gameDescription
            : gameDescription // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GameSessionStartConfirmedEventImpl
    implements GameSessionStartConfirmedEvent {
  const _$GameSessionStartConfirmedEventImpl({
    required this.roomId,
    required this.gameId,
    required this.socketId,
    required this.isHost,
    required this.gameRoomHostId,
    required this.gameName,
    required this.gameDescription,
  });

  @override
  final String roomId;
  @override
  final String gameId;
  @override
  final String socketId;
  @override
  final bool isHost;
  @override
  final String gameRoomHostId;
  @override
  final String gameName;
  @override
  final String gameDescription;

  @override
  String toString() {
    return 'GameSessionEntryAppEvent.startConfirmed(roomId: $roomId, gameId: $gameId, socketId: $socketId, isHost: $isHost, gameRoomHostId: $gameRoomHostId, gameName: $gameName, gameDescription: $gameDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSessionStartConfirmedEventImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.socketId, socketId) ||
                other.socketId == socketId) &&
            (identical(other.isHost, isHost) || other.isHost == isHost) &&
            (identical(other.gameRoomHostId, gameRoomHostId) ||
                other.gameRoomHostId == gameRoomHostId) &&
            (identical(other.gameName, gameName) ||
                other.gameName == gameName) &&
            (identical(other.gameDescription, gameDescription) ||
                other.gameDescription == gameDescription));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    roomId,
    gameId,
    socketId,
    isHost,
    gameRoomHostId,
    gameName,
    gameDescription,
  );

  /// Create a copy of GameSessionEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameSessionStartConfirmedEventImplCopyWith<
    _$GameSessionStartConfirmedEventImpl
  >
  get copyWith =>
      __$$GameSessionStartConfirmedEventImplCopyWithImpl<
        _$GameSessionStartConfirmedEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String roomId,
      String gameId,
      String socketId,
      String gameName,
      String gameDescription,
    )
    startRequested,
    required TResult Function(
      String roomId,
      String gameId,
      String socketId,
      bool isHost,
      String gameRoomHostId,
      String gameName,
      String gameDescription,
    )
    startConfirmed,
    required TResult Function() loaded,
  }) {
    return startConfirmed(
      roomId,
      gameId,
      socketId,
      isHost,
      gameRoomHostId,
      gameName,
      gameDescription,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String roomId,
      String gameId,
      String socketId,
      String gameName,
      String gameDescription,
    )?
    startRequested,
    TResult? Function(
      String roomId,
      String gameId,
      String socketId,
      bool isHost,
      String gameRoomHostId,
      String gameName,
      String gameDescription,
    )?
    startConfirmed,
    TResult? Function()? loaded,
  }) {
    return startConfirmed?.call(
      roomId,
      gameId,
      socketId,
      isHost,
      gameRoomHostId,
      gameName,
      gameDescription,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String roomId,
      String gameId,
      String socketId,
      String gameName,
      String gameDescription,
    )?
    startRequested,
    TResult Function(
      String roomId,
      String gameId,
      String socketId,
      bool isHost,
      String gameRoomHostId,
      String gameName,
      String gameDescription,
    )?
    startConfirmed,
    TResult Function()? loaded,
    required TResult orElse(),
  }) {
    if (startConfirmed != null) {
      return startConfirmed(
        roomId,
        gameId,
        socketId,
        isHost,
        gameRoomHostId,
        gameName,
        gameDescription,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StartGameSessionRequestedCommand value)
    startRequested,
    required TResult Function(GameSessionStartConfirmedEvent value)
    startConfirmed,
    required TResult Function(GameSessionLoadedEvent value) loaded,
  }) {
    return startConfirmed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StartGameSessionRequestedCommand value)? startRequested,
    TResult? Function(GameSessionStartConfirmedEvent value)? startConfirmed,
    TResult? Function(GameSessionLoadedEvent value)? loaded,
  }) {
    return startConfirmed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StartGameSessionRequestedCommand value)? startRequested,
    TResult Function(GameSessionStartConfirmedEvent value)? startConfirmed,
    TResult Function(GameSessionLoadedEvent value)? loaded,
    required TResult orElse(),
  }) {
    if (startConfirmed != null) {
      return startConfirmed(this);
    }
    return orElse();
  }
}

abstract class GameSessionStartConfirmedEvent
    implements GameSessionEntryAppEvent {
  const factory GameSessionStartConfirmedEvent({
    required final String roomId,
    required final String gameId,
    required final String socketId,
    required final bool isHost,
    required final String gameRoomHostId,
    required final String gameName,
    required final String gameDescription,
  }) = _$GameSessionStartConfirmedEventImpl;

  String get roomId;
  String get gameId;
  String get socketId;
  bool get isHost;
  String get gameRoomHostId;
  String get gameName;
  String get gameDescription;

  /// Create a copy of GameSessionEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameSessionStartConfirmedEventImplCopyWith<
    _$GameSessionStartConfirmedEventImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GameSessionLoadedEventImplCopyWith<$Res> {
  factory _$$GameSessionLoadedEventImplCopyWith(
    _$GameSessionLoadedEventImpl value,
    $Res Function(_$GameSessionLoadedEventImpl) then,
  ) = __$$GameSessionLoadedEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GameSessionLoadedEventImplCopyWithImpl<$Res>
    extends
        _$GameSessionEntryAppEventCopyWithImpl<
          $Res,
          _$GameSessionLoadedEventImpl
        >
    implements _$$GameSessionLoadedEventImplCopyWith<$Res> {
  __$$GameSessionLoadedEventImplCopyWithImpl(
    _$GameSessionLoadedEventImpl _value,
    $Res Function(_$GameSessionLoadedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSessionEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GameSessionLoadedEventImpl implements GameSessionLoadedEvent {
  const _$GameSessionLoadedEventImpl();

  @override
  String toString() {
    return 'GameSessionEntryAppEvent.loaded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSessionLoadedEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String roomId,
      String gameId,
      String socketId,
      String gameName,
      String gameDescription,
    )
    startRequested,
    required TResult Function(
      String roomId,
      String gameId,
      String socketId,
      bool isHost,
      String gameRoomHostId,
      String gameName,
      String gameDescription,
    )
    startConfirmed,
    required TResult Function() loaded,
  }) {
    return loaded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String roomId,
      String gameId,
      String socketId,
      String gameName,
      String gameDescription,
    )?
    startRequested,
    TResult? Function(
      String roomId,
      String gameId,
      String socketId,
      bool isHost,
      String gameRoomHostId,
      String gameName,
      String gameDescription,
    )?
    startConfirmed,
    TResult? Function()? loaded,
  }) {
    return loaded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String roomId,
      String gameId,
      String socketId,
      String gameName,
      String gameDescription,
    )?
    startRequested,
    TResult Function(
      String roomId,
      String gameId,
      String socketId,
      bool isHost,
      String gameRoomHostId,
      String gameName,
      String gameDescription,
    )?
    startConfirmed,
    TResult Function()? loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StartGameSessionRequestedCommand value)
    startRequested,
    required TResult Function(GameSessionStartConfirmedEvent value)
    startConfirmed,
    required TResult Function(GameSessionLoadedEvent value) loaded,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StartGameSessionRequestedCommand value)? startRequested,
    TResult? Function(GameSessionStartConfirmedEvent value)? startConfirmed,
    TResult? Function(GameSessionLoadedEvent value)? loaded,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StartGameSessionRequestedCommand value)? startRequested,
    TResult Function(GameSessionStartConfirmedEvent value)? startConfirmed,
    TResult Function(GameSessionLoadedEvent value)? loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class GameSessionLoadedEvent implements GameSessionEntryAppEvent {
  const factory GameSessionLoadedEvent() = _$GameSessionLoadedEventImpl;
}

/// @nodoc
mixin _$GameSessionCompletedAppEvent {}

/// @nodoc
abstract class $GameSessionCompletedAppEventCopyWith<$Res> {
  factory $GameSessionCompletedAppEventCopyWith(
    GameSessionCompletedAppEvent value,
    $Res Function(GameSessionCompletedAppEvent) then,
  ) =
      _$GameSessionCompletedAppEventCopyWithImpl<
        $Res,
        GameSessionCompletedAppEvent
      >;
}

/// @nodoc
class _$GameSessionCompletedAppEventCopyWithImpl<
  $Res,
  $Val extends GameSessionCompletedAppEvent
>
    implements $GameSessionCompletedAppEventCopyWith<$Res> {
  _$GameSessionCompletedAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameSessionCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GameSessionCompletedAppEventImplCopyWith<$Res> {
  factory _$$GameSessionCompletedAppEventImplCopyWith(
    _$GameSessionCompletedAppEventImpl value,
    $Res Function(_$GameSessionCompletedAppEventImpl) then,
  ) = __$$GameSessionCompletedAppEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GameSessionCompletedAppEventImplCopyWithImpl<$Res>
    extends
        _$GameSessionCompletedAppEventCopyWithImpl<
          $Res,
          _$GameSessionCompletedAppEventImpl
        >
    implements _$$GameSessionCompletedAppEventImplCopyWith<$Res> {
  __$$GameSessionCompletedAppEventImplCopyWithImpl(
    _$GameSessionCompletedAppEventImpl _value,
    $Res Function(_$GameSessionCompletedAppEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSessionCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GameSessionCompletedAppEventImpl
    implements _GameSessionCompletedAppEvent {
  const _$GameSessionCompletedAppEventImpl();

  @override
  String toString() {
    return 'GameSessionCompletedAppEvent()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSessionCompletedAppEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _GameSessionCompletedAppEvent
    implements GameSessionCompletedAppEvent {
  const factory _GameSessionCompletedAppEvent() =
      _$GameSessionCompletedAppEventImpl;
}

/// @nodoc
mixin _$GameSessionExitAppEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PlayerLeaveReason reason) leaveRequested,
    required TResult Function(SessionEndReason reason) sessionTerminated,
    required TResult Function(
      String roomId,
      bool isCTF,
      String winnerId,
      String currentUserSocketId,
      String statisticsPlayerName,
    )
    gameFinished,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PlayerLeaveReason reason)? leaveRequested,
    TResult? Function(SessionEndReason reason)? sessionTerminated,
    TResult? Function(
      String roomId,
      bool isCTF,
      String winnerId,
      String currentUserSocketId,
      String statisticsPlayerName,
    )?
    gameFinished,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PlayerLeaveReason reason)? leaveRequested,
    TResult Function(SessionEndReason reason)? sessionTerminated,
    TResult Function(
      String roomId,
      bool isCTF,
      String winnerId,
      String currentUserSocketId,
      String statisticsPlayerName,
    )?
    gameFinished,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeaveGameSessionRequestedCommand value)
    leaveRequested,
    required TResult Function(SessionTerminatedEvent value) sessionTerminated,
    required TResult Function(GameFinishedEvent value) gameFinished,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaveGameSessionRequestedCommand value)? leaveRequested,
    TResult? Function(SessionTerminatedEvent value)? sessionTerminated,
    TResult? Function(GameFinishedEvent value)? gameFinished,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaveGameSessionRequestedCommand value)? leaveRequested,
    TResult Function(SessionTerminatedEvent value)? sessionTerminated,
    TResult Function(GameFinishedEvent value)? gameFinished,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSessionExitAppEventCopyWith<$Res> {
  factory $GameSessionExitAppEventCopyWith(
    GameSessionExitAppEvent value,
    $Res Function(GameSessionExitAppEvent) then,
  ) = _$GameSessionExitAppEventCopyWithImpl<$Res, GameSessionExitAppEvent>;
}

/// @nodoc
class _$GameSessionExitAppEventCopyWithImpl<
  $Res,
  $Val extends GameSessionExitAppEvent
>
    implements $GameSessionExitAppEventCopyWith<$Res> {
  _$GameSessionExitAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameSessionExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LeaveGameSessionRequestedCommandImplCopyWith<$Res> {
  factory _$$LeaveGameSessionRequestedCommandImplCopyWith(
    _$LeaveGameSessionRequestedCommandImpl value,
    $Res Function(_$LeaveGameSessionRequestedCommandImpl) then,
  ) = __$$LeaveGameSessionRequestedCommandImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PlayerLeaveReason reason});
}

/// @nodoc
class __$$LeaveGameSessionRequestedCommandImplCopyWithImpl<$Res>
    extends
        _$GameSessionExitAppEventCopyWithImpl<
          $Res,
          _$LeaveGameSessionRequestedCommandImpl
        >
    implements _$$LeaveGameSessionRequestedCommandImplCopyWith<$Res> {
  __$$LeaveGameSessionRequestedCommandImplCopyWithImpl(
    _$LeaveGameSessionRequestedCommandImpl _value,
    $Res Function(_$LeaveGameSessionRequestedCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSessionExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null}) {
    return _then(
      _$LeaveGameSessionRequestedCommandImpl(
        null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as PlayerLeaveReason,
      ),
    );
  }
}

/// @nodoc

class _$LeaveGameSessionRequestedCommandImpl
    implements LeaveGameSessionRequestedCommand {
  const _$LeaveGameSessionRequestedCommandImpl(this.reason);

  @override
  final PlayerLeaveReason reason;

  @override
  String toString() {
    return 'GameSessionExitAppEvent.leaveRequested(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaveGameSessionRequestedCommandImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of GameSessionExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaveGameSessionRequestedCommandImplCopyWith<
    _$LeaveGameSessionRequestedCommandImpl
  >
  get copyWith =>
      __$$LeaveGameSessionRequestedCommandImplCopyWithImpl<
        _$LeaveGameSessionRequestedCommandImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PlayerLeaveReason reason) leaveRequested,
    required TResult Function(SessionEndReason reason) sessionTerminated,
    required TResult Function(
      String roomId,
      bool isCTF,
      String winnerId,
      String currentUserSocketId,
      String statisticsPlayerName,
    )
    gameFinished,
  }) {
    return leaveRequested(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PlayerLeaveReason reason)? leaveRequested,
    TResult? Function(SessionEndReason reason)? sessionTerminated,
    TResult? Function(
      String roomId,
      bool isCTF,
      String winnerId,
      String currentUserSocketId,
      String statisticsPlayerName,
    )?
    gameFinished,
  }) {
    return leaveRequested?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PlayerLeaveReason reason)? leaveRequested,
    TResult Function(SessionEndReason reason)? sessionTerminated,
    TResult Function(
      String roomId,
      bool isCTF,
      String winnerId,
      String currentUserSocketId,
      String statisticsPlayerName,
    )?
    gameFinished,
    required TResult orElse(),
  }) {
    if (leaveRequested != null) {
      return leaveRequested(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeaveGameSessionRequestedCommand value)
    leaveRequested,
    required TResult Function(SessionTerminatedEvent value) sessionTerminated,
    required TResult Function(GameFinishedEvent value) gameFinished,
  }) {
    return leaveRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaveGameSessionRequestedCommand value)? leaveRequested,
    TResult? Function(SessionTerminatedEvent value)? sessionTerminated,
    TResult? Function(GameFinishedEvent value)? gameFinished,
  }) {
    return leaveRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaveGameSessionRequestedCommand value)? leaveRequested,
    TResult Function(SessionTerminatedEvent value)? sessionTerminated,
    TResult Function(GameFinishedEvent value)? gameFinished,
    required TResult orElse(),
  }) {
    if (leaveRequested != null) {
      return leaveRequested(this);
    }
    return orElse();
  }
}

abstract class LeaveGameSessionRequestedCommand
    implements GameSessionExitAppEvent {
  const factory LeaveGameSessionRequestedCommand(
    final PlayerLeaveReason reason,
  ) = _$LeaveGameSessionRequestedCommandImpl;

  PlayerLeaveReason get reason;

  /// Create a copy of GameSessionExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaveGameSessionRequestedCommandImplCopyWith<
    _$LeaveGameSessionRequestedCommandImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SessionTerminatedEventImplCopyWith<$Res> {
  factory _$$SessionTerminatedEventImplCopyWith(
    _$SessionTerminatedEventImpl value,
    $Res Function(_$SessionTerminatedEventImpl) then,
  ) = __$$SessionTerminatedEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SessionEndReason reason});
}

/// @nodoc
class __$$SessionTerminatedEventImplCopyWithImpl<$Res>
    extends
        _$GameSessionExitAppEventCopyWithImpl<
          $Res,
          _$SessionTerminatedEventImpl
        >
    implements _$$SessionTerminatedEventImplCopyWith<$Res> {
  __$$SessionTerminatedEventImplCopyWithImpl(
    _$SessionTerminatedEventImpl _value,
    $Res Function(_$SessionTerminatedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSessionExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null}) {
    return _then(
      _$SessionTerminatedEventImpl(
        null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as SessionEndReason,
      ),
    );
  }
}

/// @nodoc

class _$SessionTerminatedEventImpl implements SessionTerminatedEvent {
  const _$SessionTerminatedEventImpl(this.reason);

  @override
  final SessionEndReason reason;

  @override
  String toString() {
    return 'GameSessionExitAppEvent.sessionTerminated(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionTerminatedEventImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of GameSessionExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionTerminatedEventImplCopyWith<_$SessionTerminatedEventImpl>
  get copyWith =>
      __$$SessionTerminatedEventImplCopyWithImpl<_$SessionTerminatedEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PlayerLeaveReason reason) leaveRequested,
    required TResult Function(SessionEndReason reason) sessionTerminated,
    required TResult Function(
      String roomId,
      bool isCTF,
      String winnerId,
      String currentUserSocketId,
      String statisticsPlayerName,
    )
    gameFinished,
  }) {
    return sessionTerminated(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PlayerLeaveReason reason)? leaveRequested,
    TResult? Function(SessionEndReason reason)? sessionTerminated,
    TResult? Function(
      String roomId,
      bool isCTF,
      String winnerId,
      String currentUserSocketId,
      String statisticsPlayerName,
    )?
    gameFinished,
  }) {
    return sessionTerminated?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PlayerLeaveReason reason)? leaveRequested,
    TResult Function(SessionEndReason reason)? sessionTerminated,
    TResult Function(
      String roomId,
      bool isCTF,
      String winnerId,
      String currentUserSocketId,
      String statisticsPlayerName,
    )?
    gameFinished,
    required TResult orElse(),
  }) {
    if (sessionTerminated != null) {
      return sessionTerminated(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeaveGameSessionRequestedCommand value)
    leaveRequested,
    required TResult Function(SessionTerminatedEvent value) sessionTerminated,
    required TResult Function(GameFinishedEvent value) gameFinished,
  }) {
    return sessionTerminated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaveGameSessionRequestedCommand value)? leaveRequested,
    TResult? Function(SessionTerminatedEvent value)? sessionTerminated,
    TResult? Function(GameFinishedEvent value)? gameFinished,
  }) {
    return sessionTerminated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaveGameSessionRequestedCommand value)? leaveRequested,
    TResult Function(SessionTerminatedEvent value)? sessionTerminated,
    TResult Function(GameFinishedEvent value)? gameFinished,
    required TResult orElse(),
  }) {
    if (sessionTerminated != null) {
      return sessionTerminated(this);
    }
    return orElse();
  }
}

abstract class SessionTerminatedEvent implements GameSessionExitAppEvent {
  const factory SessionTerminatedEvent(final SessionEndReason reason) =
      _$SessionTerminatedEventImpl;

  SessionEndReason get reason;

  /// Create a copy of GameSessionExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionTerminatedEventImplCopyWith<_$SessionTerminatedEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GameFinishedEventImplCopyWith<$Res> {
  factory _$$GameFinishedEventImplCopyWith(
    _$GameFinishedEventImpl value,
    $Res Function(_$GameFinishedEventImpl) then,
  ) = __$$GameFinishedEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String roomId,
    bool isCTF,
    String winnerId,
    String currentUserSocketId,
    String statisticsPlayerName,
  });
}

/// @nodoc
class __$$GameFinishedEventImplCopyWithImpl<$Res>
    extends _$GameSessionExitAppEventCopyWithImpl<$Res, _$GameFinishedEventImpl>
    implements _$$GameFinishedEventImplCopyWith<$Res> {
  __$$GameFinishedEventImplCopyWithImpl(
    _$GameFinishedEventImpl _value,
    $Res Function(_$GameFinishedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSessionExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? isCTF = null,
    Object? winnerId = null,
    Object? currentUserSocketId = null,
    Object? statisticsPlayerName = null,
  }) {
    return _then(
      _$GameFinishedEventImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        isCTF: null == isCTF
            ? _value.isCTF
            : isCTF // ignore: cast_nullable_to_non_nullable
                  as bool,
        winnerId: null == winnerId
            ? _value.winnerId
            : winnerId // ignore: cast_nullable_to_non_nullable
                  as String,
        currentUserSocketId: null == currentUserSocketId
            ? _value.currentUserSocketId
            : currentUserSocketId // ignore: cast_nullable_to_non_nullable
                  as String,
        statisticsPlayerName: null == statisticsPlayerName
            ? _value.statisticsPlayerName
            : statisticsPlayerName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GameFinishedEventImpl implements GameFinishedEvent {
  const _$GameFinishedEventImpl({
    required this.roomId,
    required this.isCTF,
    required this.winnerId,
    required this.currentUserSocketId,
    required this.statisticsPlayerName,
  });

  @override
  final String roomId;
  @override
  final bool isCTF;
  @override
  final String winnerId;
  @override
  final String currentUserSocketId;
  @override
  final String statisticsPlayerName;

  @override
  String toString() {
    return 'GameSessionExitAppEvent.gameFinished(roomId: $roomId, isCTF: $isCTF, winnerId: $winnerId, currentUserSocketId: $currentUserSocketId, statisticsPlayerName: $statisticsPlayerName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameFinishedEventImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.isCTF, isCTF) || other.isCTF == isCTF) &&
            (identical(other.winnerId, winnerId) ||
                other.winnerId == winnerId) &&
            (identical(other.currentUserSocketId, currentUserSocketId) ||
                other.currentUserSocketId == currentUserSocketId) &&
            (identical(other.statisticsPlayerName, statisticsPlayerName) ||
                other.statisticsPlayerName == statisticsPlayerName));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    roomId,
    isCTF,
    winnerId,
    currentUserSocketId,
    statisticsPlayerName,
  );

  /// Create a copy of GameSessionExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameFinishedEventImplCopyWith<_$GameFinishedEventImpl> get copyWith =>
      __$$GameFinishedEventImplCopyWithImpl<_$GameFinishedEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PlayerLeaveReason reason) leaveRequested,
    required TResult Function(SessionEndReason reason) sessionTerminated,
    required TResult Function(
      String roomId,
      bool isCTF,
      String winnerId,
      String currentUserSocketId,
      String statisticsPlayerName,
    )
    gameFinished,
  }) {
    return gameFinished(
      roomId,
      isCTF,
      winnerId,
      currentUserSocketId,
      statisticsPlayerName,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PlayerLeaveReason reason)? leaveRequested,
    TResult? Function(SessionEndReason reason)? sessionTerminated,
    TResult? Function(
      String roomId,
      bool isCTF,
      String winnerId,
      String currentUserSocketId,
      String statisticsPlayerName,
    )?
    gameFinished,
  }) {
    return gameFinished?.call(
      roomId,
      isCTF,
      winnerId,
      currentUserSocketId,
      statisticsPlayerName,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PlayerLeaveReason reason)? leaveRequested,
    TResult Function(SessionEndReason reason)? sessionTerminated,
    TResult Function(
      String roomId,
      bool isCTF,
      String winnerId,
      String currentUserSocketId,
      String statisticsPlayerName,
    )?
    gameFinished,
    required TResult orElse(),
  }) {
    if (gameFinished != null) {
      return gameFinished(
        roomId,
        isCTF,
        winnerId,
        currentUserSocketId,
        statisticsPlayerName,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeaveGameSessionRequestedCommand value)
    leaveRequested,
    required TResult Function(SessionTerminatedEvent value) sessionTerminated,
    required TResult Function(GameFinishedEvent value) gameFinished,
  }) {
    return gameFinished(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaveGameSessionRequestedCommand value)? leaveRequested,
    TResult? Function(SessionTerminatedEvent value)? sessionTerminated,
    TResult? Function(GameFinishedEvent value)? gameFinished,
  }) {
    return gameFinished?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaveGameSessionRequestedCommand value)? leaveRequested,
    TResult Function(SessionTerminatedEvent value)? sessionTerminated,
    TResult Function(GameFinishedEvent value)? gameFinished,
    required TResult orElse(),
  }) {
    if (gameFinished != null) {
      return gameFinished(this);
    }
    return orElse();
  }
}

abstract class GameFinishedEvent implements GameSessionExitAppEvent {
  const factory GameFinishedEvent({
    required final String roomId,
    required final bool isCTF,
    required final String winnerId,
    required final String currentUserSocketId,
    required final String statisticsPlayerName,
  }) = _$GameFinishedEventImpl;

  String get roomId;
  bool get isCTF;
  String get winnerId;
  String get currentUserSocketId;
  String get statisticsPlayerName;

  /// Create a copy of GameSessionExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameFinishedEventImplCopyWith<_$GameFinishedEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
