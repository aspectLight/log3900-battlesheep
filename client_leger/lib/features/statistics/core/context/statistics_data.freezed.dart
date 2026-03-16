// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StatisticsData {
  String get roomId => throw _privateConstructorUsedError;
  GameStatistics get initialData => throw _privateConstructorUsedError;
  bool get isCTF => throw _privateConstructorUsedError;

  /// Create a copy of StatisticsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatisticsDataCopyWith<StatisticsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticsDataCopyWith<$Res> {
  factory $StatisticsDataCopyWith(
    StatisticsData value,
    $Res Function(StatisticsData) then,
  ) = _$StatisticsDataCopyWithImpl<$Res, StatisticsData>;
  @useResult
  $Res call({String roomId, GameStatistics initialData, bool isCTF});

  $GameStatisticsCopyWith<$Res> get initialData;
}

/// @nodoc
class _$StatisticsDataCopyWithImpl<$Res, $Val extends StatisticsData>
    implements $StatisticsDataCopyWith<$Res> {
  _$StatisticsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatisticsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? initialData = null,
    Object? isCTF = null,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            initialData: null == initialData
                ? _value.initialData
                : initialData // ignore: cast_nullable_to_non_nullable
                      as GameStatistics,
            isCTF: null == isCTF
                ? _value.isCTF
                : isCTF // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of StatisticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameStatisticsCopyWith<$Res> get initialData {
    return $GameStatisticsCopyWith<$Res>(_value.initialData, (value) {
      return _then(_value.copyWith(initialData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StatisticsDataImplCopyWith<$Res>
    implements $StatisticsDataCopyWith<$Res> {
  factory _$$StatisticsDataImplCopyWith(
    _$StatisticsDataImpl value,
    $Res Function(_$StatisticsDataImpl) then,
  ) = __$$StatisticsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, GameStatistics initialData, bool isCTF});

  @override
  $GameStatisticsCopyWith<$Res> get initialData;
}

/// @nodoc
class __$$StatisticsDataImplCopyWithImpl<$Res>
    extends _$StatisticsDataCopyWithImpl<$Res, _$StatisticsDataImpl>
    implements _$$StatisticsDataImplCopyWith<$Res> {
  __$$StatisticsDataImplCopyWithImpl(
    _$StatisticsDataImpl _value,
    $Res Function(_$StatisticsDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatisticsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? initialData = null,
    Object? isCTF = null,
  }) {
    return _then(
      _$StatisticsDataImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        initialData: null == initialData
            ? _value.initialData
            : initialData // ignore: cast_nullable_to_non_nullable
                  as GameStatistics,
        isCTF: null == isCTF
            ? _value.isCTF
            : isCTF // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$StatisticsDataImpl implements _StatisticsData {
  const _$StatisticsDataImpl({
    required this.roomId,
    required this.initialData,
    required this.isCTF,
  });

  @override
  final String roomId;
  @override
  final GameStatistics initialData;
  @override
  final bool isCTF;

  @override
  String toString() {
    return 'StatisticsData(roomId: $roomId, initialData: $initialData, isCTF: $isCTF)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticsDataImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.initialData, initialData) ||
                other.initialData == initialData) &&
            (identical(other.isCTF, isCTF) || other.isCTF == isCTF));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, initialData, isCTF);

  /// Create a copy of StatisticsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatisticsDataImplCopyWith<_$StatisticsDataImpl> get copyWith =>
      __$$StatisticsDataImplCopyWithImpl<_$StatisticsDataImpl>(
        this,
        _$identity,
      );
}

abstract class _StatisticsData implements StatisticsData {
  const factory _StatisticsData({
    required final String roomId,
    required final GameStatistics initialData,
    required final bool isCTF,
  }) = _$StatisticsDataImpl;

  @override
  String get roomId;
  @override
  GameStatistics get initialData;
  @override
  bool get isCTF;

  /// Create a copy of StatisticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatisticsDataImplCopyWith<_$StatisticsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
