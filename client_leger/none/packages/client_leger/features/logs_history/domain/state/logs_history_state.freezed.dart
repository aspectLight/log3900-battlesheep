// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'logs_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LogsHistoryState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(List<LogsHistoryItem> items) loaded,
    required TResult Function(LogsHistoryFailure failure) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(List<LogsHistoryItem> items)? loaded,
    TResult? Function(LogsHistoryFailure failure)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(List<LogsHistoryItem> items)? loaded,
    TResult Function(LogsHistoryFailure failure)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LogsHistoryStateIdle value) idle,
    required TResult Function(LogsHistoryStateLoading value) loading,
    required TResult Function(LogsHistoryStateLoaded value) loaded,
    required TResult Function(LogsHistoryStateError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LogsHistoryStateIdle value)? idle,
    TResult? Function(LogsHistoryStateLoading value)? loading,
    TResult? Function(LogsHistoryStateLoaded value)? loaded,
    TResult? Function(LogsHistoryStateError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LogsHistoryStateIdle value)? idle,
    TResult Function(LogsHistoryStateLoading value)? loading,
    TResult Function(LogsHistoryStateLoaded value)? loaded,
    TResult Function(LogsHistoryStateError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogsHistoryStateCopyWith<$Res> {
  factory $LogsHistoryStateCopyWith(
    LogsHistoryState value,
    $Res Function(LogsHistoryState) then,
  ) = _$LogsHistoryStateCopyWithImpl<$Res, LogsHistoryState>;
}

/// @nodoc
class _$LogsHistoryStateCopyWithImpl<$Res, $Val extends LogsHistoryState>
    implements $LogsHistoryStateCopyWith<$Res> {
  _$LogsHistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogsHistoryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LogsHistoryStateIdleImplCopyWith<$Res> {
  factory _$$LogsHistoryStateIdleImplCopyWith(
    _$LogsHistoryStateIdleImpl value,
    $Res Function(_$LogsHistoryStateIdleImpl) then,
  ) = __$$LogsHistoryStateIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LogsHistoryStateIdleImplCopyWithImpl<$Res>
    extends _$LogsHistoryStateCopyWithImpl<$Res, _$LogsHistoryStateIdleImpl>
    implements _$$LogsHistoryStateIdleImplCopyWith<$Res> {
  __$$LogsHistoryStateIdleImplCopyWithImpl(
    _$LogsHistoryStateIdleImpl _value,
    $Res Function(_$LogsHistoryStateIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogsHistoryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LogsHistoryStateIdleImpl implements LogsHistoryStateIdle {
  const _$LogsHistoryStateIdleImpl();

  @override
  String toString() {
    return 'LogsHistoryState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogsHistoryStateIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(List<LogsHistoryItem> items) loaded,
    required TResult Function(LogsHistoryFailure failure) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(List<LogsHistoryItem> items)? loaded,
    TResult? Function(LogsHistoryFailure failure)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(List<LogsHistoryItem> items)? loaded,
    TResult Function(LogsHistoryFailure failure)? error,
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
    required TResult Function(LogsHistoryStateIdle value) idle,
    required TResult Function(LogsHistoryStateLoading value) loading,
    required TResult Function(LogsHistoryStateLoaded value) loaded,
    required TResult Function(LogsHistoryStateError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LogsHistoryStateIdle value)? idle,
    TResult? Function(LogsHistoryStateLoading value)? loading,
    TResult? Function(LogsHistoryStateLoaded value)? loaded,
    TResult? Function(LogsHistoryStateError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LogsHistoryStateIdle value)? idle,
    TResult Function(LogsHistoryStateLoading value)? loading,
    TResult Function(LogsHistoryStateLoaded value)? loaded,
    TResult Function(LogsHistoryStateError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class LogsHistoryStateIdle implements LogsHistoryState {
  const factory LogsHistoryStateIdle() = _$LogsHistoryStateIdleImpl;
}

/// @nodoc
abstract class _$$LogsHistoryStateLoadingImplCopyWith<$Res> {
  factory _$$LogsHistoryStateLoadingImplCopyWith(
    _$LogsHistoryStateLoadingImpl value,
    $Res Function(_$LogsHistoryStateLoadingImpl) then,
  ) = __$$LogsHistoryStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LogsHistoryStateLoadingImplCopyWithImpl<$Res>
    extends _$LogsHistoryStateCopyWithImpl<$Res, _$LogsHistoryStateLoadingImpl>
    implements _$$LogsHistoryStateLoadingImplCopyWith<$Res> {
  __$$LogsHistoryStateLoadingImplCopyWithImpl(
    _$LogsHistoryStateLoadingImpl _value,
    $Res Function(_$LogsHistoryStateLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogsHistoryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LogsHistoryStateLoadingImpl implements LogsHistoryStateLoading {
  const _$LogsHistoryStateLoadingImpl();

  @override
  String toString() {
    return 'LogsHistoryState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogsHistoryStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(List<LogsHistoryItem> items) loaded,
    required TResult Function(LogsHistoryFailure failure) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(List<LogsHistoryItem> items)? loaded,
    TResult? Function(LogsHistoryFailure failure)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(List<LogsHistoryItem> items)? loaded,
    TResult Function(LogsHistoryFailure failure)? error,
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
    required TResult Function(LogsHistoryStateIdle value) idle,
    required TResult Function(LogsHistoryStateLoading value) loading,
    required TResult Function(LogsHistoryStateLoaded value) loaded,
    required TResult Function(LogsHistoryStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LogsHistoryStateIdle value)? idle,
    TResult? Function(LogsHistoryStateLoading value)? loading,
    TResult? Function(LogsHistoryStateLoaded value)? loaded,
    TResult? Function(LogsHistoryStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LogsHistoryStateIdle value)? idle,
    TResult Function(LogsHistoryStateLoading value)? loading,
    TResult Function(LogsHistoryStateLoaded value)? loaded,
    TResult Function(LogsHistoryStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class LogsHistoryStateLoading implements LogsHistoryState {
  const factory LogsHistoryStateLoading() = _$LogsHistoryStateLoadingImpl;
}

/// @nodoc
abstract class _$$LogsHistoryStateLoadedImplCopyWith<$Res> {
  factory _$$LogsHistoryStateLoadedImplCopyWith(
    _$LogsHistoryStateLoadedImpl value,
    $Res Function(_$LogsHistoryStateLoadedImpl) then,
  ) = __$$LogsHistoryStateLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<LogsHistoryItem> items});
}

/// @nodoc
class __$$LogsHistoryStateLoadedImplCopyWithImpl<$Res>
    extends _$LogsHistoryStateCopyWithImpl<$Res, _$LogsHistoryStateLoadedImpl>
    implements _$$LogsHistoryStateLoadedImplCopyWith<$Res> {
  __$$LogsHistoryStateLoadedImplCopyWithImpl(
    _$LogsHistoryStateLoadedImpl _value,
    $Res Function(_$LogsHistoryStateLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogsHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null}) {
    return _then(
      _$LogsHistoryStateLoadedImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<LogsHistoryItem>,
      ),
    );
  }
}

/// @nodoc

class _$LogsHistoryStateLoadedImpl implements LogsHistoryStateLoaded {
  const _$LogsHistoryStateLoadedImpl({
    required final List<LogsHistoryItem> items,
  }) : _items = items;

  final List<LogsHistoryItem> _items;
  @override
  List<LogsHistoryItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'LogsHistoryState.loaded(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogsHistoryStateLoadedImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of LogsHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogsHistoryStateLoadedImplCopyWith<_$LogsHistoryStateLoadedImpl>
  get copyWith =>
      __$$LogsHistoryStateLoadedImplCopyWithImpl<_$LogsHistoryStateLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(List<LogsHistoryItem> items) loaded,
    required TResult Function(LogsHistoryFailure failure) error,
  }) {
    return loaded(items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(List<LogsHistoryItem> items)? loaded,
    TResult? Function(LogsHistoryFailure failure)? error,
  }) {
    return loaded?.call(items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(List<LogsHistoryItem> items)? loaded,
    TResult Function(LogsHistoryFailure failure)? error,
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
    required TResult Function(LogsHistoryStateIdle value) idle,
    required TResult Function(LogsHistoryStateLoading value) loading,
    required TResult Function(LogsHistoryStateLoaded value) loaded,
    required TResult Function(LogsHistoryStateError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LogsHistoryStateIdle value)? idle,
    TResult? Function(LogsHistoryStateLoading value)? loading,
    TResult? Function(LogsHistoryStateLoaded value)? loaded,
    TResult? Function(LogsHistoryStateError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LogsHistoryStateIdle value)? idle,
    TResult Function(LogsHistoryStateLoading value)? loading,
    TResult Function(LogsHistoryStateLoaded value)? loaded,
    TResult Function(LogsHistoryStateError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class LogsHistoryStateLoaded implements LogsHistoryState {
  const factory LogsHistoryStateLoaded({
    required final List<LogsHistoryItem> items,
  }) = _$LogsHistoryStateLoadedImpl;

  List<LogsHistoryItem> get items;

  /// Create a copy of LogsHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogsHistoryStateLoadedImplCopyWith<_$LogsHistoryStateLoadedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LogsHistoryStateErrorImplCopyWith<$Res> {
  factory _$$LogsHistoryStateErrorImplCopyWith(
    _$LogsHistoryStateErrorImpl value,
    $Res Function(_$LogsHistoryStateErrorImpl) then,
  ) = __$$LogsHistoryStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LogsHistoryFailure failure});
}

/// @nodoc
class __$$LogsHistoryStateErrorImplCopyWithImpl<$Res>
    extends _$LogsHistoryStateCopyWithImpl<$Res, _$LogsHistoryStateErrorImpl>
    implements _$$LogsHistoryStateErrorImplCopyWith<$Res> {
  __$$LogsHistoryStateErrorImplCopyWithImpl(
    _$LogsHistoryStateErrorImpl _value,
    $Res Function(_$LogsHistoryStateErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogsHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null}) {
    return _then(
      _$LogsHistoryStateErrorImpl(
        null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as LogsHistoryFailure,
      ),
    );
  }
}

/// @nodoc

class _$LogsHistoryStateErrorImpl implements LogsHistoryStateError {
  const _$LogsHistoryStateErrorImpl(this.failure);

  @override
  final LogsHistoryFailure failure;

  @override
  String toString() {
    return 'LogsHistoryState.error(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogsHistoryStateErrorImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of LogsHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogsHistoryStateErrorImplCopyWith<_$LogsHistoryStateErrorImpl>
  get copyWith =>
      __$$LogsHistoryStateErrorImplCopyWithImpl<_$LogsHistoryStateErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(List<LogsHistoryItem> items) loaded,
    required TResult Function(LogsHistoryFailure failure) error,
  }) {
    return error(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(List<LogsHistoryItem> items)? loaded,
    TResult? Function(LogsHistoryFailure failure)? error,
  }) {
    return error?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(List<LogsHistoryItem> items)? loaded,
    TResult Function(LogsHistoryFailure failure)? error,
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
    required TResult Function(LogsHistoryStateIdle value) idle,
    required TResult Function(LogsHistoryStateLoading value) loading,
    required TResult Function(LogsHistoryStateLoaded value) loaded,
    required TResult Function(LogsHistoryStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LogsHistoryStateIdle value)? idle,
    TResult? Function(LogsHistoryStateLoading value)? loading,
    TResult? Function(LogsHistoryStateLoaded value)? loaded,
    TResult? Function(LogsHistoryStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LogsHistoryStateIdle value)? idle,
    TResult Function(LogsHistoryStateLoading value)? loading,
    TResult Function(LogsHistoryStateLoaded value)? loaded,
    TResult Function(LogsHistoryStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class LogsHistoryStateError implements LogsHistoryState {
  const factory LogsHistoryStateError(final LogsHistoryFailure failure) =
      _$LogsHistoryStateErrorImpl;

  LogsHistoryFailure get failure;

  /// Create a copy of LogsHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogsHistoryStateErrorImplCopyWith<_$LogsHistoryStateErrorImpl>
  get copyWith => throw _privateConstructorUsedError;
}
