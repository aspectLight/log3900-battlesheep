// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthEntryAppEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserModel user) signInSuccess,
    required TResult Function(String socketId) sessionConnected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserModel user)? signInSuccess,
    TResult? Function(String socketId)? sessionConnected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserModel user)? signInSuccess,
    TResult Function(String socketId)? sessionConnected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignInSuccessEvent value) signInSuccess,
    required TResult Function(SessionConnectedEvent value) sessionConnected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignInSuccessEvent value)? signInSuccess,
    TResult? Function(SessionConnectedEvent value)? sessionConnected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignInSuccessEvent value)? signInSuccess,
    TResult Function(SessionConnectedEvent value)? sessionConnected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthEntryAppEventCopyWith<$Res> {
  factory $AuthEntryAppEventCopyWith(
    AuthEntryAppEvent value,
    $Res Function(AuthEntryAppEvent) then,
  ) = _$AuthEntryAppEventCopyWithImpl<$Res, AuthEntryAppEvent>;
}

/// @nodoc
class _$AuthEntryAppEventCopyWithImpl<$Res, $Val extends AuthEntryAppEvent>
    implements $AuthEntryAppEventCopyWith<$Res> {
  _$AuthEntryAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SignInSuccessEventImplCopyWith<$Res> {
  factory _$$SignInSuccessEventImplCopyWith(
    _$SignInSuccessEventImpl value,
    $Res Function(_$SignInSuccessEventImpl) then,
  ) = __$$SignInSuccessEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user});

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$SignInSuccessEventImplCopyWithImpl<$Res>
    extends _$AuthEntryAppEventCopyWithImpl<$Res, _$SignInSuccessEventImpl>
    implements _$$SignInSuccessEventImplCopyWith<$Res> {
  __$$SignInSuccessEventImplCopyWithImpl(
    _$SignInSuccessEventImpl _value,
    $Res Function(_$SignInSuccessEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null}) {
    return _then(
      _$SignInSuccessEventImpl(
        null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
      ),
    );
  }

  /// Create a copy of AuthEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc

class _$SignInSuccessEventImpl implements SignInSuccessEvent {
  const _$SignInSuccessEventImpl(this.user);

  @override
  final UserModel user;

  @override
  String toString() {
    return 'AuthEntryAppEvent.signInSuccess(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInSuccessEventImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of AuthEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignInSuccessEventImplCopyWith<_$SignInSuccessEventImpl> get copyWith =>
      __$$SignInSuccessEventImplCopyWithImpl<_$SignInSuccessEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserModel user) signInSuccess,
    required TResult Function(String socketId) sessionConnected,
  }) {
    return signInSuccess(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserModel user)? signInSuccess,
    TResult? Function(String socketId)? sessionConnected,
  }) {
    return signInSuccess?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserModel user)? signInSuccess,
    TResult Function(String socketId)? sessionConnected,
    required TResult orElse(),
  }) {
    if (signInSuccess != null) {
      return signInSuccess(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignInSuccessEvent value) signInSuccess,
    required TResult Function(SessionConnectedEvent value) sessionConnected,
  }) {
    return signInSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignInSuccessEvent value)? signInSuccess,
    TResult? Function(SessionConnectedEvent value)? sessionConnected,
  }) {
    return signInSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignInSuccessEvent value)? signInSuccess,
    TResult Function(SessionConnectedEvent value)? sessionConnected,
    required TResult orElse(),
  }) {
    if (signInSuccess != null) {
      return signInSuccess(this);
    }
    return orElse();
  }
}

abstract class SignInSuccessEvent implements AuthEntryAppEvent {
  const factory SignInSuccessEvent(final UserModel user) =
      _$SignInSuccessEventImpl;

  UserModel get user;

  /// Create a copy of AuthEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignInSuccessEventImplCopyWith<_$SignInSuccessEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SessionConnectedEventImplCopyWith<$Res> {
  factory _$$SessionConnectedEventImplCopyWith(
    _$SessionConnectedEventImpl value,
    $Res Function(_$SessionConnectedEventImpl) then,
  ) = __$$SessionConnectedEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String socketId});
}

/// @nodoc
class __$$SessionConnectedEventImplCopyWithImpl<$Res>
    extends _$AuthEntryAppEventCopyWithImpl<$Res, _$SessionConnectedEventImpl>
    implements _$$SessionConnectedEventImplCopyWith<$Res> {
  __$$SessionConnectedEventImplCopyWithImpl(
    _$SessionConnectedEventImpl _value,
    $Res Function(_$SessionConnectedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? socketId = null}) {
    return _then(
      _$SessionConnectedEventImpl(
        null == socketId
            ? _value.socketId
            : socketId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SessionConnectedEventImpl implements SessionConnectedEvent {
  const _$SessionConnectedEventImpl(this.socketId);

  @override
  final String socketId;

  @override
  String toString() {
    return 'AuthEntryAppEvent.sessionConnected(socketId: $socketId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionConnectedEventImpl &&
            (identical(other.socketId, socketId) ||
                other.socketId == socketId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, socketId);

  /// Create a copy of AuthEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionConnectedEventImplCopyWith<_$SessionConnectedEventImpl>
  get copyWith =>
      __$$SessionConnectedEventImplCopyWithImpl<_$SessionConnectedEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserModel user) signInSuccess,
    required TResult Function(String socketId) sessionConnected,
  }) {
    return sessionConnected(socketId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserModel user)? signInSuccess,
    TResult? Function(String socketId)? sessionConnected,
  }) {
    return sessionConnected?.call(socketId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserModel user)? signInSuccess,
    TResult Function(String socketId)? sessionConnected,
    required TResult orElse(),
  }) {
    if (sessionConnected != null) {
      return sessionConnected(socketId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignInSuccessEvent value) signInSuccess,
    required TResult Function(SessionConnectedEvent value) sessionConnected,
  }) {
    return sessionConnected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignInSuccessEvent value)? signInSuccess,
    TResult? Function(SessionConnectedEvent value)? sessionConnected,
  }) {
    return sessionConnected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignInSuccessEvent value)? signInSuccess,
    TResult Function(SessionConnectedEvent value)? sessionConnected,
    required TResult orElse(),
  }) {
    if (sessionConnected != null) {
      return sessionConnected(this);
    }
    return orElse();
  }
}

abstract class SessionConnectedEvent implements AuthEntryAppEvent {
  const factory SessionConnectedEvent(final String socketId) =
      _$SessionConnectedEventImpl;

  String get socketId;

  /// Create a copy of AuthEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionConnectedEventImplCopyWith<_$SessionConnectedEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AuthCompletedAppEvent {
  String get username => throw _privateConstructorUsedError;

  /// Create a copy of AuthCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthCompletedAppEventCopyWith<AuthCompletedAppEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthCompletedAppEventCopyWith<$Res> {
  factory $AuthCompletedAppEventCopyWith(
    AuthCompletedAppEvent value,
    $Res Function(AuthCompletedAppEvent) then,
  ) = _$AuthCompletedAppEventCopyWithImpl<$Res, AuthCompletedAppEvent>;
  @useResult
  $Res call({String username});
}

/// @nodoc
class _$AuthCompletedAppEventCopyWithImpl<
  $Res,
  $Val extends AuthCompletedAppEvent
>
    implements $AuthCompletedAppEventCopyWith<$Res> {
  _$AuthCompletedAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthCompletedAppEvent
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
abstract class _$$AuthCompletedAppEventImplCopyWith<$Res>
    implements $AuthCompletedAppEventCopyWith<$Res> {
  factory _$$AuthCompletedAppEventImplCopyWith(
    _$AuthCompletedAppEventImpl value,
    $Res Function(_$AuthCompletedAppEventImpl) then,
  ) = __$$AuthCompletedAppEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username});
}

/// @nodoc
class __$$AuthCompletedAppEventImplCopyWithImpl<$Res>
    extends
        _$AuthCompletedAppEventCopyWithImpl<$Res, _$AuthCompletedAppEventImpl>
    implements _$$AuthCompletedAppEventImplCopyWith<$Res> {
  __$$AuthCompletedAppEventImplCopyWithImpl(
    _$AuthCompletedAppEventImpl _value,
    $Res Function(_$AuthCompletedAppEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null}) {
    return _then(
      _$AuthCompletedAppEventImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthCompletedAppEventImpl implements _AuthCompletedAppEvent {
  const _$AuthCompletedAppEventImpl({required this.username});

  @override
  final String username;

  @override
  String toString() {
    return 'AuthCompletedAppEvent(username: $username)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthCompletedAppEventImpl &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @override
  int get hashCode => Object.hash(runtimeType, username);

  /// Create a copy of AuthCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthCompletedAppEventImplCopyWith<_$AuthCompletedAppEventImpl>
  get copyWith =>
      __$$AuthCompletedAppEventImplCopyWithImpl<_$AuthCompletedAppEventImpl>(
        this,
        _$identity,
      );
}

abstract class _AuthCompletedAppEvent implements AuthCompletedAppEvent {
  const factory _AuthCompletedAppEvent({required final String username}) =
      _$AuthCompletedAppEventImpl;

  @override
  String get username;

  /// Create a copy of AuthCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthCompletedAppEventImplCopyWith<_$AuthCompletedAppEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AuthExitAppEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() signOut,
    required TResult Function() appLifecycleDetached,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? signOut,
    TResult? Function()? appLifecycleDetached,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? signOut,
    TResult Function()? appLifecycleDetached,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserSignedOutEvent value) signOut,
    required TResult Function(AppLifecycleDetachedEvent value)
    appLifecycleDetached,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserSignedOutEvent value)? signOut,
    TResult? Function(AppLifecycleDetachedEvent value)? appLifecycleDetached,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserSignedOutEvent value)? signOut,
    TResult Function(AppLifecycleDetachedEvent value)? appLifecycleDetached,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthExitAppEventCopyWith<$Res> {
  factory $AuthExitAppEventCopyWith(
    AuthExitAppEvent value,
    $Res Function(AuthExitAppEvent) then,
  ) = _$AuthExitAppEventCopyWithImpl<$Res, AuthExitAppEvent>;
}

/// @nodoc
class _$AuthExitAppEventCopyWithImpl<$Res, $Val extends AuthExitAppEvent>
    implements $AuthExitAppEventCopyWith<$Res> {
  _$AuthExitAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UserSignedOutEventImplCopyWith<$Res> {
  factory _$$UserSignedOutEventImplCopyWith(
    _$UserSignedOutEventImpl value,
    $Res Function(_$UserSignedOutEventImpl) then,
  ) = __$$UserSignedOutEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserSignedOutEventImplCopyWithImpl<$Res>
    extends _$AuthExitAppEventCopyWithImpl<$Res, _$UserSignedOutEventImpl>
    implements _$$UserSignedOutEventImplCopyWith<$Res> {
  __$$UserSignedOutEventImplCopyWithImpl(
    _$UserSignedOutEventImpl _value,
    $Res Function(_$UserSignedOutEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserSignedOutEventImpl implements UserSignedOutEvent {
  const _$UserSignedOutEventImpl();

  @override
  String toString() {
    return 'AuthExitAppEvent.signOut()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserSignedOutEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() signOut,
    required TResult Function() appLifecycleDetached,
  }) {
    return signOut();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? signOut,
    TResult? Function()? appLifecycleDetached,
  }) {
    return signOut?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? signOut,
    TResult Function()? appLifecycleDetached,
    required TResult orElse(),
  }) {
    if (signOut != null) {
      return signOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserSignedOutEvent value) signOut,
    required TResult Function(AppLifecycleDetachedEvent value)
    appLifecycleDetached,
  }) {
    return signOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserSignedOutEvent value)? signOut,
    TResult? Function(AppLifecycleDetachedEvent value)? appLifecycleDetached,
  }) {
    return signOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserSignedOutEvent value)? signOut,
    TResult Function(AppLifecycleDetachedEvent value)? appLifecycleDetached,
    required TResult orElse(),
  }) {
    if (signOut != null) {
      return signOut(this);
    }
    return orElse();
  }
}

abstract class UserSignedOutEvent implements AuthExitAppEvent {
  const factory UserSignedOutEvent() = _$UserSignedOutEventImpl;
}

/// @nodoc
abstract class _$$AppLifecycleDetachedEventImplCopyWith<$Res> {
  factory _$$AppLifecycleDetachedEventImplCopyWith(
    _$AppLifecycleDetachedEventImpl value,
    $Res Function(_$AppLifecycleDetachedEventImpl) then,
  ) = __$$AppLifecycleDetachedEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppLifecycleDetachedEventImplCopyWithImpl<$Res>
    extends
        _$AuthExitAppEventCopyWithImpl<$Res, _$AppLifecycleDetachedEventImpl>
    implements _$$AppLifecycleDetachedEventImplCopyWith<$Res> {
  __$$AppLifecycleDetachedEventImplCopyWithImpl(
    _$AppLifecycleDetachedEventImpl _value,
    $Res Function(_$AppLifecycleDetachedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AppLifecycleDetachedEventImpl implements AppLifecycleDetachedEvent {
  const _$AppLifecycleDetachedEventImpl();

  @override
  String toString() {
    return 'AuthExitAppEvent.appLifecycleDetached()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppLifecycleDetachedEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() signOut,
    required TResult Function() appLifecycleDetached,
  }) {
    return appLifecycleDetached();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? signOut,
    TResult? Function()? appLifecycleDetached,
  }) {
    return appLifecycleDetached?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? signOut,
    TResult Function()? appLifecycleDetached,
    required TResult orElse(),
  }) {
    if (appLifecycleDetached != null) {
      return appLifecycleDetached();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserSignedOutEvent value) signOut,
    required TResult Function(AppLifecycleDetachedEvent value)
    appLifecycleDetached,
  }) {
    return appLifecycleDetached(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserSignedOutEvent value)? signOut,
    TResult? Function(AppLifecycleDetachedEvent value)? appLifecycleDetached,
  }) {
    return appLifecycleDetached?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserSignedOutEvent value)? signOut,
    TResult Function(AppLifecycleDetachedEvent value)? appLifecycleDetached,
    required TResult orElse(),
  }) {
    if (appLifecycleDetached != null) {
      return appLifecycleDetached(this);
    }
    return orElse();
  }
}

abstract class AppLifecycleDetachedEvent implements AuthExitAppEvent {
  const factory AppLifecycleDetachedEvent() = _$AppLifecycleDetachedEventImpl;
}
