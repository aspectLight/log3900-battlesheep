// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'socket_auth_credentials.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SocketAuthCredentialsModel {
  String get token => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;

  /// Create a copy of SocketAuthCredentialsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocketAuthCredentialsModelCopyWith<SocketAuthCredentialsModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocketAuthCredentialsModelCopyWith<$Res> {
  factory $SocketAuthCredentialsModelCopyWith(
    SocketAuthCredentialsModel value,
    $Res Function(SocketAuthCredentialsModel) then,
  ) =
      _$SocketAuthCredentialsModelCopyWithImpl<
        $Res,
        SocketAuthCredentialsModel
      >;
  @useResult
  $Res call({String token, String sessionId});
}

/// @nodoc
class _$SocketAuthCredentialsModelCopyWithImpl<
  $Res,
  $Val extends SocketAuthCredentialsModel
>
    implements $SocketAuthCredentialsModelCopyWith<$Res> {
  _$SocketAuthCredentialsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocketAuthCredentialsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? token = null, Object? sessionId = null}) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SocketAuthCredentialsModelImplCopyWith<$Res>
    implements $SocketAuthCredentialsModelCopyWith<$Res> {
  factory _$$SocketAuthCredentialsModelImplCopyWith(
    _$SocketAuthCredentialsModelImpl value,
    $Res Function(_$SocketAuthCredentialsModelImpl) then,
  ) = __$$SocketAuthCredentialsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, String sessionId});
}

/// @nodoc
class __$$SocketAuthCredentialsModelImplCopyWithImpl<$Res>
    extends
        _$SocketAuthCredentialsModelCopyWithImpl<
          $Res,
          _$SocketAuthCredentialsModelImpl
        >
    implements _$$SocketAuthCredentialsModelImplCopyWith<$Res> {
  __$$SocketAuthCredentialsModelImplCopyWithImpl(
    _$SocketAuthCredentialsModelImpl _value,
    $Res Function(_$SocketAuthCredentialsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SocketAuthCredentialsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? token = null, Object? sessionId = null}) {
    return _then(
      _$SocketAuthCredentialsModelImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SocketAuthCredentialsModelImpl implements _SocketAuthCredentialsModel {
  const _$SocketAuthCredentialsModelImpl({
    required this.token,
    required this.sessionId,
  });

  @override
  final String token;
  @override
  final String sessionId;

  @override
  String toString() {
    return 'SocketAuthCredentialsModel(token: $token, sessionId: $sessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocketAuthCredentialsModelImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, sessionId);

  /// Create a copy of SocketAuthCredentialsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocketAuthCredentialsModelImplCopyWith<_$SocketAuthCredentialsModelImpl>
  get copyWith =>
      __$$SocketAuthCredentialsModelImplCopyWithImpl<
        _$SocketAuthCredentialsModelImpl
      >(this, _$identity);
}

abstract class _SocketAuthCredentialsModel
    implements SocketAuthCredentialsModel {
  const factory _SocketAuthCredentialsModel({
    required final String token,
    required final String sessionId,
  }) = _$SocketAuthCredentialsModelImpl;

  @override
  String get token;
  @override
  String get sessionId;

  /// Create a copy of SocketAuthCredentialsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocketAuthCredentialsModelImplCopyWith<_$SocketAuthCredentialsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
