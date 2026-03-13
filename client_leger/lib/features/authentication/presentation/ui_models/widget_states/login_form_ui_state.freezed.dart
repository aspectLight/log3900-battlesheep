// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_form_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LoginFormUiState {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  bool get usernameTouched => throw _privateConstructorUsedError;
  bool get passwordTouched => throw _privateConstructorUsedError;
  bool get hasAttemptedSubmit => throw _privateConstructorUsedError;

  /// Create a copy of LoginFormUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginFormUiStateCopyWith<LoginFormUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginFormUiStateCopyWith<$Res> {
  factory $LoginFormUiStateCopyWith(
    LoginFormUiState value,
    $Res Function(LoginFormUiState) then,
  ) = _$LoginFormUiStateCopyWithImpl<$Res, LoginFormUiState>;
  @useResult
  $Res call({
    String username,
    String password,
    bool usernameTouched,
    bool passwordTouched,
    bool hasAttemptedSubmit,
  });
}

/// @nodoc
class _$LoginFormUiStateCopyWithImpl<$Res, $Val extends LoginFormUiState>
    implements $LoginFormUiStateCopyWith<$Res> {
  _$LoginFormUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginFormUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
    Object? usernameTouched = null,
    Object? passwordTouched = null,
    Object? hasAttemptedSubmit = null,
  }) {
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
            usernameTouched: null == usernameTouched
                ? _value.usernameTouched
                : usernameTouched // ignore: cast_nullable_to_non_nullable
                      as bool,
            passwordTouched: null == passwordTouched
                ? _value.passwordTouched
                : passwordTouched // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasAttemptedSubmit: null == hasAttemptedSubmit
                ? _value.hasAttemptedSubmit
                : hasAttemptedSubmit // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginFormUiStateImplCopyWith<$Res>
    implements $LoginFormUiStateCopyWith<$Res> {
  factory _$$LoginFormUiStateImplCopyWith(
    _$LoginFormUiStateImpl value,
    $Res Function(_$LoginFormUiStateImpl) then,
  ) = __$$LoginFormUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String username,
    String password,
    bool usernameTouched,
    bool passwordTouched,
    bool hasAttemptedSubmit,
  });
}

/// @nodoc
class __$$LoginFormUiStateImplCopyWithImpl<$Res>
    extends _$LoginFormUiStateCopyWithImpl<$Res, _$LoginFormUiStateImpl>
    implements _$$LoginFormUiStateImplCopyWith<$Res> {
  __$$LoginFormUiStateImplCopyWithImpl(
    _$LoginFormUiStateImpl _value,
    $Res Function(_$LoginFormUiStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginFormUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
    Object? usernameTouched = null,
    Object? passwordTouched = null,
    Object? hasAttemptedSubmit = null,
  }) {
    return _then(
      _$LoginFormUiStateImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        usernameTouched: null == usernameTouched
            ? _value.usernameTouched
            : usernameTouched // ignore: cast_nullable_to_non_nullable
                  as bool,
        passwordTouched: null == passwordTouched
            ? _value.passwordTouched
            : passwordTouched // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasAttemptedSubmit: null == hasAttemptedSubmit
            ? _value.hasAttemptedSubmit
            : hasAttemptedSubmit // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$LoginFormUiStateImpl implements _LoginFormUiState {
  const _$LoginFormUiStateImpl({
    required this.username,
    required this.password,
    required this.usernameTouched,
    required this.passwordTouched,
    required this.hasAttemptedSubmit,
  });

  @override
  final String username;
  @override
  final String password;
  @override
  final bool usernameTouched;
  @override
  final bool passwordTouched;
  @override
  final bool hasAttemptedSubmit;

  @override
  String toString() {
    return 'LoginFormUiState(username: $username, password: $password, usernameTouched: $usernameTouched, passwordTouched: $passwordTouched, hasAttemptedSubmit: $hasAttemptedSubmit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginFormUiStateImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.usernameTouched, usernameTouched) ||
                other.usernameTouched == usernameTouched) &&
            (identical(other.passwordTouched, passwordTouched) ||
                other.passwordTouched == passwordTouched) &&
            (identical(other.hasAttemptedSubmit, hasAttemptedSubmit) ||
                other.hasAttemptedSubmit == hasAttemptedSubmit));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    username,
    password,
    usernameTouched,
    passwordTouched,
    hasAttemptedSubmit,
  );

  /// Create a copy of LoginFormUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginFormUiStateImplCopyWith<_$LoginFormUiStateImpl> get copyWith =>
      __$$LoginFormUiStateImplCopyWithImpl<_$LoginFormUiStateImpl>(
        this,
        _$identity,
      );
}

abstract class _LoginFormUiState implements LoginFormUiState {
  const factory _LoginFormUiState({
    required final String username,
    required final String password,
    required final bool usernameTouched,
    required final bool passwordTouched,
    required final bool hasAttemptedSubmit,
  }) = _$LoginFormUiStateImpl;

  @override
  String get username;
  @override
  String get password;
  @override
  bool get usernameTouched;
  @override
  bool get passwordTouched;
  @override
  bool get hasAttemptedSubmit;

  /// Create a copy of LoginFormUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginFormUiStateImplCopyWith<_$LoginFormUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
