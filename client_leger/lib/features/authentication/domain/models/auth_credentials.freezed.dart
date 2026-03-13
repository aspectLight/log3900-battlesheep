// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_credentials.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthCredentialsModel {
  String get apiToken => throw _privateConstructorUsedError;
  String get apiSessionId => throw _privateConstructorUsedError;

  /// Create a copy of AuthCredentialsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthCredentialsModelCopyWith<AuthCredentialsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthCredentialsModelCopyWith<$Res> {
  factory $AuthCredentialsModelCopyWith(
    AuthCredentialsModel value,
    $Res Function(AuthCredentialsModel) then,
  ) = _$AuthCredentialsModelCopyWithImpl<$Res, AuthCredentialsModel>;
  @useResult
  $Res call({String apiToken, String apiSessionId});
}

/// @nodoc
class _$AuthCredentialsModelCopyWithImpl<
  $Res,
  $Val extends AuthCredentialsModel
>
    implements $AuthCredentialsModelCopyWith<$Res> {
  _$AuthCredentialsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthCredentialsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? apiToken = null, Object? apiSessionId = null}) {
    return _then(
      _value.copyWith(
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
}

/// @nodoc
abstract class _$$AuthCredentialsModelImplCopyWith<$Res>
    implements $AuthCredentialsModelCopyWith<$Res> {
  factory _$$AuthCredentialsModelImplCopyWith(
    _$AuthCredentialsModelImpl value,
    $Res Function(_$AuthCredentialsModelImpl) then,
  ) = __$$AuthCredentialsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String apiToken, String apiSessionId});
}

/// @nodoc
class __$$AuthCredentialsModelImplCopyWithImpl<$Res>
    extends _$AuthCredentialsModelCopyWithImpl<$Res, _$AuthCredentialsModelImpl>
    implements _$$AuthCredentialsModelImplCopyWith<$Res> {
  __$$AuthCredentialsModelImplCopyWithImpl(
    _$AuthCredentialsModelImpl _value,
    $Res Function(_$AuthCredentialsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthCredentialsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? apiToken = null, Object? apiSessionId = null}) {
    return _then(
      _$AuthCredentialsModelImpl(
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

class _$AuthCredentialsModelImpl implements _AuthCredentialsModel {
  const _$AuthCredentialsModelImpl({
    required this.apiToken,
    required this.apiSessionId,
  });

  @override
  final String apiToken;
  @override
  final String apiSessionId;

  @override
  String toString() {
    return 'AuthCredentialsModel(apiToken: $apiToken, apiSessionId: $apiSessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthCredentialsModelImpl &&
            (identical(other.apiToken, apiToken) ||
                other.apiToken == apiToken) &&
            (identical(other.apiSessionId, apiSessionId) ||
                other.apiSessionId == apiSessionId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, apiToken, apiSessionId);

  /// Create a copy of AuthCredentialsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthCredentialsModelImplCopyWith<_$AuthCredentialsModelImpl>
  get copyWith =>
      __$$AuthCredentialsModelImplCopyWithImpl<_$AuthCredentialsModelImpl>(
        this,
        _$identity,
      );
}

abstract class _AuthCredentialsModel implements AuthCredentialsModel {
  const factory _AuthCredentialsModel({
    required final String apiToken,
    required final String apiSessionId,
  }) = _$AuthCredentialsModelImpl;

  @override
  String get apiToken;
  @override
  String get apiSessionId;

  /// Create a copy of AuthCredentialsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthCredentialsModelImplCopyWith<_$AuthCredentialsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
