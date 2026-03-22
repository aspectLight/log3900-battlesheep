// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_session_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameSessionData {
  String get roomId => throw _privateConstructorUsedError;
  String get gameId => throw _privateConstructorUsedError;
  String get socketId => throw _privateConstructorUsedError;
  bool get isHost => throw _privateConstructorUsedError;
  String get gameRoomHostId => throw _privateConstructorUsedError;
  String get gameName => throw _privateConstructorUsedError;
  String get gameDescription => throw _privateConstructorUsedError;

  /// Create a copy of GameSessionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameSessionDataCopyWith<GameSessionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSessionDataCopyWith<$Res> {
  factory $GameSessionDataCopyWith(
    GameSessionData value,
    $Res Function(GameSessionData) then,
  ) = _$GameSessionDataCopyWithImpl<$Res, GameSessionData>;
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
class _$GameSessionDataCopyWithImpl<$Res, $Val extends GameSessionData>
    implements $GameSessionDataCopyWith<$Res> {
  _$GameSessionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameSessionData
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
      _value.copyWith(
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameSessionDataImplCopyWith<$Res>
    implements $GameSessionDataCopyWith<$Res> {
  factory _$$GameSessionDataImplCopyWith(
    _$GameSessionDataImpl value,
    $Res Function(_$GameSessionDataImpl) then,
  ) = __$$GameSessionDataImplCopyWithImpl<$Res>;
  @override
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
class __$$GameSessionDataImplCopyWithImpl<$Res>
    extends _$GameSessionDataCopyWithImpl<$Res, _$GameSessionDataImpl>
    implements _$$GameSessionDataImplCopyWith<$Res> {
  __$$GameSessionDataImplCopyWithImpl(
    _$GameSessionDataImpl _value,
    $Res Function(_$GameSessionDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSessionData
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
      _$GameSessionDataImpl(
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

class _$GameSessionDataImpl implements _GameSessionData {
  const _$GameSessionDataImpl({
    required this.roomId,
    required this.gameId,
    required this.socketId,
    this.isHost = false,
    this.gameRoomHostId = '',
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
  @JsonKey()
  final bool isHost;
  @override
  @JsonKey()
  final String gameRoomHostId;
  @override
  final String gameName;
  @override
  final String gameDescription;

  @override
  String toString() {
    return 'GameSessionData(roomId: $roomId, gameId: $gameId, socketId: $socketId, isHost: $isHost, gameRoomHostId: $gameRoomHostId, gameName: $gameName, gameDescription: $gameDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSessionDataImpl &&
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

  /// Create a copy of GameSessionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameSessionDataImplCopyWith<_$GameSessionDataImpl> get copyWith =>
      __$$GameSessionDataImplCopyWithImpl<_$GameSessionDataImpl>(
        this,
        _$identity,
      );
}

abstract class _GameSessionData implements GameSessionData {
  const factory _GameSessionData({
    required final String roomId,
    required final String gameId,
    required final String socketId,
    final bool isHost,
    final String gameRoomHostId,
    required final String gameName,
    required final String gameDescription,
  }) = _$GameSessionDataImpl;

  @override
  String get roomId;
  @override
  String get gameId;
  @override
  String get socketId;
  @override
  bool get isHost;
  @override
  String get gameRoomHostId;
  @override
  String get gameName;
  @override
  String get gameDescription;

  /// Create a copy of GameSessionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameSessionDataImplCopyWith<_$GameSessionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
