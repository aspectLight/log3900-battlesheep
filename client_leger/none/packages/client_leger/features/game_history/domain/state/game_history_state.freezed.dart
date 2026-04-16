// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameHistoryState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(List<GameHistoryItem> items) loaded,
    required TResult Function(GameHistoryFailure failure) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(List<GameHistoryItem> items)? loaded,
    TResult? Function(GameHistoryFailure failure)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(List<GameHistoryItem> items)? loaded,
    TResult Function(GameHistoryFailure failure)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GameHistoryStateIdle value) idle,
    required TResult Function(GameHistoryStateLoading value) loading,
    required TResult Function(GameHistoryStateLoaded value) loaded,
    required TResult Function(GameHistoryStateError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GameHistoryStateIdle value)? idle,
    TResult? Function(GameHistoryStateLoading value)? loading,
    TResult? Function(GameHistoryStateLoaded value)? loaded,
    TResult? Function(GameHistoryStateError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GameHistoryStateIdle value)? idle,
    TResult Function(GameHistoryStateLoading value)? loading,
    TResult Function(GameHistoryStateLoaded value)? loaded,
    TResult Function(GameHistoryStateError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameHistoryStateCopyWith<$Res> {
  factory $GameHistoryStateCopyWith(
    GameHistoryState value,
    $Res Function(GameHistoryState) then,
  ) = _$GameHistoryStateCopyWithImpl<$Res, GameHistoryState>;
}

/// @nodoc
class _$GameHistoryStateCopyWithImpl<$Res, $Val extends GameHistoryState>
    implements $GameHistoryStateCopyWith<$Res> {
  _$GameHistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameHistoryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GameHistoryStateIdleImplCopyWith<$Res> {
  factory _$$GameHistoryStateIdleImplCopyWith(
    _$GameHistoryStateIdleImpl value,
    $Res Function(_$GameHistoryStateIdleImpl) then,
  ) = __$$GameHistoryStateIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GameHistoryStateIdleImplCopyWithImpl<$Res>
    extends _$GameHistoryStateCopyWithImpl<$Res, _$GameHistoryStateIdleImpl>
    implements _$$GameHistoryStateIdleImplCopyWith<$Res> {
  __$$GameHistoryStateIdleImplCopyWithImpl(
    _$GameHistoryStateIdleImpl _value,
    $Res Function(_$GameHistoryStateIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameHistoryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GameHistoryStateIdleImpl implements GameHistoryStateIdle {
  const _$GameHistoryStateIdleImpl();

  @override
  String toString() {
    return 'GameHistoryState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameHistoryStateIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(List<GameHistoryItem> items) loaded,
    required TResult Function(GameHistoryFailure failure) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(List<GameHistoryItem> items)? loaded,
    TResult? Function(GameHistoryFailure failure)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(List<GameHistoryItem> items)? loaded,
    TResult Function(GameHistoryFailure failure)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GameHistoryStateIdle value) idle,
    required TResult Function(GameHistoryStateLoading value) loading,
    required TResult Function(GameHistoryStateLoaded value) loaded,
    required TResult Function(GameHistoryStateError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GameHistoryStateIdle value)? idle,
    TResult? Function(GameHistoryStateLoading value)? loading,
    TResult? Function(GameHistoryStateLoaded value)? loaded,
    TResult? Function(GameHistoryStateError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GameHistoryStateIdle value)? idle,
    TResult Function(GameHistoryStateLoading value)? loading,
    TResult Function(GameHistoryStateLoaded value)? loaded,
    TResult Function(GameHistoryStateError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class GameHistoryStateIdle implements GameHistoryState {
  const factory GameHistoryStateIdle() = _$GameHistoryStateIdleImpl;
}

/// @nodoc
abstract class _$$GameHistoryStateLoadingImplCopyWith<$Res> {
  factory _$$GameHistoryStateLoadingImplCopyWith(
    _$GameHistoryStateLoadingImpl value,
    $Res Function(_$GameHistoryStateLoadingImpl) then,
  ) = __$$GameHistoryStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GameHistoryStateLoadingImplCopyWithImpl<$Res>
    extends _$GameHistoryStateCopyWithImpl<$Res, _$GameHistoryStateLoadingImpl>
    implements _$$GameHistoryStateLoadingImplCopyWith<$Res> {
  __$$GameHistoryStateLoadingImplCopyWithImpl(
    _$GameHistoryStateLoadingImpl _value,
    $Res Function(_$GameHistoryStateLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameHistoryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GameHistoryStateLoadingImpl implements GameHistoryStateLoading {
  const _$GameHistoryStateLoadingImpl();

  @override
  String toString() {
    return 'GameHistoryState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameHistoryStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(List<GameHistoryItem> items) loaded,
    required TResult Function(GameHistoryFailure failure) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(List<GameHistoryItem> items)? loaded,
    TResult? Function(GameHistoryFailure failure)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(List<GameHistoryItem> items)? loaded,
    TResult Function(GameHistoryFailure failure)? error,
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
    required TResult Function(GameHistoryStateIdle value) idle,
    required TResult Function(GameHistoryStateLoading value) loading,
    required TResult Function(GameHistoryStateLoaded value) loaded,
    required TResult Function(GameHistoryStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GameHistoryStateIdle value)? idle,
    TResult? Function(GameHistoryStateLoading value)? loading,
    TResult? Function(GameHistoryStateLoaded value)? loaded,
    TResult? Function(GameHistoryStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GameHistoryStateIdle value)? idle,
    TResult Function(GameHistoryStateLoading value)? loading,
    TResult Function(GameHistoryStateLoaded value)? loaded,
    TResult Function(GameHistoryStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class GameHistoryStateLoading implements GameHistoryState {
  const factory GameHistoryStateLoading() = _$GameHistoryStateLoadingImpl;
}

/// @nodoc
abstract class _$$GameHistoryStateLoadedImplCopyWith<$Res> {
  factory _$$GameHistoryStateLoadedImplCopyWith(
    _$GameHistoryStateLoadedImpl value,
    $Res Function(_$GameHistoryStateLoadedImpl) then,
  ) = __$$GameHistoryStateLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<GameHistoryItem> items});
}

/// @nodoc
class __$$GameHistoryStateLoadedImplCopyWithImpl<$Res>
    extends _$GameHistoryStateCopyWithImpl<$Res, _$GameHistoryStateLoadedImpl>
    implements _$$GameHistoryStateLoadedImplCopyWith<$Res> {
  __$$GameHistoryStateLoadedImplCopyWithImpl(
    _$GameHistoryStateLoadedImpl _value,
    $Res Function(_$GameHistoryStateLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null}) {
    return _then(
      _$GameHistoryStateLoadedImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<GameHistoryItem>,
      ),
    );
  }
}

/// @nodoc

class _$GameHistoryStateLoadedImpl implements GameHistoryStateLoaded {
  const _$GameHistoryStateLoadedImpl({
    required final List<GameHistoryItem> items,
  }) : _items = items;

  final List<GameHistoryItem> _items;
  @override
  List<GameHistoryItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'GameHistoryState.loaded(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameHistoryStateLoadedImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of GameHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameHistoryStateLoadedImplCopyWith<_$GameHistoryStateLoadedImpl>
  get copyWith =>
      __$$GameHistoryStateLoadedImplCopyWithImpl<_$GameHistoryStateLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(List<GameHistoryItem> items) loaded,
    required TResult Function(GameHistoryFailure failure) error,
  }) {
    return loaded(items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(List<GameHistoryItem> items)? loaded,
    TResult? Function(GameHistoryFailure failure)? error,
  }) {
    return loaded?.call(items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(List<GameHistoryItem> items)? loaded,
    TResult Function(GameHistoryFailure failure)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(items);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GameHistoryStateIdle value) idle,
    required TResult Function(GameHistoryStateLoading value) loading,
    required TResult Function(GameHistoryStateLoaded value) loaded,
    required TResult Function(GameHistoryStateError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GameHistoryStateIdle value)? idle,
    TResult? Function(GameHistoryStateLoading value)? loading,
    TResult? Function(GameHistoryStateLoaded value)? loaded,
    TResult? Function(GameHistoryStateError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GameHistoryStateIdle value)? idle,
    TResult Function(GameHistoryStateLoading value)? loading,
    TResult Function(GameHistoryStateLoaded value)? loaded,
    TResult Function(GameHistoryStateError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class GameHistoryStateLoaded implements GameHistoryState {
  const factory GameHistoryStateLoaded({
    required final List<GameHistoryItem> items,
  }) = _$GameHistoryStateLoadedImpl;

  List<GameHistoryItem> get items;

  /// Create a copy of GameHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameHistoryStateLoadedImplCopyWith<_$GameHistoryStateLoadedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GameHistoryStateErrorImplCopyWith<$Res> {
  factory _$$GameHistoryStateErrorImplCopyWith(
    _$GameHistoryStateErrorImpl value,
    $Res Function(_$GameHistoryStateErrorImpl) then,
  ) = __$$GameHistoryStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({GameHistoryFailure failure});
}

/// @nodoc
class __$$GameHistoryStateErrorImplCopyWithImpl<$Res>
    extends _$GameHistoryStateCopyWithImpl<$Res, _$GameHistoryStateErrorImpl>
    implements _$$GameHistoryStateErrorImplCopyWith<$Res> {
  __$$GameHistoryStateErrorImplCopyWithImpl(
    _$GameHistoryStateErrorImpl _value,
    $Res Function(_$GameHistoryStateErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null}) {
    return _then(
      _$GameHistoryStateErrorImpl(
        null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as GameHistoryFailure,
      ),
    );
  }
}

/// @nodoc

class _$GameHistoryStateErrorImpl implements GameHistoryStateError {
  const _$GameHistoryStateErrorImpl(this.failure);

  @override
  final GameHistoryFailure failure;

  @override
  String toString() {
    return 'GameHistoryState.error(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameHistoryStateErrorImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of GameHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameHistoryStateErrorImplCopyWith<_$GameHistoryStateErrorImpl>
  get copyWith =>
      __$$GameHistoryStateErrorImplCopyWithImpl<_$GameHistoryStateErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(List<GameHistoryItem> items) loaded,
    required TResult Function(GameHistoryFailure failure) error,
  }) {
    return error(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(List<GameHistoryItem> items)? loaded,
    TResult? Function(GameHistoryFailure failure)? error,
  }) {
    return error?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(List<GameHistoryItem> items)? loaded,
    TResult Function(GameHistoryFailure failure)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GameHistoryStateIdle value) idle,
    required TResult Function(GameHistoryStateLoading value) loading,
    required TResult Function(GameHistoryStateLoaded value) loaded,
    required TResult Function(GameHistoryStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GameHistoryStateIdle value)? idle,
    TResult? Function(GameHistoryStateLoading value)? loading,
    TResult? Function(GameHistoryStateLoaded value)? loaded,
    TResult? Function(GameHistoryStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GameHistoryStateIdle value)? idle,
    TResult Function(GameHistoryStateLoading value)? loading,
    TResult Function(GameHistoryStateLoaded value)? loaded,
    TResult Function(GameHistoryStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class GameHistoryStateError implements GameHistoryState {
  const factory GameHistoryStateError(final GameHistoryFailure failure) =
      _$GameHistoryStateErrorImpl;

  GameHistoryFailure get failure;

  /// Create a copy of GameHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameHistoryStateErrorImplCopyWith<_$GameHistoryStateErrorImpl>
  get copyWith => throw _privateConstructorUsedError;
}
