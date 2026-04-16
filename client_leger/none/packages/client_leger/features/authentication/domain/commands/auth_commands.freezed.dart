// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_commands.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SignInCommand {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Create a copy of SignInCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignInCommandCopyWith<SignInCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignInCommandCopyWith<$Res> {
  factory $SignInCommandCopyWith(
    SignInCommand value,
    $Res Function(SignInCommand) then,
  ) = _$SignInCommandCopyWithImpl<$Res, SignInCommand>;
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class _$SignInCommandCopyWithImpl<$Res, $Val extends SignInCommand>
    implements $SignInCommandCopyWith<$Res> {
  _$SignInCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignInCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null, Object? password = null}) {
    return _then(
      _value.copyWith(
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SignInCommandImplCopyWith<$Res>
    implements $SignInCommandCopyWith<$Res> {
  factory _$$SignInCommandImplCopyWith(
    _$SignInCommandImpl value,
    $Res Function(_$SignInCommandImpl) then,
  ) = __$$SignInCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class __$$SignInCommandImplCopyWithImpl<$Res>
    extends _$SignInCommandCopyWithImpl<$Res, _$SignInCommandImpl>
    implements _$$SignInCommandImplCopyWith<$Res> {
  __$$SignInCommandImplCopyWithImpl(
    _$SignInCommandImpl _value,
    $Res Function(_$SignInCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SignInCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null, Object? password = null}) {
    return _then(
      _$SignInCommandImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SignInCommandImpl implements _SignInCommand {
  const _$SignInCommandImpl({required this.username, required this.password});

  @override
  final String username;
  @override
  final String password;

  @override
  String toString() {
    return 'SignInCommand(username: $username, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInCommandImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, username, password);

  /// Create a copy of SignInCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignInCommandImplCopyWith<_$SignInCommandImpl> get copyWith =>
      __$$SignInCommandImplCopyWithImpl<_$SignInCommandImpl>(this, _$identity);
}

abstract class _SignInCommand implements SignInCommand {
  const factory _SignInCommand({
    required final String username,
    required final String password,
  }) = _$SignInCommandImpl;

  @override
  String get username;
  @override
  String get password;

  /// Create a copy of SignInCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignInCommandImplCopyWith<_$SignInCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SignUpCommand {
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get avatarId => throw _privateConstructorUsedError;

  /// Create a copy of SignUpCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignUpCommandCopyWith<SignUpCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignUpCommandCopyWith<$Res> {
  factory $SignUpCommandCopyWith(
    SignUpCommand value,
    $Res Function(SignUpCommand) then,
  ) = _$SignUpCommandCopyWithImpl<$Res, SignUpCommand>;
  @useResult
  $Res call({String username, String email, String password, String avatarId});
}

/// @nodoc
class _$SignUpCommandCopyWithImpl<$Res, $Val extends SignUpCommand>
    implements $SignUpCommandCopyWith<$Res> {
  _$SignUpCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignUpCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? password = null,
    Object? avatarId = null,
  }) {
    return _then(
      _value.copyWith(
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarId: null == avatarId
                ? _value.avatarId
                : avatarId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SignUpCommandImplCopyWith<$Res>
    implements $SignUpCommandCopyWith<$Res> {
  factory _$$SignUpCommandImplCopyWith(
    _$SignUpCommandImpl value,
    $Res Function(_$SignUpCommandImpl) then,
  ) = __$$SignUpCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String email, String password, String avatarId});
}

/// @nodoc
class __$$SignUpCommandImplCopyWithImpl<$Res>
    extends _$SignUpCommandCopyWithImpl<$Res, _$SignUpCommandImpl>
    implements _$$SignUpCommandImplCopyWith<$Res> {
  __$$SignUpCommandImplCopyWithImpl(
    _$SignUpCommandImpl _value,
    $Res Function(_$SignUpCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SignUpCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? password = null,
    Object? avatarId = null,
  }) {
    return _then(
      _$SignUpCommandImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarId: null == avatarId
            ? _value.avatarId
            : avatarId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SignUpCommandImpl implements _SignUpCommand {
  const _$SignUpCommandImpl({
    required this.username,
    required this.email,
    required this.password,
    required this.avatarId,
  });

  @override
  final String username;
  @override
  final String email;
  @override
  final String password;
  @override
  final String avatarId;

  @override
  String toString() {
    return 'SignUpCommand(username: $username, email: $email, password: $password, avatarId: $avatarId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpCommandImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.avatarId, avatarId) ||
                other.avatarId == avatarId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, username, email, password, avatarId);

  /// Create a copy of SignUpCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignUpCommandImplCopyWith<_$SignUpCommandImpl> get copyWith =>
      __$$SignUpCommandImplCopyWithImpl<_$SignUpCommandImpl>(this, _$identity);
}

abstract class _SignUpCommand implements SignUpCommand {
  const factory _SignUpCommand({
    required final String username,
    required final String email,
    required final String password,
    required final String avatarId,
  }) = _$SignUpCommandImpl;

  @override
  String get username;
  @override
  String get email;
  @override
  String get password;
  @override
  String get avatarId;

  /// Create a copy of SignUpCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignUpCommandImplCopyWith<_$SignUpCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SignOutCommand {}

/// @nodoc
abstract class $SignOutCommandCopyWith<$Res> {
  factory $SignOutCommandCopyWith(
    SignOutCommand value,
    $Res Function(SignOutCommand) then,
  ) = _$SignOutCommandCopyWithImpl<$Res, SignOutCommand>;
}

/// @nodoc
class _$SignOutCommandCopyWithImpl<$Res, $Val extends SignOutCommand>
    implements $SignOutCommandCopyWith<$Res> {
  _$SignOutCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignOutCommand
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SignOutCommandImplCopyWith<$Res> {
  factory _$$SignOutCommandImplCopyWith(
    _$SignOutCommandImpl value,
    $Res Function(_$SignOutCommandImpl) then,
  ) = __$$SignOutCommandImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignOutCommandImplCopyWithImpl<$Res>
    extends _$SignOutCommandCopyWithImpl<$Res, _$SignOutCommandImpl>
    implements _$$SignOutCommandImplCopyWith<$Res> {
  __$$SignOutCommandImplCopyWithImpl(
    _$SignOutCommandImpl _value,
    $Res Function(_$SignOutCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SignOutCommand
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignOutCommandImpl implements _SignOutCommand {
  const _$SignOutCommandImpl();

  @override
  String toString() {
    return 'SignOutCommand()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignOutCommandImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _SignOutCommand implements SignOutCommand {
  const factory _SignOutCommand() = _$SignOutCommandImpl;
}

/// @nodoc
mixin _$UpdateProfileCommand {
  String? get username => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatarId => throw _privateConstructorUsedError;

  /// Create a copy of UpdateProfileCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateProfileCommandCopyWith<UpdateProfileCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateProfileCommandCopyWith<$Res> {
  factory $UpdateProfileCommandCopyWith(
    UpdateProfileCommand value,
    $Res Function(UpdateProfileCommand) then,
  ) = _$UpdateProfileCommandCopyWithImpl<$Res, UpdateProfileCommand>;
  @useResult
  $Res call({String? username, String? email, String? avatarId});
}

/// @nodoc
class _$UpdateProfileCommandCopyWithImpl<
  $Res,
  $Val extends UpdateProfileCommand
>
    implements $UpdateProfileCommandCopyWith<$Res> {
  _$UpdateProfileCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateProfileCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = freezed,
    Object? email = freezed,
    Object? avatarId = freezed,
  }) {
    return _then(
      _value.copyWith(
            username: freezed == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarId: freezed == avatarId
                ? _value.avatarId
                : avatarId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateProfileCommandImplCopyWith<$Res>
    implements $UpdateProfileCommandCopyWith<$Res> {
  factory _$$UpdateProfileCommandImplCopyWith(
    _$UpdateProfileCommandImpl value,
    $Res Function(_$UpdateProfileCommandImpl) then,
  ) = __$$UpdateProfileCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? username, String? email, String? avatarId});
}

/// @nodoc
class __$$UpdateProfileCommandImplCopyWithImpl<$Res>
    extends _$UpdateProfileCommandCopyWithImpl<$Res, _$UpdateProfileCommandImpl>
    implements _$$UpdateProfileCommandImplCopyWith<$Res> {
  __$$UpdateProfileCommandImplCopyWithImpl(
    _$UpdateProfileCommandImpl _value,
    $Res Function(_$UpdateProfileCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateProfileCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = freezed,
    Object? email = freezed,
    Object? avatarId = freezed,
  }) {
    return _then(
      _$UpdateProfileCommandImpl(
        username: freezed == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarId: freezed == avatarId
            ? _value.avatarId
            : avatarId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateProfileCommandImpl implements _UpdateProfileCommand {
  const _$UpdateProfileCommandImpl({this.username, this.email, this.avatarId});

  @override
  final String? username;
  @override
  final String? email;
  @override
  final String? avatarId;

  @override
  String toString() {
    return 'UpdateProfileCommand(username: $username, email: $email, avatarId: $avatarId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProfileCommandImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarId, avatarId) ||
                other.avatarId == avatarId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, username, email, avatarId);

  /// Create a copy of UpdateProfileCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProfileCommandImplCopyWith<_$UpdateProfileCommandImpl>
  get copyWith =>
      __$$UpdateProfileCommandImplCopyWithImpl<_$UpdateProfileCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _UpdateProfileCommand implements UpdateProfileCommand {
  const factory _UpdateProfileCommand({
    final String? username,
    final String? email,
    final String? avatarId,
  }) = _$UpdateProfileCommandImpl;

  @override
  String? get username;
  @override
  String? get email;
  @override
  String? get avatarId;

  /// Create a copy of UpdateProfileCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateProfileCommandImplCopyWith<_$UpdateProfileCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DeleteAccountCommand {}

/// @nodoc
abstract class $DeleteAccountCommandCopyWith<$Res> {
  factory $DeleteAccountCommandCopyWith(
    DeleteAccountCommand value,
    $Res Function(DeleteAccountCommand) then,
  ) = _$DeleteAccountCommandCopyWithImpl<$Res, DeleteAccountCommand>;
}

/// @nodoc
class _$DeleteAccountCommandCopyWithImpl<
  $Res,
  $Val extends DeleteAccountCommand
>
    implements $DeleteAccountCommandCopyWith<$Res> {
  _$DeleteAccountCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteAccountCommand
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DeleteAccountCommandImplCopyWith<$Res> {
  factory _$$DeleteAccountCommandImplCopyWith(
    _$DeleteAccountCommandImpl value,
    $Res Function(_$DeleteAccountCommandImpl) then,
  ) = __$$DeleteAccountCommandImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeleteAccountCommandImplCopyWithImpl<$Res>
    extends _$DeleteAccountCommandCopyWithImpl<$Res, _$DeleteAccountCommandImpl>
    implements _$$DeleteAccountCommandImplCopyWith<$Res> {
  __$$DeleteAccountCommandImplCopyWithImpl(
    _$DeleteAccountCommandImpl _value,
    $Res Function(_$DeleteAccountCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeleteAccountCommand
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DeleteAccountCommandImpl implements _DeleteAccountCommand {
  const _$DeleteAccountCommandImpl();

  @override
  String toString() {
    return 'DeleteAccountCommand()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteAccountCommandImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _DeleteAccountCommand implements DeleteAccountCommand {
  const factory _DeleteAccountCommand() = _$DeleteAccountCommandImpl;
}
