// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StatisticsState {
  GameStatistics get data => throw _privateConstructorUsedError;

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatisticsStateCopyWith<StatisticsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticsStateCopyWith<$Res> {
  factory $StatisticsStateCopyWith(
    StatisticsState value,
    $Res Function(StatisticsState) then,
  ) = _$StatisticsStateCopyWithImpl<$Res, StatisticsState>;
  @useResult
  $Res call({GameStatistics data});

  $GameStatisticsCopyWith<$Res> get data;
}

/// @nodoc
class _$StatisticsStateCopyWithImpl<$Res, $Val extends StatisticsState>
    implements $StatisticsStateCopyWith<$Res> {
  _$StatisticsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as GameStatistics,
          )
          as $Val,
    );
  }

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameStatisticsCopyWith<$Res> get data {
    return $GameStatisticsCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StatisticsStateImplCopyWith<$Res>
    implements $StatisticsStateCopyWith<$Res> {
  factory _$$StatisticsStateImplCopyWith(
    _$StatisticsStateImpl value,
    $Res Function(_$StatisticsStateImpl) then,
  ) = __$$StatisticsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GameStatistics data});

  @override
  $GameStatisticsCopyWith<$Res> get data;
}

/// @nodoc
class __$$StatisticsStateImplCopyWithImpl<$Res>
    extends _$StatisticsStateCopyWithImpl<$Res, _$StatisticsStateImpl>
    implements _$$StatisticsStateImplCopyWith<$Res> {
  __$$StatisticsStateImplCopyWithImpl(
    _$StatisticsStateImpl _value,
    $Res Function(_$StatisticsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$StatisticsStateImpl(
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as GameStatistics,
      ),
    );
  }
}

/// @nodoc

class _$StatisticsStateImpl implements _StatisticsState {
  const _$StatisticsStateImpl({required this.data});

  @override
  final GameStatistics data;

  @override
  String toString() {
    return 'StatisticsState(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticsStateImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatisticsStateImplCopyWith<_$StatisticsStateImpl> get copyWith =>
      __$$StatisticsStateImplCopyWithImpl<_$StatisticsStateImpl>(
        this,
        _$identity,
      );
}

abstract class _StatisticsState implements StatisticsState {
  const factory _StatisticsState({required final GameStatistics data}) =
      _$StatisticsStateImpl;

  @override
  GameStatistics get data;

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatisticsStateImplCopyWith<_$StatisticsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
