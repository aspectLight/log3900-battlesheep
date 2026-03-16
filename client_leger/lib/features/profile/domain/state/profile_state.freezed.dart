// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProfileState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(
      ProfileModel profile,
      ProfileStatisticsModel statistics,
    )
    loaded,
    required TResult Function(ProfileFailure failure) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(ProfileModel profile, ProfileStatisticsModel statistics)?
    loaded,
    TResult? Function(ProfileFailure failure)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(ProfileModel profile, ProfileStatisticsModel statistics)?
    loaded,
    TResult Function(ProfileFailure failure)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProfileStateIdle value) idle,
    required TResult Function(ProfileStateLoading value) loading,
    required TResult Function(ProfileStateLoaded value) loaded,
    required TResult Function(ProfileStateError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProfileStateIdle value)? idle,
    TResult? Function(ProfileStateLoading value)? loading,
    TResult? Function(ProfileStateLoaded value)? loaded,
    TResult? Function(ProfileStateError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProfileStateIdle value)? idle,
    TResult Function(ProfileStateLoading value)? loading,
    TResult Function(ProfileStateLoaded value)? loaded,
    TResult Function(ProfileStateError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStateCopyWith<$Res> {
  factory $ProfileStateCopyWith(
    ProfileState value,
    $Res Function(ProfileState) then,
  ) = _$ProfileStateCopyWithImpl<$Res, ProfileState>;
}

/// @nodoc
class _$ProfileStateCopyWithImpl<$Res, $Val extends ProfileState>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ProfileStateIdleImplCopyWith<$Res> {
  factory _$$ProfileStateIdleImplCopyWith(
    _$ProfileStateIdleImpl value,
    $Res Function(_$ProfileStateIdleImpl) then,
  ) = __$$ProfileStateIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProfileStateIdleImplCopyWithImpl<$Res>
    extends _$ProfileStateCopyWithImpl<$Res, _$ProfileStateIdleImpl>
    implements _$$ProfileStateIdleImplCopyWith<$Res> {
  __$$ProfileStateIdleImplCopyWithImpl(
    _$ProfileStateIdleImpl _value,
    $Res Function(_$ProfileStateIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProfileStateIdleImpl implements ProfileStateIdle {
  const _$ProfileStateIdleImpl();

  @override
  String toString() {
    return 'ProfileState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProfileStateIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(
      ProfileModel profile,
      ProfileStatisticsModel statistics,
    )
    loaded,
    required TResult Function(ProfileFailure failure) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(ProfileModel profile, ProfileStatisticsModel statistics)?
    loaded,
    TResult? Function(ProfileFailure failure)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(ProfileModel profile, ProfileStatisticsModel statistics)?
    loaded,
    TResult Function(ProfileFailure failure)? error,
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
    required TResult Function(ProfileStateIdle value) idle,
    required TResult Function(ProfileStateLoading value) loading,
    required TResult Function(ProfileStateLoaded value) loaded,
    required TResult Function(ProfileStateError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProfileStateIdle value)? idle,
    TResult? Function(ProfileStateLoading value)? loading,
    TResult? Function(ProfileStateLoaded value)? loaded,
    TResult? Function(ProfileStateError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProfileStateIdle value)? idle,
    TResult Function(ProfileStateLoading value)? loading,
    TResult Function(ProfileStateLoaded value)? loaded,
    TResult Function(ProfileStateError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class ProfileStateIdle implements ProfileState {
  const factory ProfileStateIdle() = _$ProfileStateIdleImpl;
}

/// @nodoc
abstract class _$$ProfileStateLoadingImplCopyWith<$Res> {
  factory _$$ProfileStateLoadingImplCopyWith(
    _$ProfileStateLoadingImpl value,
    $Res Function(_$ProfileStateLoadingImpl) then,
  ) = __$$ProfileStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProfileStateLoadingImplCopyWithImpl<$Res>
    extends _$ProfileStateCopyWithImpl<$Res, _$ProfileStateLoadingImpl>
    implements _$$ProfileStateLoadingImplCopyWith<$Res> {
  __$$ProfileStateLoadingImplCopyWithImpl(
    _$ProfileStateLoadingImpl _value,
    $Res Function(_$ProfileStateLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProfileStateLoadingImpl implements ProfileStateLoading {
  const _$ProfileStateLoadingImpl();

  @override
  String toString() {
    return 'ProfileState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(
      ProfileModel profile,
      ProfileStatisticsModel statistics,
    )
    loaded,
    required TResult Function(ProfileFailure failure) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(ProfileModel profile, ProfileStatisticsModel statistics)?
    loaded,
    TResult? Function(ProfileFailure failure)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(ProfileModel profile, ProfileStatisticsModel statistics)?
    loaded,
    TResult Function(ProfileFailure failure)? error,
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
    required TResult Function(ProfileStateIdle value) idle,
    required TResult Function(ProfileStateLoading value) loading,
    required TResult Function(ProfileStateLoaded value) loaded,
    required TResult Function(ProfileStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProfileStateIdle value)? idle,
    TResult? Function(ProfileStateLoading value)? loading,
    TResult? Function(ProfileStateLoaded value)? loaded,
    TResult? Function(ProfileStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProfileStateIdle value)? idle,
    TResult Function(ProfileStateLoading value)? loading,
    TResult Function(ProfileStateLoaded value)? loaded,
    TResult Function(ProfileStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ProfileStateLoading implements ProfileState {
  const factory ProfileStateLoading() = _$ProfileStateLoadingImpl;
}

/// @nodoc
abstract class _$$ProfileStateLoadedImplCopyWith<$Res> {
  factory _$$ProfileStateLoadedImplCopyWith(
    _$ProfileStateLoadedImpl value,
    $Res Function(_$ProfileStateLoadedImpl) then,
  ) = __$$ProfileStateLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ProfileModel profile, ProfileStatisticsModel statistics});
}

/// @nodoc
class __$$ProfileStateLoadedImplCopyWithImpl<$Res>
    extends _$ProfileStateCopyWithImpl<$Res, _$ProfileStateLoadedImpl>
    implements _$$ProfileStateLoadedImplCopyWith<$Res> {
  __$$ProfileStateLoadedImplCopyWithImpl(
    _$ProfileStateLoadedImpl _value,
    $Res Function(_$ProfileStateLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profile = null, Object? statistics = null}) {
    return _then(
      _$ProfileStateLoadedImpl(
        profile: null == profile
            ? _value.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as ProfileModel,
        statistics: null == statistics
            ? _value.statistics
            : statistics // ignore: cast_nullable_to_non_nullable
                  as ProfileStatisticsModel,
      ),
    );
  }
}

/// @nodoc

class _$ProfileStateLoadedImpl implements ProfileStateLoaded {
  const _$ProfileStateLoadedImpl({
    required this.profile,
    required this.statistics,
  });

  @override
  final ProfileModel profile;
  @override
  final ProfileStatisticsModel statistics;

  @override
  String toString() {
    return 'ProfileState.loaded(profile: $profile, statistics: $statistics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStateLoadedImpl &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.statistics, statistics) ||
                other.statistics == statistics));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profile, statistics);

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileStateLoadedImplCopyWith<_$ProfileStateLoadedImpl> get copyWith =>
      __$$ProfileStateLoadedImplCopyWithImpl<_$ProfileStateLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(
      ProfileModel profile,
      ProfileStatisticsModel statistics,
    )
    loaded,
    required TResult Function(ProfileFailure failure) error,
  }) {
    return loaded(profile, statistics);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(ProfileModel profile, ProfileStatisticsModel statistics)?
    loaded,
    TResult? Function(ProfileFailure failure)? error,
  }) {
    return loaded?.call(profile, statistics);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(ProfileModel profile, ProfileStatisticsModel statistics)?
    loaded,
    TResult Function(ProfileFailure failure)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(profile, statistics);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProfileStateIdle value) idle,
    required TResult Function(ProfileStateLoading value) loading,
    required TResult Function(ProfileStateLoaded value) loaded,
    required TResult Function(ProfileStateError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProfileStateIdle value)? idle,
    TResult? Function(ProfileStateLoading value)? loading,
    TResult? Function(ProfileStateLoaded value)? loaded,
    TResult? Function(ProfileStateError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProfileStateIdle value)? idle,
    TResult Function(ProfileStateLoading value)? loading,
    TResult Function(ProfileStateLoaded value)? loaded,
    TResult Function(ProfileStateError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ProfileStateLoaded implements ProfileState {
  const factory ProfileStateLoaded({
    required final ProfileModel profile,
    required final ProfileStatisticsModel statistics,
  }) = _$ProfileStateLoadedImpl;

  ProfileModel get profile;
  ProfileStatisticsModel get statistics;

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileStateLoadedImplCopyWith<_$ProfileStateLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProfileStateErrorImplCopyWith<$Res> {
  factory _$$ProfileStateErrorImplCopyWith(
    _$ProfileStateErrorImpl value,
    $Res Function(_$ProfileStateErrorImpl) then,
  ) = __$$ProfileStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ProfileFailure failure});
}

/// @nodoc
class __$$ProfileStateErrorImplCopyWithImpl<$Res>
    extends _$ProfileStateCopyWithImpl<$Res, _$ProfileStateErrorImpl>
    implements _$$ProfileStateErrorImplCopyWith<$Res> {
  __$$ProfileStateErrorImplCopyWithImpl(
    _$ProfileStateErrorImpl _value,
    $Res Function(_$ProfileStateErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null}) {
    return _then(
      _$ProfileStateErrorImpl(
        null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as ProfileFailure,
      ),
    );
  }
}

/// @nodoc

class _$ProfileStateErrorImpl implements ProfileStateError {
  const _$ProfileStateErrorImpl(this.failure);

  @override
  final ProfileFailure failure;

  @override
  String toString() {
    return 'ProfileState.error(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStateErrorImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileStateErrorImplCopyWith<_$ProfileStateErrorImpl> get copyWith =>
      __$$ProfileStateErrorImplCopyWithImpl<_$ProfileStateErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(
      ProfileModel profile,
      ProfileStatisticsModel statistics,
    )
    loaded,
    required TResult Function(ProfileFailure failure) error,
  }) {
    return error(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(ProfileModel profile, ProfileStatisticsModel statistics)?
    loaded,
    TResult? Function(ProfileFailure failure)? error,
  }) {
    return error?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(ProfileModel profile, ProfileStatisticsModel statistics)?
    loaded,
    TResult Function(ProfileFailure failure)? error,
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
    required TResult Function(ProfileStateIdle value) idle,
    required TResult Function(ProfileStateLoading value) loading,
    required TResult Function(ProfileStateLoaded value) loaded,
    required TResult Function(ProfileStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProfileStateIdle value)? idle,
    TResult? Function(ProfileStateLoading value)? loading,
    TResult? Function(ProfileStateLoaded value)? loaded,
    TResult? Function(ProfileStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProfileStateIdle value)? idle,
    TResult Function(ProfileStateLoading value)? loading,
    TResult Function(ProfileStateLoaded value)? loaded,
    TResult Function(ProfileStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ProfileStateError implements ProfileState {
  const factory ProfileStateError(final ProfileFailure failure) =
      _$ProfileStateErrorImpl;

  ProfileFailure get failure;

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileStateErrorImplCopyWith<_$ProfileStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
