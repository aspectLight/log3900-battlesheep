// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up_form_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SignUpFormUiState {
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get confirmPassword => throw _privateConstructorUsedError;
  Option<AuthAvatar> get avatar => throw _privateConstructorUsedError;
  bool get hasAttemptedSubmit => throw _privateConstructorUsedError;

  /// Create a copy of SignUpFormUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignUpFormUiStateCopyWith<SignUpFormUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignUpFormUiStateCopyWith<$Res> {
  factory $SignUpFormUiStateCopyWith(
    SignUpFormUiState value,
    $Res Function(SignUpFormUiState) then,
  ) = _$SignUpFormUiStateCopyWithImpl<$Res, SignUpFormUiState>;
  @useResult
  $Res call({
    String username,
    String email,
    String password,
    String confirmPassword,
    Option<AuthAvatar> avatar,
    bool hasAttemptedSubmit,
  });
}

/// @nodoc
class _$SignUpFormUiStateCopyWithImpl<$Res, $Val extends SignUpFormUiState>
    implements $SignUpFormUiStateCopyWith<$Res> {
  _$SignUpFormUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignUpFormUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? avatar = null,
    Object? hasAttemptedSubmit = null,
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
            confirmPassword: null == confirmPassword
                ? _value.confirmPassword
                : confirmPassword // ignore: cast_nullable_to_non_nullable
                      as String,
            avatar: null == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as Option<AuthAvatar>,
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
abstract class _$$SignUpFormUiStateImplCopyWith<$Res>
    implements $SignUpFormUiStateCopyWith<$Res> {
  factory _$$SignUpFormUiStateImplCopyWith(
    _$SignUpFormUiStateImpl value,
    $Res Function(_$SignUpFormUiStateImpl) then,
  ) = __$$SignUpFormUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String username,
    String email,
    String password,
    String confirmPassword,
    Option<AuthAvatar> avatar,
    bool hasAttemptedSubmit,
  });
}

/// @nodoc
class __$$SignUpFormUiStateImplCopyWithImpl<$Res>
    extends _$SignUpFormUiStateCopyWithImpl<$Res, _$SignUpFormUiStateImpl>
    implements _$$SignUpFormUiStateImplCopyWith<$Res> {
  __$$SignUpFormUiStateImplCopyWithImpl(
    _$SignUpFormUiStateImpl _value,
    $Res Function(_$SignUpFormUiStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SignUpFormUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? avatar = null,
    Object? hasAttemptedSubmit = null,
  }) {
    return _then(
      _$SignUpFormUiStateImpl(
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
        confirmPassword: null == confirmPassword
            ? _value.confirmPassword
            : confirmPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        avatar: null == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as Option<AuthAvatar>,
        hasAttemptedSubmit: null == hasAttemptedSubmit
            ? _value.hasAttemptedSubmit
            : hasAttemptedSubmit // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SignUpFormUiStateImpl implements _SignUpFormUiState {
  const _$SignUpFormUiStateImpl({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.avatar,
    required this.hasAttemptedSubmit,
  });

  @override
  final String username;
  @override
  final String email;
  @override
  final String password;
  @override
  final String confirmPassword;
  @override
  final Option<AuthAvatar> avatar;
  @override
  final bool hasAttemptedSubmit;

  @override
  String toString() {
    return 'SignUpFormUiState(username: $username, email: $email, password: $password, confirmPassword: $confirmPassword, avatar: $avatar, hasAttemptedSubmit: $hasAttemptedSubmit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpFormUiStateImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.hasAttemptedSubmit, hasAttemptedSubmit) ||
                other.hasAttemptedSubmit == hasAttemptedSubmit));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    username,
    email,
    password,
    confirmPassword,
    avatar,
    hasAttemptedSubmit,
  );

  /// Create a copy of SignUpFormUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignUpFormUiStateImplCopyWith<_$SignUpFormUiStateImpl> get copyWith =>
      __$$SignUpFormUiStateImplCopyWithImpl<_$SignUpFormUiStateImpl>(
        this,
        _$identity,
      );
}

abstract class _SignUpFormUiState implements SignUpFormUiState {
  const factory _SignUpFormUiState({
    required final String username,
    required final String email,
    required final String password,
    required final String confirmPassword,
    required final Option<AuthAvatar> avatar,
    required final bool hasAttemptedSubmit,
  }) = _$SignUpFormUiStateImpl;

  @override
  String get username;
  @override
  String get email;
  @override
  String get password;
  @override
  String get confirmPassword;
  @override
  Option<AuthAvatar> get avatar;
  @override
  bool get hasAttemptedSubmit;

  /// Create a copy of SignUpFormUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignUpFormUiStateImplCopyWith<_$SignUpFormUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
