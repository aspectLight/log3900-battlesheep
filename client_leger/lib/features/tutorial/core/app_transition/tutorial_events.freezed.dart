// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tutorial_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TutorialEntryAppEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TutorialRequested value) requested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TutorialRequested value)? requested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TutorialRequested value)? requested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TutorialEntryAppEventCopyWith<$Res> {
  factory $TutorialEntryAppEventCopyWith(
    TutorialEntryAppEvent value,
    $Res Function(TutorialEntryAppEvent) then,
  ) = _$TutorialEntryAppEventCopyWithImpl<$Res, TutorialEntryAppEvent>;
}

/// @nodoc
class _$TutorialEntryAppEventCopyWithImpl<
  $Res,
  $Val extends TutorialEntryAppEvent
>
    implements $TutorialEntryAppEventCopyWith<$Res> {
  _$TutorialEntryAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TutorialEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$TutorialRequestedImplCopyWith<$Res> {
  factory _$$TutorialRequestedImplCopyWith(
    _$TutorialRequestedImpl value,
    $Res Function(_$TutorialRequestedImpl) then,
  ) = __$$TutorialRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TutorialRequestedImplCopyWithImpl<$Res>
    extends _$TutorialEntryAppEventCopyWithImpl<$Res, _$TutorialRequestedImpl>
    implements _$$TutorialRequestedImplCopyWith<$Res> {
  __$$TutorialRequestedImplCopyWithImpl(
    _$TutorialRequestedImpl _value,
    $Res Function(_$TutorialRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TutorialEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TutorialRequestedImpl implements TutorialRequested {
  const _$TutorialRequestedImpl();

  @override
  String toString() {
    return 'TutorialEntryAppEvent.requested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TutorialRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() requested,
  }) {
    return requested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? requested,
  }) {
    return requested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? requested,
    required TResult orElse(),
  }) {
    if (requested != null) {
      return requested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TutorialRequested value) requested,
  }) {
    return requested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TutorialRequested value)? requested,
  }) {
    return requested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TutorialRequested value)? requested,
    required TResult orElse(),
  }) {
    if (requested != null) {
      return requested(this);
    }
    return orElse();
  }
}

abstract class TutorialRequested implements TutorialEntryAppEvent {
  const factory TutorialRequested() = _$TutorialRequestedImpl;
}

/// @nodoc
mixin _$TutorialExitAppEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() leaveRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? leaveRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? leaveRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TutorialLeaveRequested value) leaveRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TutorialLeaveRequested value)? leaveRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TutorialLeaveRequested value)? leaveRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TutorialExitAppEventCopyWith<$Res> {
  factory $TutorialExitAppEventCopyWith(
    TutorialExitAppEvent value,
    $Res Function(TutorialExitAppEvent) then,
  ) = _$TutorialExitAppEventCopyWithImpl<$Res, TutorialExitAppEvent>;
}

/// @nodoc
class _$TutorialExitAppEventCopyWithImpl<
  $Res,
  $Val extends TutorialExitAppEvent
>
    implements $TutorialExitAppEventCopyWith<$Res> {
  _$TutorialExitAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TutorialExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$TutorialLeaveRequestedImplCopyWith<$Res> {
  factory _$$TutorialLeaveRequestedImplCopyWith(
    _$TutorialLeaveRequestedImpl value,
    $Res Function(_$TutorialLeaveRequestedImpl) then,
  ) = __$$TutorialLeaveRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TutorialLeaveRequestedImplCopyWithImpl<$Res>
    extends
        _$TutorialExitAppEventCopyWithImpl<$Res, _$TutorialLeaveRequestedImpl>
    implements _$$TutorialLeaveRequestedImplCopyWith<$Res> {
  __$$TutorialLeaveRequestedImplCopyWithImpl(
    _$TutorialLeaveRequestedImpl _value,
    $Res Function(_$TutorialLeaveRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TutorialExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TutorialLeaveRequestedImpl implements TutorialLeaveRequested {
  const _$TutorialLeaveRequestedImpl();

  @override
  String toString() {
    return 'TutorialExitAppEvent.leaveRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TutorialLeaveRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() leaveRequested,
  }) {
    return leaveRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? leaveRequested,
  }) {
    return leaveRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? leaveRequested,
    required TResult orElse(),
  }) {
    if (leaveRequested != null) {
      return leaveRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TutorialLeaveRequested value) leaveRequested,
  }) {
    return leaveRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TutorialLeaveRequested value)? leaveRequested,
  }) {
    return leaveRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TutorialLeaveRequested value)? leaveRequested,
    required TResult orElse(),
  }) {
    if (leaveRequested != null) {
      return leaveRequested(this);
    }
    return orElse();
  }
}

abstract class TutorialLeaveRequested implements TutorialExitAppEvent {
  const factory TutorialLeaveRequested() = _$TutorialLeaveRequestedImpl;
}
