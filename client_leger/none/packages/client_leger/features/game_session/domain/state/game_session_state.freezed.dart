// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameSessionState {
  String get roomId => throw _privateConstructorUsedError;
  String get hostId => throw _privateConstructorUsedError;
  bool get isCTF => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String roomId, String hostId, bool isCTF) active,
    required TResult Function(
      String roomId,
      String winnerId,
      String hostId,
      bool isCTF,
    )
    finished,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String roomId, String hostId, bool isCTF)? active,
    TResult? Function(
      String roomId,
      String winnerId,
      String hostId,
      bool isCTF,
    )?
    finished,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String roomId, String hostId, bool isCTF)? active,
    TResult Function(String roomId, String winnerId, String hostId, bool isCTF)?
    finished,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GameSessionActive value) active,
    required TResult Function(GameSessionFinished value) finished,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GameSessionActive value)? active,
    TResult? Function(GameSessionFinished value)? finished,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GameSessionActive value)? active,
    TResult Function(GameSessionFinished value)? finished,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of GameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameSessionStateCopyWith<GameSessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSessionStateCopyWith<$Res> {
  factory $GameSessionStateCopyWith(
    GameSessionState value,
    $Res Function(GameSessionState) then,
  ) = _$GameSessionStateCopyWithImpl<$Res, GameSessionState>;
  @useResult
  $Res call({String roomId, String hostId, bool isCTF});
}

/// @nodoc
class _$GameSessionStateCopyWithImpl<$Res, $Val extends GameSessionState>
    implements $GameSessionStateCopyWith<$Res> {
  _$GameSessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? hostId = null,
    Object? isCTF = null,
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
            isCTF: null == isCTF
                ? _value.isCTF
                : isCTF // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameSessionActiveImplCopyWith<$Res>
    implements $GameSessionStateCopyWith<$Res> {
  factory _$$GameSessionActiveImplCopyWith(
    _$GameSessionActiveImpl value,
    $Res Function(_$GameSessionActiveImpl) then,
  ) = __$$GameSessionActiveImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, String hostId, bool isCTF});
}

/// @nodoc
class __$$GameSessionActiveImplCopyWithImpl<$Res>
    extends _$GameSessionStateCopyWithImpl<$Res, _$GameSessionActiveImpl>
    implements _$$GameSessionActiveImplCopyWith<$Res> {
  __$$GameSessionActiveImplCopyWithImpl(
    _$GameSessionActiveImpl _value,
    $Res Function(_$GameSessionActiveImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? hostId = null,
    Object? isCTF = null,
  }) {
    return _then(
      _$GameSessionActiveImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        hostId: null == hostId
            ? _value.hostId
            : hostId // ignore: cast_nullable_to_non_nullable
                  as String,
        isCTF: null == isCTF
            ? _value.isCTF
            : isCTF // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$GameSessionActiveImpl extends GameSessionActive {
  const _$GameSessionActiveImpl({
    required this.roomId,
    required this.hostId,
    this.isCTF = false,
  }) : super._();

  @override
  final String roomId;
  @override
  final String hostId;
  @override
  @JsonKey()
  final bool isCTF;

  @override
  String toString() {
    return 'GameSessionState.active(roomId: $roomId, hostId: $hostId, isCTF: $isCTF)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSessionActiveImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.isCTF, isCTF) || other.isCTF == isCTF));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, hostId, isCTF);

  /// Create a copy of GameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameSessionActiveImplCopyWith<_$GameSessionActiveImpl> get copyWith =>
      __$$GameSessionActiveImplCopyWithImpl<_$GameSessionActiveImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String roomId, String hostId, bool isCTF) active,
    required TResult Function(
      String roomId,
      String winnerId,
      String hostId,
      bool isCTF,
    )
    finished,
  }) {
    return active(roomId, hostId, isCTF);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String roomId, String hostId, bool isCTF)? active,
    TResult? Function(
      String roomId,
      String winnerId,
      String hostId,
      bool isCTF,
    )?
    finished,
  }) {
    return active?.call(roomId, hostId, isCTF);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String roomId, String hostId, bool isCTF)? active,
    TResult Function(String roomId, String winnerId, String hostId, bool isCTF)?
    finished,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(roomId, hostId, isCTF);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GameSessionActive value) active,
    required TResult Function(GameSessionFinished value) finished,
  }) {
    return active(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GameSessionActive value)? active,
    TResult? Function(GameSessionFinished value)? finished,
  }) {
    return active?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GameSessionActive value)? active,
    TResult Function(GameSessionFinished value)? finished,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(this);
    }
    return orElse();
  }
}

abstract class GameSessionActive extends GameSessionState {
  const factory GameSessionActive({
    required final String roomId,
    required final String hostId,
    final bool isCTF,
  }) = _$GameSessionActiveImpl;
  const GameSessionActive._() : super._();

  @override
  String get roomId;
  @override
  String get hostId;
  @override
  bool get isCTF;

  /// Create a copy of GameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameSessionActiveImplCopyWith<_$GameSessionActiveImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GameSessionFinishedImplCopyWith<$Res>
    implements $GameSessionStateCopyWith<$Res> {
  factory _$$GameSessionFinishedImplCopyWith(
    _$GameSessionFinishedImpl value,
    $Res Function(_$GameSessionFinishedImpl) then,
  ) = __$$GameSessionFinishedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, String winnerId, String hostId, bool isCTF});
}

/// @nodoc
class __$$GameSessionFinishedImplCopyWithImpl<$Res>
    extends _$GameSessionStateCopyWithImpl<$Res, _$GameSessionFinishedImpl>
    implements _$$GameSessionFinishedImplCopyWith<$Res> {
  __$$GameSessionFinishedImplCopyWithImpl(
    _$GameSessionFinishedImpl _value,
    $Res Function(_$GameSessionFinishedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? winnerId = null,
    Object? hostId = null,
    Object? isCTF = null,
  }) {
    return _then(
      _$GameSessionFinishedImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        winnerId: null == winnerId
            ? _value.winnerId
            : winnerId // ignore: cast_nullable_to_non_nullable
                  as String,
        hostId: null == hostId
            ? _value.hostId
            : hostId // ignore: cast_nullable_to_non_nullable
                  as String,
        isCTF: null == isCTF
            ? _value.isCTF
            : isCTF // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$GameSessionFinishedImpl extends GameSessionFinished {
  const _$GameSessionFinishedImpl({
    required this.roomId,
    required this.winnerId,
    required this.hostId,
    this.isCTF = false,
  }) : super._();

  @override
  final String roomId;
  @override
  final String winnerId;
  @override
  final String hostId;
  @override
  @JsonKey()
  final bool isCTF;

  @override
  String toString() {
    return 'GameSessionState.finished(roomId: $roomId, winnerId: $winnerId, hostId: $hostId, isCTF: $isCTF)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSessionFinishedImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.winnerId, winnerId) ||
                other.winnerId == winnerId) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.isCTF, isCTF) || other.isCTF == isCTF));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, winnerId, hostId, isCTF);

  /// Create a copy of GameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameSessionFinishedImplCopyWith<_$GameSessionFinishedImpl> get copyWith =>
      __$$GameSessionFinishedImplCopyWithImpl<_$GameSessionFinishedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String roomId, String hostId, bool isCTF) active,
    required TResult Function(
      String roomId,
      String winnerId,
      String hostId,
      bool isCTF,
    )
    finished,
  }) {
    return finished(roomId, winnerId, hostId, isCTF);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String roomId, String hostId, bool isCTF)? active,
    TResult? Function(
      String roomId,
      String winnerId,
      String hostId,
      bool isCTF,
    )?
    finished,
  }) {
    return finished?.call(roomId, winnerId, hostId, isCTF);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String roomId, String hostId, bool isCTF)? active,
    TResult Function(String roomId, String winnerId, String hostId, bool isCTF)?
    finished,
    required TResult orElse(),
  }) {
    if (finished != null) {
      return finished(roomId, winnerId, hostId, isCTF);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GameSessionActive value) active,
    required TResult Function(GameSessionFinished value) finished,
  }) {
    return finished(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GameSessionActive value)? active,
    TResult? Function(GameSessionFinished value)? finished,
  }) {
    return finished?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GameSessionActive value)? active,
    TResult Function(GameSessionFinished value)? finished,
    required TResult orElse(),
  }) {
    if (finished != null) {
      return finished(this);
    }
    return orElse();
  }
}

abstract class GameSessionFinished extends GameSessionState {
  const factory GameSessionFinished({
    required final String roomId,
    required final String winnerId,
    required final String hostId,
    final bool isCTF,
  }) = _$GameSessionFinishedImpl;
  const GameSessionFinished._() : super._();

  @override
  String get roomId;
  String get winnerId;
  @override
  String get hostId;
  @override
  bool get isCTF;

  /// Create a copy of GameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameSessionFinishedImplCopyWith<_$GameSessionFinishedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
