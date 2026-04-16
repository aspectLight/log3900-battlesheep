// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_sign_in_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthSignInResult {
  UserModel get user => throw _privateConstructorUsedError;
  String get apiToken => throw _privateConstructorUsedError;
  String get apiSessionId => throw _privateConstructorUsedError;

  /// Create a copy of AuthSignInResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthSignInResultCopyWith<AuthSignInResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthSignInResultCopyWith<$Res> {
  factory $AuthSignInResultCopyWith(
    AuthSignInResult value,
    $Res Function(AuthSignInResult) then,
  ) = _$AuthSignInResultCopyWithImpl<$Res, AuthSignInResult>;
  @useResult
  $Res call({UserModel user, String apiToken, String apiSessionId});

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthSignInResultCopyWithImpl<$Res, $Val extends AuthSignInResult>
    implements $AuthSignInResultCopyWith<$Res> {
  _$AuthSignInResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthSignInResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? apiToken = null,
    Object? apiSessionId = null,
  }) {
    return _then(
      _value.copyWith(
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            apiToken: null == apiToken
                ? _value.apiToken
                : apiToken // ignore: cast_nullable_to_non_nullable
                      as String,
            apiSessionId: null == apiSessionId
                ? _value.apiSessionId
                : apiSessionId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthSignInResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthSignInResultImplCopyWith<$Res>
    implements $AuthSignInResultCopyWith<$Res> {
  factory _$$AuthSignInResultImplCopyWith(
    _$AuthSignInResultImpl value,
    $Res Function(_$AuthSignInResultImpl) then,
  ) = __$$AuthSignInResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserModel user, String apiToken, String apiSessionId});

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthSignInResultImplCopyWithImpl<$Res>
    extends _$AuthSignInResultCopyWithImpl<$Res, _$AuthSignInResultImpl>
    implements _$$AuthSignInResultImplCopyWith<$Res> {
  __$$AuthSignInResultImplCopyWithImpl(
    _$AuthSignInResultImpl _value,
    $Res Function(_$AuthSignInResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthSignInResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? apiToken = null,
    Object? apiSessionId = null,
  }) {
    return _then(
      _$AuthSignInResultImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        apiToken: null == apiToken
            ? _value.apiToken
            : apiToken // ignore: cast_nullable_to_non_nullable
                  as String,
        apiSessionId: null == apiSessionId
            ? _value.apiSessionId
            : apiSessionId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthSignInResultImpl implements _AuthSignInResult {
  const _$AuthSignInResultImpl({
    required this.user,
    required this.apiToken,
    required this.apiSessionId,
  });

  @override
  final UserModel user;
  @override
  final String apiToken;
  @override
  final String apiSessionId;

  @override
  String toString() {
    return 'AuthSignInResult(user: $user, apiToken: $apiToken, apiSessionId: $apiSessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSignInResultImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.apiToken, apiToken) ||
                other.apiToken == apiToken) &&
            (identical(other.apiSessionId, apiSessionId) ||
                other.apiSessionId == apiSessionId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, apiToken, apiSessionId);

  /// Create a copy of AuthSignInResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSignInResultImplCopyWith<_$AuthSignInResultImpl> get copyWith =>
      __$$AuthSignInResultImplCopyWithImpl<_$AuthSignInResultImpl>(
        this,
        _$identity,
      );
}

abstract class _AuthSignInResult implements AuthSignInResult {
  const factory _AuthSignInResult({
    required final UserModel user,
    required final String apiToken,
    required final String apiSessionId,
  }) = _$AuthSignInResultImpl;

  @override
  UserModel get user;
  @override
  String get apiToken;
  @override
  String get apiSessionId;

  /// Create a copy of AuthSignInResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthSignInResultImplCopyWith<_$AuthSignInResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
