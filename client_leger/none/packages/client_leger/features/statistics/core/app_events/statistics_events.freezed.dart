// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StatisticsEntryAppEvent {
  String get roomId => throw _privateConstructorUsedError;
  bool get isCTF => throw _privateConstructorUsedError;
  GameRewardsInfo? get capturedRewards => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String roomId,
      bool isCTF,
      GameRewardsInfo? capturedRewards,
    )
    statisticsRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String roomId,
      bool isCTF,
      GameRewardsInfo? capturedRewards,
    )?
    statisticsRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String roomId,
      bool isCTF,
      GameRewardsInfo? capturedRewards,
    )?
    statisticsRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StatisticsRequested value) statisticsRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StatisticsRequested value)? statisticsRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StatisticsRequested value)? statisticsRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of StatisticsEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatisticsEntryAppEventCopyWith<StatisticsEntryAppEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticsEntryAppEventCopyWith<$Res> {
  factory $StatisticsEntryAppEventCopyWith(
    StatisticsEntryAppEvent value,
    $Res Function(StatisticsEntryAppEvent) then,
  ) = _$StatisticsEntryAppEventCopyWithImpl<$Res, StatisticsEntryAppEvent>;
  @useResult
  $Res call({String roomId, bool isCTF, GameRewardsInfo? capturedRewards});
}

/// @nodoc
class _$StatisticsEntryAppEventCopyWithImpl<
  $Res,
  $Val extends StatisticsEntryAppEvent
>
    implements $StatisticsEntryAppEventCopyWith<$Res> {
  _$StatisticsEntryAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatisticsEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? isCTF = null,
    Object? capturedRewards = freezed,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            isCTF: null == isCTF
                ? _value.isCTF
                : isCTF // ignore: cast_nullable_to_non_nullable
                      as bool,
            capturedRewards: freezed == capturedRewards
                ? _value.capturedRewards
                : capturedRewards // ignore: cast_nullable_to_non_nullable
                      as GameRewardsInfo?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StatisticsRequestedImplCopyWith<$Res>
    implements $StatisticsEntryAppEventCopyWith<$Res> {
  factory _$$StatisticsRequestedImplCopyWith(
    _$StatisticsRequestedImpl value,
    $Res Function(_$StatisticsRequestedImpl) then,
  ) = __$$StatisticsRequestedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, bool isCTF, GameRewardsInfo? capturedRewards});
}

/// @nodoc
class __$$StatisticsRequestedImplCopyWithImpl<$Res>
    extends
        _$StatisticsEntryAppEventCopyWithImpl<$Res, _$StatisticsRequestedImpl>
    implements _$$StatisticsRequestedImplCopyWith<$Res> {
  __$$StatisticsRequestedImplCopyWithImpl(
    _$StatisticsRequestedImpl _value,
    $Res Function(_$StatisticsRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatisticsEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? isCTF = null,
    Object? capturedRewards = freezed,
  }) {
    return _then(
      _$StatisticsRequestedImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        isCTF: null == isCTF
            ? _value.isCTF
            : isCTF // ignore: cast_nullable_to_non_nullable
                  as bool,
        capturedRewards: freezed == capturedRewards
            ? _value.capturedRewards
            : capturedRewards // ignore: cast_nullable_to_non_nullable
                  as GameRewardsInfo?,
      ),
    );
  }
}

/// @nodoc

class _$StatisticsRequestedImpl implements StatisticsRequested {
  const _$StatisticsRequestedImpl({
    required this.roomId,
    required this.isCTF,
    this.capturedRewards,
  });

  @override
  final String roomId;
  @override
  final bool isCTF;
  @override
  final GameRewardsInfo? capturedRewards;

  @override
  String toString() {
    return 'StatisticsEntryAppEvent.statisticsRequested(roomId: $roomId, isCTF: $isCTF, capturedRewards: $capturedRewards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticsRequestedImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.isCTF, isCTF) || other.isCTF == isCTF) &&
            (identical(other.capturedRewards, capturedRewards) ||
                other.capturedRewards == capturedRewards));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, isCTF, capturedRewards);

  /// Create a copy of StatisticsEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatisticsRequestedImplCopyWith<_$StatisticsRequestedImpl> get copyWith =>
      __$$StatisticsRequestedImplCopyWithImpl<_$StatisticsRequestedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String roomId,
      bool isCTF,
      GameRewardsInfo? capturedRewards,
    )
    statisticsRequested,
  }) {
    return statisticsRequested(roomId, isCTF, capturedRewards);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String roomId,
      bool isCTF,
      GameRewardsInfo? capturedRewards,
    )?
    statisticsRequested,
  }) {
    return statisticsRequested?.call(roomId, isCTF, capturedRewards);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String roomId,
      bool isCTF,
      GameRewardsInfo? capturedRewards,
    )?
    statisticsRequested,
    required TResult orElse(),
  }) {
    if (statisticsRequested != null) {
      return statisticsRequested(roomId, isCTF, capturedRewards);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StatisticsRequested value) statisticsRequested,
  }) {
    return statisticsRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StatisticsRequested value)? statisticsRequested,
  }) {
    return statisticsRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StatisticsRequested value)? statisticsRequested,
    required TResult orElse(),
  }) {
    if (statisticsRequested != null) {
      return statisticsRequested(this);
    }
    return orElse();
  }
}

abstract class StatisticsRequested implements StatisticsEntryAppEvent {
  const factory StatisticsRequested({
    required final String roomId,
    required final bool isCTF,
    final GameRewardsInfo? capturedRewards,
  }) = _$StatisticsRequestedImpl;

  @override
  String get roomId;
  @override
  bool get isCTF;
  @override
  GameRewardsInfo? get capturedRewards;

  /// Create a copy of StatisticsEntryAppEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatisticsRequestedImplCopyWith<_$StatisticsRequestedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StatisticsCompletedAppEvent {}

/// @nodoc
abstract class $StatisticsCompletedAppEventCopyWith<$Res> {
  factory $StatisticsCompletedAppEventCopyWith(
    StatisticsCompletedAppEvent value,
    $Res Function(StatisticsCompletedAppEvent) then,
  ) =
      _$StatisticsCompletedAppEventCopyWithImpl<
        $Res,
        StatisticsCompletedAppEvent
      >;
}

/// @nodoc
class _$StatisticsCompletedAppEventCopyWithImpl<
  $Res,
  $Val extends StatisticsCompletedAppEvent
>
    implements $StatisticsCompletedAppEventCopyWith<$Res> {
  _$StatisticsCompletedAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatisticsCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$StatisticsCompletedAppEventImplCopyWith<$Res> {
  factory _$$StatisticsCompletedAppEventImplCopyWith(
    _$StatisticsCompletedAppEventImpl value,
    $Res Function(_$StatisticsCompletedAppEventImpl) then,
  ) = __$$StatisticsCompletedAppEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StatisticsCompletedAppEventImplCopyWithImpl<$Res>
    extends
        _$StatisticsCompletedAppEventCopyWithImpl<
          $Res,
          _$StatisticsCompletedAppEventImpl
        >
    implements _$$StatisticsCompletedAppEventImplCopyWith<$Res> {
  __$$StatisticsCompletedAppEventImplCopyWithImpl(
    _$StatisticsCompletedAppEventImpl _value,
    $Res Function(_$StatisticsCompletedAppEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatisticsCompletedAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StatisticsCompletedAppEventImpl
    implements _StatisticsCompletedAppEvent {
  const _$StatisticsCompletedAppEventImpl();

  @override
  String toString() {
    return 'StatisticsCompletedAppEvent()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticsCompletedAppEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _StatisticsCompletedAppEvent
    implements StatisticsCompletedAppEvent {
  const factory _StatisticsCompletedAppEvent() =
      _$StatisticsCompletedAppEventImpl;
}

/// @nodoc
mixin _$StatisticsExitAppEvent {
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
    required TResult Function(LeaveStatisticsRequestedCommand value)
    leaveRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaveStatisticsRequestedCommand value)? leaveRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaveStatisticsRequestedCommand value)? leaveRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticsExitAppEventCopyWith<$Res> {
  factory $StatisticsExitAppEventCopyWith(
    StatisticsExitAppEvent value,
    $Res Function(StatisticsExitAppEvent) then,
  ) = _$StatisticsExitAppEventCopyWithImpl<$Res, StatisticsExitAppEvent>;
}

/// @nodoc
class _$StatisticsExitAppEventCopyWithImpl<
  $Res,
  $Val extends StatisticsExitAppEvent
>
    implements $StatisticsExitAppEventCopyWith<$Res> {
  _$StatisticsExitAppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatisticsExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LeaveStatisticsRequestedCommandImplCopyWith<$Res> {
  factory _$$LeaveStatisticsRequestedCommandImplCopyWith(
    _$LeaveStatisticsRequestedCommandImpl value,
    $Res Function(_$LeaveStatisticsRequestedCommandImpl) then,
  ) = __$$LeaveStatisticsRequestedCommandImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LeaveStatisticsRequestedCommandImplCopyWithImpl<$Res>
    extends
        _$StatisticsExitAppEventCopyWithImpl<
          $Res,
          _$LeaveStatisticsRequestedCommandImpl
        >
    implements _$$LeaveStatisticsRequestedCommandImplCopyWith<$Res> {
  __$$LeaveStatisticsRequestedCommandImplCopyWithImpl(
    _$LeaveStatisticsRequestedCommandImpl _value,
    $Res Function(_$LeaveStatisticsRequestedCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatisticsExitAppEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LeaveStatisticsRequestedCommandImpl
    implements LeaveStatisticsRequestedCommand {
  const _$LeaveStatisticsRequestedCommandImpl();

  @override
  String toString() {
    return 'StatisticsExitAppEvent.leaveRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaveStatisticsRequestedCommandImpl);
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
    required TResult Function(LeaveStatisticsRequestedCommand value)
    leaveRequested,
  }) {
    return leaveRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaveStatisticsRequestedCommand value)? leaveRequested,
  }) {
    return leaveRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaveStatisticsRequestedCommand value)? leaveRequested,
    required TResult orElse(),
  }) {
    if (leaveRequested != null) {
      return leaveRequested(this);
    }
    return orElse();
  }
}

abstract class LeaveStatisticsRequestedCommand
    implements StatisticsExitAppEvent {
  const factory LeaveStatisticsRequestedCommand() =
      _$LeaveStatisticsRequestedCommandImpl;
}
