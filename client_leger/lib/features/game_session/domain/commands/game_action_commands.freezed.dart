// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_action_commands.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ForwardTurnCommand {
  String get roomId => throw _privateConstructorUsedError;

  /// Create a copy of ForwardTurnCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForwardTurnCommandCopyWith<ForwardTurnCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForwardTurnCommandCopyWith<$Res> {
  factory $ForwardTurnCommandCopyWith(
    ForwardTurnCommand value,
    $Res Function(ForwardTurnCommand) then,
  ) = _$ForwardTurnCommandCopyWithImpl<$Res, ForwardTurnCommand>;
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class _$ForwardTurnCommandCopyWithImpl<$Res, $Val extends ForwardTurnCommand>
    implements $ForwardTurnCommandCopyWith<$Res> {
  _$ForwardTurnCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForwardTurnCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ForwardTurnCommandImplCopyWith<$Res>
    implements $ForwardTurnCommandCopyWith<$Res> {
  factory _$$ForwardTurnCommandImplCopyWith(
    _$ForwardTurnCommandImpl value,
    $Res Function(_$ForwardTurnCommandImpl) then,
  ) = __$$ForwardTurnCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class __$$ForwardTurnCommandImplCopyWithImpl<$Res>
    extends _$ForwardTurnCommandCopyWithImpl<$Res, _$ForwardTurnCommandImpl>
    implements _$$ForwardTurnCommandImplCopyWith<$Res> {
  __$$ForwardTurnCommandImplCopyWithImpl(
    _$ForwardTurnCommandImpl _value,
    $Res Function(_$ForwardTurnCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForwardTurnCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _$ForwardTurnCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ForwardTurnCommandImpl implements _ForwardTurnCommand {
  const _$ForwardTurnCommandImpl({required this.roomId});

  @override
  final String roomId;

  @override
  String toString() {
    return 'ForwardTurnCommand(roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForwardTurnCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId);

  /// Create a copy of ForwardTurnCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForwardTurnCommandImplCopyWith<_$ForwardTurnCommandImpl> get copyWith =>
      __$$ForwardTurnCommandImplCopyWithImpl<_$ForwardTurnCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _ForwardTurnCommand implements ForwardTurnCommand {
  const factory _ForwardTurnCommand({required final String roomId}) =
      _$ForwardTurnCommandImpl;

  @override
  String get roomId;

  /// Create a copy of ForwardTurnCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForwardTurnCommandImplCopyWith<_$ForwardTurnCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AbandonGameCommand {
  String get roomId => throw _privateConstructorUsedError;

  /// Create a copy of AbandonGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AbandonGameCommandCopyWith<AbandonGameCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AbandonGameCommandCopyWith<$Res> {
  factory $AbandonGameCommandCopyWith(
    AbandonGameCommand value,
    $Res Function(AbandonGameCommand) then,
  ) = _$AbandonGameCommandCopyWithImpl<$Res, AbandonGameCommand>;
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class _$AbandonGameCommandCopyWithImpl<$Res, $Val extends AbandonGameCommand>
    implements $AbandonGameCommandCopyWith<$Res> {
  _$AbandonGameCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AbandonGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AbandonGameCommandImplCopyWith<$Res>
    implements $AbandonGameCommandCopyWith<$Res> {
  factory _$$AbandonGameCommandImplCopyWith(
    _$AbandonGameCommandImpl value,
    $Res Function(_$AbandonGameCommandImpl) then,
  ) = __$$AbandonGameCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class __$$AbandonGameCommandImplCopyWithImpl<$Res>
    extends _$AbandonGameCommandCopyWithImpl<$Res, _$AbandonGameCommandImpl>
    implements _$$AbandonGameCommandImplCopyWith<$Res> {
  __$$AbandonGameCommandImplCopyWithImpl(
    _$AbandonGameCommandImpl _value,
    $Res Function(_$AbandonGameCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AbandonGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _$AbandonGameCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AbandonGameCommandImpl implements _AbandonGameCommand {
  const _$AbandonGameCommandImpl({required this.roomId});

  @override
  final String roomId;

  @override
  String toString() {
    return 'AbandonGameCommand(roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AbandonGameCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId);

  /// Create a copy of AbandonGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AbandonGameCommandImplCopyWith<_$AbandonGameCommandImpl> get copyWith =>
      __$$AbandonGameCommandImplCopyWithImpl<_$AbandonGameCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _AbandonGameCommand implements AbandonGameCommand {
  const factory _AbandonGameCommand({required final String roomId}) =
      _$AbandonGameCommandImpl;

  @override
  String get roomId;

  /// Create a copy of AbandonGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AbandonGameCommandImplCopyWith<_$AbandonGameCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$QuitEndGameCommand {
  String get roomId => throw _privateConstructorUsedError;

  /// Create a copy of QuitEndGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuitEndGameCommandCopyWith<QuitEndGameCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuitEndGameCommandCopyWith<$Res> {
  factory $QuitEndGameCommandCopyWith(
    QuitEndGameCommand value,
    $Res Function(QuitEndGameCommand) then,
  ) = _$QuitEndGameCommandCopyWithImpl<$Res, QuitEndGameCommand>;
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class _$QuitEndGameCommandCopyWithImpl<$Res, $Val extends QuitEndGameCommand>
    implements $QuitEndGameCommandCopyWith<$Res> {
  _$QuitEndGameCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuitEndGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuitEndGameCommandImplCopyWith<$Res>
    implements $QuitEndGameCommandCopyWith<$Res> {
  factory _$$QuitEndGameCommandImplCopyWith(
    _$QuitEndGameCommandImpl value,
    $Res Function(_$QuitEndGameCommandImpl) then,
  ) = __$$QuitEndGameCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class __$$QuitEndGameCommandImplCopyWithImpl<$Res>
    extends _$QuitEndGameCommandCopyWithImpl<$Res, _$QuitEndGameCommandImpl>
    implements _$$QuitEndGameCommandImplCopyWith<$Res> {
  __$$QuitEndGameCommandImplCopyWithImpl(
    _$QuitEndGameCommandImpl _value,
    $Res Function(_$QuitEndGameCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuitEndGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _$QuitEndGameCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$QuitEndGameCommandImpl implements _QuitEndGameCommand {
  const _$QuitEndGameCommandImpl({required this.roomId});

  @override
  final String roomId;

  @override
  String toString() {
    return 'QuitEndGameCommand(roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuitEndGameCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId);

  /// Create a copy of QuitEndGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuitEndGameCommandImplCopyWith<_$QuitEndGameCommandImpl> get copyWith =>
      __$$QuitEndGameCommandImplCopyWithImpl<_$QuitEndGameCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _QuitEndGameCommand implements QuitEndGameCommand {
  const factory _QuitEndGameCommand({required final String roomId}) =
      _$QuitEndGameCommandImpl;

  @override
  String get roomId;

  /// Create a copy of QuitEndGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuitEndGameCommandImplCopyWith<_$QuitEndGameCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VirtualPlayerTurnCommand {
  String get roomId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  bool get isCTF => throw _privateConstructorUsedError;
  bool get skipTimeout => throw _privateConstructorUsedError;

  /// Create a copy of VirtualPlayerTurnCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VirtualPlayerTurnCommandCopyWith<VirtualPlayerTurnCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VirtualPlayerTurnCommandCopyWith<$Res> {
  factory $VirtualPlayerTurnCommandCopyWith(
    VirtualPlayerTurnCommand value,
    $Res Function(VirtualPlayerTurnCommand) then,
  ) = _$VirtualPlayerTurnCommandCopyWithImpl<$Res, VirtualPlayerTurnCommand>;
  @useResult
  $Res call({String roomId, String playerId, bool isCTF, bool skipTimeout});
}

/// @nodoc
class _$VirtualPlayerTurnCommandCopyWithImpl<
  $Res,
  $Val extends VirtualPlayerTurnCommand
>
    implements $VirtualPlayerTurnCommandCopyWith<$Res> {
  _$VirtualPlayerTurnCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VirtualPlayerTurnCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? isCTF = null,
    Object? skipTimeout = null,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            isCTF: null == isCTF
                ? _value.isCTF
                : isCTF // ignore: cast_nullable_to_non_nullable
                      as bool,
            skipTimeout: null == skipTimeout
                ? _value.skipTimeout
                : skipTimeout // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VirtualPlayerTurnCommandImplCopyWith<$Res>
    implements $VirtualPlayerTurnCommandCopyWith<$Res> {
  factory _$$VirtualPlayerTurnCommandImplCopyWith(
    _$VirtualPlayerTurnCommandImpl value,
    $Res Function(_$VirtualPlayerTurnCommandImpl) then,
  ) = __$$VirtualPlayerTurnCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, String playerId, bool isCTF, bool skipTimeout});
}

/// @nodoc
class __$$VirtualPlayerTurnCommandImplCopyWithImpl<$Res>
    extends
        _$VirtualPlayerTurnCommandCopyWithImpl<
          $Res,
          _$VirtualPlayerTurnCommandImpl
        >
    implements _$$VirtualPlayerTurnCommandImplCopyWith<$Res> {
  __$$VirtualPlayerTurnCommandImplCopyWithImpl(
    _$VirtualPlayerTurnCommandImpl _value,
    $Res Function(_$VirtualPlayerTurnCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VirtualPlayerTurnCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? playerId = null,
    Object? isCTF = null,
    Object? skipTimeout = null,
  }) {
    return _then(
      _$VirtualPlayerTurnCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        isCTF: null == isCTF
            ? _value.isCTF
            : isCTF // ignore: cast_nullable_to_non_nullable
                  as bool,
        skipTimeout: null == skipTimeout
            ? _value.skipTimeout
            : skipTimeout // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$VirtualPlayerTurnCommandImpl implements _VirtualPlayerTurnCommand {
  const _$VirtualPlayerTurnCommandImpl({
    required this.roomId,
    required this.playerId,
    required this.isCTF,
    required this.skipTimeout,
  });

  @override
  final String roomId;
  @override
  final String playerId;
  @override
  final bool isCTF;
  @override
  final bool skipTimeout;

  @override
  String toString() {
    return 'VirtualPlayerTurnCommand(roomId: $roomId, playerId: $playerId, isCTF: $isCTF, skipTimeout: $skipTimeout)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VirtualPlayerTurnCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.isCTF, isCTF) || other.isCTF == isCTF) &&
            (identical(other.skipTimeout, skipTimeout) ||
                other.skipTimeout == skipTimeout));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, roomId, playerId, isCTF, skipTimeout);

  /// Create a copy of VirtualPlayerTurnCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VirtualPlayerTurnCommandImplCopyWith<_$VirtualPlayerTurnCommandImpl>
  get copyWith =>
      __$$VirtualPlayerTurnCommandImplCopyWithImpl<
        _$VirtualPlayerTurnCommandImpl
      >(this, _$identity);
}

abstract class _VirtualPlayerTurnCommand implements VirtualPlayerTurnCommand {
  const factory _VirtualPlayerTurnCommand({
    required final String roomId,
    required final String playerId,
    required final bool isCTF,
    required final bool skipTimeout,
  }) = _$VirtualPlayerTurnCommandImpl;

  @override
  String get roomId;
  @override
  String get playerId;
  @override
  bool get isCTF;
  @override
  bool get skipTimeout;

  /// Create a copy of VirtualPlayerTurnCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VirtualPlayerTurnCommandImplCopyWith<_$VirtualPlayerTurnCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FinishGameCommand {
  String get roomId => throw _privateConstructorUsedError;
  String get winnerId => throw _privateConstructorUsedError;

  /// Create a copy of FinishGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinishGameCommandCopyWith<FinishGameCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinishGameCommandCopyWith<$Res> {
  factory $FinishGameCommandCopyWith(
    FinishGameCommand value,
    $Res Function(FinishGameCommand) then,
  ) = _$FinishGameCommandCopyWithImpl<$Res, FinishGameCommand>;
  @useResult
  $Res call({String roomId, String winnerId});
}

/// @nodoc
class _$FinishGameCommandCopyWithImpl<$Res, $Val extends FinishGameCommand>
    implements $FinishGameCommandCopyWith<$Res> {
  _$FinishGameCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinishGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? winnerId = null}) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            winnerId: null == winnerId
                ? _value.winnerId
                : winnerId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FinishGameCommandImplCopyWith<$Res>
    implements $FinishGameCommandCopyWith<$Res> {
  factory _$$FinishGameCommandImplCopyWith(
    _$FinishGameCommandImpl value,
    $Res Function(_$FinishGameCommandImpl) then,
  ) = __$$FinishGameCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, String winnerId});
}

/// @nodoc
class __$$FinishGameCommandImplCopyWithImpl<$Res>
    extends _$FinishGameCommandCopyWithImpl<$Res, _$FinishGameCommandImpl>
    implements _$$FinishGameCommandImplCopyWith<$Res> {
  __$$FinishGameCommandImplCopyWithImpl(
    _$FinishGameCommandImpl _value,
    $Res Function(_$FinishGameCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinishGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? winnerId = null}) {
    return _then(
      _$FinishGameCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        winnerId: null == winnerId
            ? _value.winnerId
            : winnerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FinishGameCommandImpl implements _FinishGameCommand {
  const _$FinishGameCommandImpl({required this.roomId, required this.winnerId});

  @override
  final String roomId;
  @override
  final String winnerId;

  @override
  String toString() {
    return 'FinishGameCommand(roomId: $roomId, winnerId: $winnerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinishGameCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.winnerId, winnerId) ||
                other.winnerId == winnerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, winnerId);

  /// Create a copy of FinishGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinishGameCommandImplCopyWith<_$FinishGameCommandImpl> get copyWith =>
      __$$FinishGameCommandImplCopyWithImpl<_$FinishGameCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _FinishGameCommand implements FinishGameCommand {
  const factory _FinishGameCommand({
    required final String roomId,
    required final String winnerId,
  }) = _$FinishGameCommandImpl;

  @override
  String get roomId;
  @override
  String get winnerId;

  /// Create a copy of FinishGameCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinishGameCommandImplCopyWith<_$FinishGameCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
