// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_turn_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameTurnState {
  String get currentPlayerId => throw _privateConstructorUsedError;
  int get turnCountdown => throw _privateConstructorUsedError;
  int get startCountdown => throw _privateConstructorUsedError;
  bool get canForwardTurn => throw _privateConstructorUsedError;

  /// Create a copy of GameTurnState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameTurnStateCopyWith<GameTurnState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameTurnStateCopyWith<$Res> {
  factory $GameTurnStateCopyWith(
    GameTurnState value,
    $Res Function(GameTurnState) then,
  ) = _$GameTurnStateCopyWithImpl<$Res, GameTurnState>;
  @useResult
  $Res call({
    String currentPlayerId,
    int turnCountdown,
    int startCountdown,
    bool canForwardTurn,
  });
}

/// @nodoc
class _$GameTurnStateCopyWithImpl<$Res, $Val extends GameTurnState>
    implements $GameTurnStateCopyWith<$Res> {
  _$GameTurnStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameTurnState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPlayerId = null,
    Object? turnCountdown = null,
    Object? startCountdown = null,
    Object? canForwardTurn = null,
  }) {
    return _then(
      _value.copyWith(
            currentPlayerId: null == currentPlayerId
                ? _value.currentPlayerId
                : currentPlayerId // ignore: cast_nullable_to_non_nullable
                      as String,
            turnCountdown: null == turnCountdown
                ? _value.turnCountdown
                : turnCountdown // ignore: cast_nullable_to_non_nullable
                      as int,
            startCountdown: null == startCountdown
                ? _value.startCountdown
                : startCountdown // ignore: cast_nullable_to_non_nullable
                      as int,
            canForwardTurn: null == canForwardTurn
                ? _value.canForwardTurn
                : canForwardTurn // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameTurnStateImplCopyWith<$Res>
    implements $GameTurnStateCopyWith<$Res> {
  factory _$$GameTurnStateImplCopyWith(
    _$GameTurnStateImpl value,
    $Res Function(_$GameTurnStateImpl) then,
  ) = __$$GameTurnStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String currentPlayerId,
    int turnCountdown,
    int startCountdown,
    bool canForwardTurn,
  });
}

/// @nodoc
class __$$GameTurnStateImplCopyWithImpl<$Res>
    extends _$GameTurnStateCopyWithImpl<$Res, _$GameTurnStateImpl>
    implements _$$GameTurnStateImplCopyWith<$Res> {
  __$$GameTurnStateImplCopyWithImpl(
    _$GameTurnStateImpl _value,
    $Res Function(_$GameTurnStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameTurnState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPlayerId = null,
    Object? turnCountdown = null,
    Object? startCountdown = null,
    Object? canForwardTurn = null,
  }) {
    return _then(
      _$GameTurnStateImpl(
        currentPlayerId: null == currentPlayerId
            ? _value.currentPlayerId
            : currentPlayerId // ignore: cast_nullable_to_non_nullable
                  as String,
        turnCountdown: null == turnCountdown
            ? _value.turnCountdown
            : turnCountdown // ignore: cast_nullable_to_non_nullable
                  as int,
        startCountdown: null == startCountdown
            ? _value.startCountdown
            : startCountdown // ignore: cast_nullable_to_non_nullable
                  as int,
        canForwardTurn: null == canForwardTurn
            ? _value.canForwardTurn
            : canForwardTurn // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$GameTurnStateImpl extends _GameTurnState {
  const _$GameTurnStateImpl({
    required this.currentPlayerId,
    required this.turnCountdown,
    required this.startCountdown,
    required this.canForwardTurn,
  }) : super._();

  @override
  final String currentPlayerId;
  @override
  final int turnCountdown;
  @override
  final int startCountdown;
  @override
  final bool canForwardTurn;

  @override
  String toString() {
    return 'GameTurnState(currentPlayerId: $currentPlayerId, turnCountdown: $turnCountdown, startCountdown: $startCountdown, canForwardTurn: $canForwardTurn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameTurnStateImpl &&
            (identical(other.currentPlayerId, currentPlayerId) ||
                other.currentPlayerId == currentPlayerId) &&
            (identical(other.turnCountdown, turnCountdown) ||
                other.turnCountdown == turnCountdown) &&
            (identical(other.startCountdown, startCountdown) ||
                other.startCountdown == startCountdown) &&
            (identical(other.canForwardTurn, canForwardTurn) ||
                other.canForwardTurn == canForwardTurn));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentPlayerId,
    turnCountdown,
    startCountdown,
    canForwardTurn,
  );

  /// Create a copy of GameTurnState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameTurnStateImplCopyWith<_$GameTurnStateImpl> get copyWith =>
      __$$GameTurnStateImplCopyWithImpl<_$GameTurnStateImpl>(this, _$identity);
}

abstract class _GameTurnState extends GameTurnState {
  const factory _GameTurnState({
    required final String currentPlayerId,
    required final int turnCountdown,
    required final int startCountdown,
    required final bool canForwardTurn,
  }) = _$GameTurnStateImpl;
  const _GameTurnState._() : super._();

  @override
  String get currentPlayerId;
  @override
  int get turnCountdown;
  @override
  int get startCountdown;
  @override
  bool get canForwardTurn;

  /// Create a copy of GameTurnState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameTurnStateImplCopyWith<_$GameTurnStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
