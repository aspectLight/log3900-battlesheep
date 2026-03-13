// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SessionState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String socketId) connected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String socketId)? connected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String socketId)? connected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SessionDisconnected value) initial,
    required TResult Function(SessionConnected value) connected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SessionDisconnected value)? initial,
    TResult? Function(SessionConnected value)? connected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SessionDisconnected value)? initial,
    TResult Function(SessionConnected value)? connected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionStateCopyWith<$Res> {
  factory $SessionStateCopyWith(
    SessionState value,
    $Res Function(SessionState) then,
  ) = _$SessionStateCopyWithImpl<$Res, SessionState>;
}

/// @nodoc
class _$SessionStateCopyWithImpl<$Res, $Val extends SessionState>
    implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SessionDisconnectedImplCopyWith<$Res> {
  factory _$$SessionDisconnectedImplCopyWith(
    _$SessionDisconnectedImpl value,
    $Res Function(_$SessionDisconnectedImpl) then,
  ) = __$$SessionDisconnectedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SessionDisconnectedImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$SessionDisconnectedImpl>
    implements _$$SessionDisconnectedImplCopyWith<$Res> {
  __$$SessionDisconnectedImplCopyWithImpl(
    _$SessionDisconnectedImpl _value,
    $Res Function(_$SessionDisconnectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SessionDisconnectedImpl implements SessionDisconnected {
  const _$SessionDisconnectedImpl();

  @override
  String toString() {
    return 'SessionState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionDisconnectedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String socketId) connected,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String socketId)? connected,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String socketId)? connected,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SessionDisconnected value) initial,
    required TResult Function(SessionConnected value) connected,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SessionDisconnected value)? initial,
    TResult? Function(SessionConnected value)? connected,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SessionDisconnected value)? initial,
    TResult Function(SessionConnected value)? connected,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SessionDisconnected implements SessionState {
  const factory SessionDisconnected() = _$SessionDisconnectedImpl;
}

/// @nodoc
abstract class _$$SessionConnectedImplCopyWith<$Res> {
  factory _$$SessionConnectedImplCopyWith(
    _$SessionConnectedImpl value,
    $Res Function(_$SessionConnectedImpl) then,
  ) = __$$SessionConnectedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String socketId});
}

/// @nodoc
class __$$SessionConnectedImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$SessionConnectedImpl>
    implements _$$SessionConnectedImplCopyWith<$Res> {
  __$$SessionConnectedImplCopyWithImpl(
    _$SessionConnectedImpl _value,
    $Res Function(_$SessionConnectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? socketId = null}) {
    return _then(
      _$SessionConnectedImpl(
        null == socketId
            ? _value.socketId
            : socketId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SessionConnectedImpl implements SessionConnected {
  const _$SessionConnectedImpl(this.socketId);

  @override
  final String socketId;

  @override
  String toString() {
    return 'SessionState.connected(socketId: $socketId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionConnectedImpl &&
            (identical(other.socketId, socketId) ||
                other.socketId == socketId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, socketId);

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionConnectedImplCopyWith<_$SessionConnectedImpl> get copyWith =>
      __$$SessionConnectedImplCopyWithImpl<_$SessionConnectedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String socketId) connected,
  }) {
    return connected(socketId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String socketId)? connected,
  }) {
    return connected?.call(socketId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String socketId)? connected,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(socketId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SessionDisconnected value) initial,
    required TResult Function(SessionConnected value) connected,
  }) {
    return connected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SessionDisconnected value)? initial,
    TResult? Function(SessionConnected value)? connected,
  }) {
    return connected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SessionDisconnected value)? initial,
    TResult Function(SessionConnected value)? connected,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(this);
    }
    return orElse();
  }
}

abstract class SessionConnected implements SessionState {
  const factory SessionConnected(final String socketId) =
      _$SessionConnectedImpl;

  String get socketId;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionConnectedImplCopyWith<_$SessionConnectedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
