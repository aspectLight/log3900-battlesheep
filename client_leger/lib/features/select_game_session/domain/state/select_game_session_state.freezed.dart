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
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<GameModelInfo> games,
      Option<String> selectedGameId,
      bool isConfirming,
    )
    loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
      List<GameModelInfo> games,
      Option<String> selectedGameId,
      bool isConfirming,
    )?
    loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
      List<GameModelInfo> games,
      Option<String> selectedGameId,
      bool isConfirming,
    )?
    loaded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SelectGameSessionStateLoading value) loading,
    required TResult Function(SelectGameSessionStateLoaded value) loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SelectGameSessionStateLoading value)? loading,
    TResult? Function(SelectGameSessionStateLoaded value)? loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SelectGameSessionStateLoading value)? loading,
    TResult Function(SelectGameSessionStateLoaded value)? loaded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectGameSessionStateCopyWith<$Res> {
  factory $SelectGameSessionStateCopyWith(
    SelectGameSessionState value,
    $Res Function(SelectGameSessionState) then,
  ) = _$SelectGameSessionStateCopyWithImpl<$Res, SelectGameSessionState>;
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
}

/// @nodoc
abstract class _$$SelectGameSessionStateLoadingImplCopyWith<$Res> {
  factory _$$SelectGameSessionStateLoadingImplCopyWith(
    _$SelectGameSessionStateLoadingImpl value,
    $Res Function(_$SelectGameSessionStateLoadingImpl) then,
  ) = __$$SelectGameSessionStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SelectGameSessionStateLoadingImplCopyWithImpl<$Res>
    extends
        _$SelectGameSessionStateCopyWithImpl<
          $Res,
          _$SelectGameSessionStateLoadingImpl
        >
    implements _$$SelectGameSessionStateLoadingImplCopyWith<$Res> {
  __$$SelectGameSessionStateLoadingImplCopyWithImpl(
    _$SelectGameSessionStateLoadingImpl _value,
    $Res Function(_$SelectGameSessionStateLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SelectGameSessionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SelectGameSessionStateLoadingImpl
    implements SelectGameSessionStateLoading {
  const _$SelectGameSessionStateLoadingImpl();

  @override
  String toString() {
    return 'SelectGameSessionState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectGameSessionStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<GameModelInfo> games,
      Option<String> selectedGameId,
      bool isConfirming,
    )
    loaded,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
      List<GameModelInfo> games,
      Option<String> selectedGameId,
      bool isConfirming,
    )?
    loaded,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
      List<GameModelInfo> games,
      Option<String> selectedGameId,
      bool isConfirming,
    )?
    loaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SelectGameSessionStateLoading value) loading,
    required TResult Function(SelectGameSessionStateLoaded value) loaded,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SelectGameSessionStateLoading value)? loading,
    TResult? Function(SelectGameSessionStateLoaded value)? loaded,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SelectGameSessionStateLoading value)? loading,
    TResult Function(SelectGameSessionStateLoaded value)? loaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SelectGameSessionStateLoading implements SelectGameSessionState {
  const factory SelectGameSessionStateLoading() =
      _$SelectGameSessionStateLoadingImpl;
}

/// @nodoc
abstract class _$$SelectGameSessionStateLoadedImplCopyWith<$Res> {
  factory _$$SelectGameSessionStateLoadedImplCopyWith(
    _$SelectGameSessionStateLoadedImpl value,
    $Res Function(_$SelectGameSessionStateLoadedImpl) then,
  ) = __$$SelectGameSessionStateLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<GameModelInfo> games,
    Option<String> selectedGameId,
    bool isConfirming,
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
    Object? selectedGameId = null,
    Object? isConfirming = null,
  }) {
    return _then(
      _$SelectGameSessionStateLoadedImpl(
        games: null == games
            ? _value._games
            : games // ignore: cast_nullable_to_non_nullable
                  as List<GameModelInfo>,
        selectedGameId: null == selectedGameId
            ? _value.selectedGameId
            : selectedGameId // ignore: cast_nullable_to_non_nullable
                  as Option<String>,
        isConfirming: null == isConfirming
            ? _value.isConfirming
            : isConfirming // ignore: cast_nullable_to_non_nullable
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
    required this.selectedGameId,
    this.isConfirming = false,
  }) : _games = games;

  final List<GameModelInfo> _games;
  @override
  List<GameModelInfo> get games {
    if (_games is EqualUnmodifiableListView) return _games;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_games);
  }

  @override
  final Option<String> selectedGameId;
  @override
  @JsonKey()
  final bool isConfirming;

  @override
  String toString() {
    return 'SelectGameSessionState.loaded(games: $games, selectedGameId: $selectedGameId, isConfirming: $isConfirming)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectGameSessionStateLoadedImpl &&
            const DeepCollectionEquality().equals(other._games, _games) &&
            (identical(other.selectedGameId, selectedGameId) ||
                other.selectedGameId == selectedGameId) &&
            (identical(other.isConfirming, isConfirming) ||
                other.isConfirming == isConfirming));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_games),
    selectedGameId,
    isConfirming,
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
    required TResult Function() loading,
    required TResult Function(
      List<GameModelInfo> games,
      Option<String> selectedGameId,
      bool isConfirming,
    )
    loaded,
  }) {
    return loaded(games, selectedGameId, isConfirming);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
      List<GameModelInfo> games,
      Option<String> selectedGameId,
      bool isConfirming,
    )?
    loaded,
  }) {
    return loaded?.call(games, selectedGameId, isConfirming);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
      List<GameModelInfo> games,
      Option<String> selectedGameId,
      bool isConfirming,
    )?
    loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(games, selectedGameId, isConfirming);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SelectGameSessionStateLoading value) loading,
    required TResult Function(SelectGameSessionStateLoaded value) loaded,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SelectGameSessionStateLoading value)? loading,
    TResult? Function(SelectGameSessionStateLoaded value)? loaded,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SelectGameSessionStateLoading value)? loading,
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
    required final Option<String> selectedGameId,
    final bool isConfirming,
  }) = _$SelectGameSessionStateLoadedImpl;

  List<GameModelInfo> get games;
  Option<String> get selectedGameId;
  bool get isConfirming;

  /// Create a copy of SelectGameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectGameSessionStateLoadedImplCopyWith<
    _$SelectGameSessionStateLoadedImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
