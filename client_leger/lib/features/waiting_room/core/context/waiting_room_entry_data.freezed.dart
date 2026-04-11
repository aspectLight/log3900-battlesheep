// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waiting_room_entry_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WaitingRoomEntryData {
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
    host,
    required TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      WaitingRoomModel initialRoom,
    )
    join,
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
    host,
    TResult? Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      WaitingRoomModel initialRoom,
    )?
    join,
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
    host,
    TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      WaitingRoomModel initialRoom,
    )?
    join,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WaitingRoomHostEntryData value) host,
    required TResult Function(WaitingRoomJoinEntryData value) join,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WaitingRoomHostEntryData value)? host,
    TResult? Function(WaitingRoomJoinEntryData value)? join,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WaitingRoomHostEntryData value)? host,
    TResult Function(WaitingRoomJoinEntryData value)? join,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of WaitingRoomEntryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaitingRoomEntryDataCopyWith<WaitingRoomEntryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaitingRoomEntryDataCopyWith<$Res> {
  factory $WaitingRoomEntryDataCopyWith(
    WaitingRoomEntryData value,
    $Res Function(WaitingRoomEntryData) then,
  ) = _$WaitingRoomEntryDataCopyWithImpl<$Res, WaitingRoomEntryData>;
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
class _$WaitingRoomEntryDataCopyWithImpl<
  $Res,
  $Val extends WaitingRoomEntryData
>
    implements $WaitingRoomEntryDataCopyWith<$Res> {
  _$WaitingRoomEntryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaitingRoomEntryData
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
abstract class _$$WaitingRoomHostEntryDataImplCopyWith<$Res>
    implements $WaitingRoomEntryDataCopyWith<$Res> {
  factory _$$WaitingRoomHostEntryDataImplCopyWith(
    _$WaitingRoomHostEntryDataImpl value,
    $Res Function(_$WaitingRoomHostEntryDataImpl) then,
  ) = __$$WaitingRoomHostEntryDataImplCopyWithImpl<$Res>;
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
class __$$WaitingRoomHostEntryDataImplCopyWithImpl<$Res>
    extends
        _$WaitingRoomEntryDataCopyWithImpl<$Res, _$WaitingRoomHostEntryDataImpl>
    implements _$$WaitingRoomHostEntryDataImplCopyWith<$Res> {
  __$$WaitingRoomHostEntryDataImplCopyWithImpl(
    _$WaitingRoomHostEntryDataImpl _value,
    $Res Function(_$WaitingRoomHostEntryDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaitingRoomEntryData
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
      _$WaitingRoomHostEntryDataImpl(
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

class _$WaitingRoomHostEntryDataImpl implements WaitingRoomHostEntryData {
  const _$WaitingRoomHostEntryDataImpl({
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
    return 'WaitingRoomEntryData.host(roomId: $roomId, hostId: $hostId, socketId: $socketId, gameName: $gameName, gameDescription: $gameDescription, boardSize: $boardSize, isCTF: $isCTF, friendsOnly: $friendsOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitingRoomHostEntryDataImpl &&
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

  /// Create a copy of WaitingRoomEntryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitingRoomHostEntryDataImplCopyWith<_$WaitingRoomHostEntryDataImpl>
  get copyWith =>
      __$$WaitingRoomHostEntryDataImplCopyWithImpl<
        _$WaitingRoomHostEntryDataImpl
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
    host,
    required TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      WaitingRoomModel initialRoom,
    )
    join,
  }) {
    return host(
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
    host,
    TResult? Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      WaitingRoomModel initialRoom,
    )?
    join,
  }) {
    return host?.call(
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
    host,
    TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      WaitingRoomModel initialRoom,
    )?
    join,
    required TResult orElse(),
  }) {
    if (host != null) {
      return host(
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
    required TResult Function(WaitingRoomHostEntryData value) host,
    required TResult Function(WaitingRoomJoinEntryData value) join,
  }) {
    return host(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WaitingRoomHostEntryData value)? host,
    TResult? Function(WaitingRoomJoinEntryData value)? join,
  }) {
    return host?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WaitingRoomHostEntryData value)? host,
    TResult Function(WaitingRoomJoinEntryData value)? join,
    required TResult orElse(),
  }) {
    if (host != null) {
      return host(this);
    }
    return orElse();
  }
}

abstract class WaitingRoomHostEntryData implements WaitingRoomEntryData {
  const factory WaitingRoomHostEntryData({
    required final String roomId,
    required final String hostId,
    required final String socketId,
    required final String gameName,
    required final String gameDescription,
    required final int boardSize,
    required final bool isCTF,
    final bool friendsOnly,
  }) = _$WaitingRoomHostEntryDataImpl;

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

  /// Create a copy of WaitingRoomEntryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaitingRoomHostEntryDataImplCopyWith<_$WaitingRoomHostEntryDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WaitingRoomJoinEntryDataImplCopyWith<$Res>
    implements $WaitingRoomEntryDataCopyWith<$Res> {
  factory _$$WaitingRoomJoinEntryDataImplCopyWith(
    _$WaitingRoomJoinEntryDataImpl value,
    $Res Function(_$WaitingRoomJoinEntryDataImpl) then,
  ) = __$$WaitingRoomJoinEntryDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roomId,
    String hostId,
    String socketId,
    String gameName,
    String gameDescription,
    WaitingRoomModel initialRoom,
  });

  $WaitingRoomModelCopyWith<$Res> get initialRoom;
}

/// @nodoc
class __$$WaitingRoomJoinEntryDataImplCopyWithImpl<$Res>
    extends
        _$WaitingRoomEntryDataCopyWithImpl<$Res, _$WaitingRoomJoinEntryDataImpl>
    implements _$$WaitingRoomJoinEntryDataImplCopyWith<$Res> {
  __$$WaitingRoomJoinEntryDataImplCopyWithImpl(
    _$WaitingRoomJoinEntryDataImpl _value,
    $Res Function(_$WaitingRoomJoinEntryDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaitingRoomEntryData
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
      _$WaitingRoomJoinEntryDataImpl(
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
                  as WaitingRoomModel,
      ),
    );
  }

  /// Create a copy of WaitingRoomEntryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WaitingRoomModelCopyWith<$Res> get initialRoom {
    return $WaitingRoomModelCopyWith<$Res>(_value.initialRoom, (value) {
      return _then(_value.copyWith(initialRoom: value));
    });
  }
}

/// @nodoc

class _$WaitingRoomJoinEntryDataImpl implements WaitingRoomJoinEntryData {
  const _$WaitingRoomJoinEntryDataImpl({
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
  final WaitingRoomModel initialRoom;

  @override
  String toString() {
    return 'WaitingRoomEntryData.join(roomId: $roomId, hostId: $hostId, socketId: $socketId, gameName: $gameName, gameDescription: $gameDescription, initialRoom: $initialRoom)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitingRoomJoinEntryDataImpl &&
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

  /// Create a copy of WaitingRoomEntryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitingRoomJoinEntryDataImplCopyWith<_$WaitingRoomJoinEntryDataImpl>
  get copyWith =>
      __$$WaitingRoomJoinEntryDataImplCopyWithImpl<
        _$WaitingRoomJoinEntryDataImpl
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
    host,
    required TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      WaitingRoomModel initialRoom,
    )
    join,
  }) {
    return join(
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
    host,
    TResult? Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      WaitingRoomModel initialRoom,
    )?
    join,
  }) {
    return join?.call(
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
    host,
    TResult Function(
      String roomId,
      String hostId,
      String socketId,
      String gameName,
      String gameDescription,
      WaitingRoomModel initialRoom,
    )?
    join,
    required TResult orElse(),
  }) {
    if (join != null) {
      return join(
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
    required TResult Function(WaitingRoomHostEntryData value) host,
    required TResult Function(WaitingRoomJoinEntryData value) join,
  }) {
    return join(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WaitingRoomHostEntryData value)? host,
    TResult? Function(WaitingRoomJoinEntryData value)? join,
  }) {
    return join?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WaitingRoomHostEntryData value)? host,
    TResult Function(WaitingRoomJoinEntryData value)? join,
    required TResult orElse(),
  }) {
    if (join != null) {
      return join(this);
    }
    return orElse();
  }
}

abstract class WaitingRoomJoinEntryData implements WaitingRoomEntryData {
  const factory WaitingRoomJoinEntryData({
    required final String roomId,
    required final String hostId,
    required final String socketId,
    required final String gameName,
    required final String gameDescription,
    required final WaitingRoomModel initialRoom,
  }) = _$WaitingRoomJoinEntryDataImpl;

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
  WaitingRoomModel get initialRoom;

  /// Create a copy of WaitingRoomEntryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaitingRoomJoinEntryDataImplCopyWith<_$WaitingRoomJoinEntryDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}
