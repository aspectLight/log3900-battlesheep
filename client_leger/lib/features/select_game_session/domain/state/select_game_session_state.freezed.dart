// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'select_game_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SelectGameSessionState {
  List<GameModelInfo> get games => throw _privateConstructorUsedError;
  bool get isConfirming => throw _privateConstructorUsedError;
  bool get isLoadingGames => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<GameModelInfo> games,
      bool isConfirming,
      bool isLoadingGames,
    )
    loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<GameModelInfo> games,
      bool isConfirming,
      bool isLoadingGames,
    )?
    loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<GameModelInfo> games,
      bool isConfirming,
      bool isLoadingGames,
    )?
    loaded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SelectGameSessionStateLoaded value) loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SelectGameSessionStateLoaded value)? loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SelectGameSessionStateLoaded value)? loaded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of SelectGameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectGameSessionStateCopyWith<SelectGameSessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectGameSessionStateCopyWith<$Res> {
  factory $SelectGameSessionStateCopyWith(
    SelectGameSessionState value,
    $Res Function(SelectGameSessionState) then,
  ) = _$SelectGameSessionStateCopyWithImpl<$Res, SelectGameSessionState>;
  @useResult
  $Res call({
    List<GameModelInfo> games,
    bool isConfirming,
    bool isLoadingGames,
  });
}

/// @nodoc
class _$SelectGameSessionStateCopyWithImpl<
  $Res,
  $Val extends SelectGameSessionState
>
    implements $SelectGameSessionStateCopyWith<$Res> {
  _$SelectGameSessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectGameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? games = null,
    Object? isConfirming = null,
    Object? isLoadingGames = null,
  }) {
    return _then(
      _value.copyWith(
            games: null == games
                ? _value.games
                : games // ignore: cast_nullable_to_non_nullable
                      as List<GameModelInfo>,
            isConfirming: null == isConfirming
                ? _value.isConfirming
                : isConfirming // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoadingGames: null == isLoadingGames
                ? _value.isLoadingGames
                : isLoadingGames // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SelectGameSessionStateLoadedImplCopyWith<$Res>
    implements $SelectGameSessionStateCopyWith<$Res> {
  factory _$$SelectGameSessionStateLoadedImplCopyWith(
    _$SelectGameSessionStateLoadedImpl value,
    $Res Function(_$SelectGameSessionStateLoadedImpl) then,
  ) = __$$SelectGameSessionStateLoadedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<GameModelInfo> games,
    bool isConfirming,
    bool isLoadingGames,
  });
}

/// @nodoc
class __$$SelectGameSessionStateLoadedImplCopyWithImpl<$Res>
    extends
        _$SelectGameSessionStateCopyWithImpl<
          $Res,
          _$SelectGameSessionStateLoadedImpl
        >
    implements _$$SelectGameSessionStateLoadedImplCopyWith<$Res> {
  __$$SelectGameSessionStateLoadedImplCopyWithImpl(
    _$SelectGameSessionStateLoadedImpl _value,
    $Res Function(_$SelectGameSessionStateLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SelectGameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? games = null,
    Object? isConfirming = null,
    Object? isLoadingGames = null,
  }) {
    return _then(
      _$SelectGameSessionStateLoadedImpl(
        games: null == games
            ? _value._games
            : games // ignore: cast_nullable_to_non_nullable
                  as List<GameModelInfo>,
        isConfirming: null == isConfirming
            ? _value.isConfirming
            : isConfirming // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoadingGames: null == isLoadingGames
            ? _value.isLoadingGames
            : isLoadingGames // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SelectGameSessionStateLoadedImpl
    implements SelectGameSessionStateLoaded {
  const _$SelectGameSessionStateLoadedImpl({
    required final List<GameModelInfo> games,
    this.isConfirming = false,
    this.isLoadingGames = false,
  }) : _games = games;

  final List<GameModelInfo> _games;
  @override
  List<GameModelInfo> get games {
    if (_games is EqualUnmodifiableListView) return _games;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_games);
  }

  @override
  @JsonKey()
  final bool isConfirming;
  @override
  @JsonKey()
  final bool isLoadingGames;

  @override
  String toString() {
    return 'SelectGameSessionState.loaded(games: $games, isConfirming: $isConfirming, isLoadingGames: $isLoadingGames)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectGameSessionStateLoadedImpl &&
            const DeepCollectionEquality().equals(other._games, _games) &&
            (identical(other.isConfirming, isConfirming) ||
                other.isConfirming == isConfirming) &&
            (identical(other.isLoadingGames, isLoadingGames) ||
                other.isLoadingGames == isLoadingGames));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_games),
    isConfirming,
    isLoadingGames,
  );

  /// Create a copy of SelectGameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectGameSessionStateLoadedImplCopyWith<
    _$SelectGameSessionStateLoadedImpl
  >
  get copyWith =>
      __$$SelectGameSessionStateLoadedImplCopyWithImpl<
        _$SelectGameSessionStateLoadedImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<GameModelInfo> games,
      bool isConfirming,
      bool isLoadingGames,
    )
    loaded,
  }) {
    return loaded(games, isConfirming, isLoadingGames);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<GameModelInfo> games,
      bool isConfirming,
      bool isLoadingGames,
    )?
    loaded,
  }) {
    return loaded?.call(games, isConfirming, isLoadingGames);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<GameModelInfo> games,
      bool isConfirming,
      bool isLoadingGames,
    )?
    loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(games, isConfirming, isLoadingGames);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SelectGameSessionStateLoaded value) loaded,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SelectGameSessionStateLoaded value)? loaded,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SelectGameSessionStateLoaded value)? loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class SelectGameSessionStateLoaded implements SelectGameSessionState {
  const factory SelectGameSessionStateLoaded({
    required final List<GameModelInfo> games,
    final bool isConfirming,
    final bool isLoadingGames,
  }) = _$SelectGameSessionStateLoadedImpl;

  @override
  List<GameModelInfo> get games;
  @override
  bool get isConfirming;
  @override
  bool get isLoadingGames;

  /// Create a copy of SelectGameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectGameSessionStateLoadedImplCopyWith<
    _$SelectGameSessionStateLoadedImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
