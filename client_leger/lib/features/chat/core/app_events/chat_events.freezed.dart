// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChatEntryAppEvent {
  String get username => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String username) authCompleted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String username)? authCompleted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String username)? authCompleted,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatEnterAfterAuth value) authCompleted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatEnterAfterAuth value)? authCompleted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatEnterAfterAuth value)? authCompleted,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of ChatEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatEntryAppEventCopyWith<ChatEntryAppEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatEntryAppEventCopyWith<$Res> {
  factory $ChatEntryAppEventCopyWith(
    ChatEntryAppEvent value,
    $Res Function(ChatEntryAppEvent) then,
  ) = _$ChatEntryAppEventCopyWithImpl<$Res, ChatEntryAppEvent>;
  @useResult
  $Res call({String username});
}

/// @nodoc
class _$ChatEntryAppEventCopyWithImpl<$Res, $Val extends ChatEntryAppEvent>
    implements $ChatEntryAppEventCopyWith<$Res> {
  _$ChatEntryAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null}) {
    return _then(
      _value.copyWith(
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatEnterAfterAuthImplCopyWith<$Res>
    implements $ChatEntryAppEventCopyWith<$Res> {
  factory _$$ChatEnterAfterAuthImplCopyWith(
    _$ChatEnterAfterAuthImpl value,
    $Res Function(_$ChatEnterAfterAuthImpl) then,
  ) = __$$ChatEnterAfterAuthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username});
}

/// @nodoc
class __$$ChatEnterAfterAuthImplCopyWithImpl<$Res>
    extends _$ChatEntryAppEventCopyWithImpl<$Res, _$ChatEnterAfterAuthImpl>
    implements _$$ChatEnterAfterAuthImplCopyWith<$Res> {
  __$$ChatEnterAfterAuthImplCopyWithImpl(
    _$ChatEnterAfterAuthImpl _value,
    $Res Function(_$ChatEnterAfterAuthImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null}) {
    return _then(
      _$ChatEnterAfterAuthImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ChatEnterAfterAuthImpl implements ChatEnterAfterAuth {
  const _$ChatEnterAfterAuthImpl({required this.username});

  @override
  final String username;

  @override
  String toString() {
    return 'ChatEntryAppEvent.authCompleted(username: $username)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatEnterAfterAuthImpl &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @override
  int get hashCode => Object.hash(runtimeType, username);

  /// Create a copy of ChatEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatEnterAfterAuthImplCopyWith<_$ChatEnterAfterAuthImpl> get copyWith =>
      __$$ChatEnterAfterAuthImplCopyWithImpl<_$ChatEnterAfterAuthImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String username) authCompleted,
  }) {
    return authCompleted(username);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String username)? authCompleted,
  }) {
    return authCompleted?.call(username);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String username)? authCompleted,
    required TResult orElse(),
  }) {
    if (authCompleted != null) {
      return authCompleted(username);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatEnterAfterAuth value) authCompleted,
  }) {
    return authCompleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatEnterAfterAuth value)? authCompleted,
  }) {
    return authCompleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatEnterAfterAuth value)? authCompleted,
    required TResult orElse(),
  }) {
    if (authCompleted != null) {
      return authCompleted(this);
    }
    return orElse();
  }
}

abstract class ChatEnterAfterAuth implements ChatEntryAppEvent {
  const factory ChatEnterAfterAuth({required final String username}) =
      _$ChatEnterAfterAuthImpl;

  @override
  String get username;

  /// Create a copy of ChatEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatEnterAfterAuthImplCopyWith<_$ChatEnterAfterAuthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ChatCompletedAppEvent {}

/// @nodoc
abstract class $ChatCompletedAppEventCopyWith<$Res> {
  factory $ChatCompletedAppEventCopyWith(
    ChatCompletedAppEvent value,
    $Res Function(ChatCompletedAppEvent) then,
  ) = _$ChatCompletedAppEventCopyWithImpl<$Res, ChatCompletedAppEvent>;
}

/// @nodoc
class _$ChatCompletedAppEventCopyWithImpl<
  $Res,
  $Val extends ChatCompletedAppEvent
>
    implements $ChatCompletedAppEventCopyWith<$Res> {
  _$ChatCompletedAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ChatCompletedAppEventImplCopyWith<$Res> {
  factory _$$ChatCompletedAppEventImplCopyWith(
    _$ChatCompletedAppEventImpl value,
    $Res Function(_$ChatCompletedAppEventImpl) then,
  ) = __$$ChatCompletedAppEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ChatCompletedAppEventImplCopyWithImpl<$Res>
    extends
        _$ChatCompletedAppEventCopyWithImpl<$Res, _$ChatCompletedAppEventImpl>
    implements _$$ChatCompletedAppEventImplCopyWith<$Res> {
  __$$ChatCompletedAppEventImplCopyWithImpl(
    _$ChatCompletedAppEventImpl _value,
    $Res Function(_$ChatCompletedAppEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChatCompletedAppEventImpl implements _ChatCompletedAppEvent {
  const _$ChatCompletedAppEventImpl();

  @override
  String toString() {
    return 'ChatCompletedAppEvent()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatCompletedAppEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _ChatCompletedAppEvent implements ChatCompletedAppEvent {
  const factory _ChatCompletedAppEvent() = _$ChatCompletedAppEventImpl;
}

/// @nodoc
mixin _$ChatExitAppEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({required TResult Function() closed}) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({TResult? Function()? closed}) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? closed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatClosedEvent value) closed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatClosedEvent value)? closed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatClosedEvent value)? closed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatExitAppEventCopyWith<$Res> {
  factory $ChatExitAppEventCopyWith(
    ChatExitAppEvent value,
    $Res Function(ChatExitAppEvent) then,
  ) = _$ChatExitAppEventCopyWithImpl<$Res, ChatExitAppEvent>;
}

/// @nodoc
class _$ChatExitAppEventCopyWithImpl<$Res, $Val extends ChatExitAppEvent>
    implements $ChatExitAppEventCopyWith<$Res> {
  _$ChatExitAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ChatClosedEventImplCopyWith<$Res> {
  factory _$$ChatClosedEventImplCopyWith(
    _$ChatClosedEventImpl value,
    $Res Function(_$ChatClosedEventImpl) then,
  ) = __$$ChatClosedEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ChatClosedEventImplCopyWithImpl<$Res>
    extends _$ChatExitAppEventCopyWithImpl<$Res, _$ChatClosedEventImpl>
    implements _$$ChatClosedEventImplCopyWith<$Res> {
  __$$ChatClosedEventImplCopyWithImpl(
    _$ChatClosedEventImpl _value,
    $Res Function(_$ChatClosedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChatClosedEventImpl implements ChatClosedEvent {
  const _$ChatClosedEventImpl();

  @override
  String toString() {
    return 'ChatExitAppEvent.closed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ChatClosedEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({required TResult Function() closed}) {
    return closed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({TResult? Function()? closed}) {
    return closed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? closed,
    required TResult orElse(),
  }) {
    if (closed != null) {
      return closed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatClosedEvent value) closed,
  }) {
    return closed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatClosedEvent value)? closed,
  }) {
    return closed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatClosedEvent value)? closed,
    required TResult orElse(),
  }) {
    if (closed != null) {
      return closed(this);
    }
    return orElse();
  }
}

abstract class ChatClosedEvent implements ChatExitAppEvent {
  const factory ChatClosedEvent() = _$ChatClosedEventImpl;
}
