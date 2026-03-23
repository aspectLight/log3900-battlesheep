// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_commands.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SetSessionStateCommand {
  SessionState get sessionState => throw _privateConstructorUsedError;

  /// Create a copy of SetSessionStateCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetSessionStateCommandCopyWith<SetSessionStateCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetSessionStateCommandCopyWith<$Res> {
  factory $SetSessionStateCommandCopyWith(
    SetSessionStateCommand value,
    $Res Function(SetSessionStateCommand) then,
  ) = _$SetSessionStateCommandCopyWithImpl<$Res, SetSessionStateCommand>;
  @useResult
  $Res call({SessionState sessionState});

  $SessionStateCopyWith<$Res> get sessionState;
}

/// @nodoc
class _$SetSessionStateCommandCopyWithImpl<
  $Res,
  $Val extends SetSessionStateCommand
>
    implements $SetSessionStateCommandCopyWith<$Res> {
  _$SetSessionStateCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetSessionStateCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sessionState = null}) {
    return _then(
      _value.copyWith(
            sessionState: null == sessionState
                ? _value.sessionState
                : sessionState // ignore: cast_nullable_to_non_nullable
                      as SessionState,
          )
          as $Val,
    );
  }

  /// Create a copy of SetSessionStateCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionStateCopyWith<$Res> get sessionState {
    return $SessionStateCopyWith<$Res>(_value.sessionState, (value) {
      return _then(_value.copyWith(sessionState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SetSessionStateCommandImplCopyWith<$Res>
    implements $SetSessionStateCommandCopyWith<$Res> {
  factory _$$SetSessionStateCommandImplCopyWith(
    _$SetSessionStateCommandImpl value,
    $Res Function(_$SetSessionStateCommandImpl) then,
  ) = __$$SetSessionStateCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SessionState sessionState});

  @override
  $SessionStateCopyWith<$Res> get sessionState;
}

/// @nodoc
class __$$SetSessionStateCommandImplCopyWithImpl<$Res>
    extends
        _$SetSessionStateCommandCopyWithImpl<$Res, _$SetSessionStateCommandImpl>
    implements _$$SetSessionStateCommandImplCopyWith<$Res> {
  __$$SetSessionStateCommandImplCopyWithImpl(
    _$SetSessionStateCommandImpl _value,
    $Res Function(_$SetSessionStateCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SetSessionStateCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sessionState = null}) {
    return _then(
      _$SetSessionStateCommandImpl(
        sessionState: null == sessionState
            ? _value.sessionState
            : sessionState // ignore: cast_nullable_to_non_nullable
                  as SessionState,
      ),
    );
  }
}

/// @nodoc

class _$SetSessionStateCommandImpl implements _SetSessionStateCommand {
  const _$SetSessionStateCommandImpl({required this.sessionState});

  @override
  final SessionState sessionState;

  @override
  String toString() {
    return 'SetSessionStateCommand(sessionState: $sessionState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetSessionStateCommandImpl &&
            (identical(other.sessionState, sessionState) ||
                other.sessionState == sessionState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionState);

  /// Create a copy of SetSessionStateCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetSessionStateCommandImplCopyWith<_$SetSessionStateCommandImpl>
  get copyWith =>
      __$$SetSessionStateCommandImplCopyWithImpl<_$SetSessionStateCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _SetSessionStateCommand implements SetSessionStateCommand {
  const factory _SetSessionStateCommand({
    required final SessionState sessionState,
  }) = _$SetSessionStateCommandImpl;

  @override
  SessionState get sessionState;

  /// Create a copy of SetSessionStateCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetSessionStateCommandImplCopyWith<_$SetSessionStateCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}
