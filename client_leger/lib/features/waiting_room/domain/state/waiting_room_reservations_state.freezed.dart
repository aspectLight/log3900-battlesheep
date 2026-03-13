// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waiting_room_reservations_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WaitingRoomReservationsState {
  String get roomId => throw _privateConstructorUsedError;
  List<ReservationModel> get reservations => throw _privateConstructorUsedError;

  /// Create a copy of WaitingRoomReservationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaitingRoomReservationsStateCopyWith<WaitingRoomReservationsState>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaitingRoomReservationsStateCopyWith<$Res> {
  factory $WaitingRoomReservationsStateCopyWith(
    WaitingRoomReservationsState value,
    $Res Function(WaitingRoomReservationsState) then,
  ) =
      _$WaitingRoomReservationsStateCopyWithImpl<
        $Res,
        WaitingRoomReservationsState
      >;
  @useResult
  $Res call({String roomId, List<ReservationModel> reservations});
}

/// @nodoc
class _$WaitingRoomReservationsStateCopyWithImpl<
  $Res,
  $Val extends WaitingRoomReservationsState
>
    implements $WaitingRoomReservationsStateCopyWith<$Res> {
  _$WaitingRoomReservationsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaitingRoomReservationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? reservations = null}) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            reservations: null == reservations
                ? _value.reservations
                : reservations // ignore: cast_nullable_to_non_nullable
                      as List<ReservationModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WaitingRoomReservationsStateImplCopyWith<$Res>
    implements $WaitingRoomReservationsStateCopyWith<$Res> {
  factory _$$WaitingRoomReservationsStateImplCopyWith(
    _$WaitingRoomReservationsStateImpl value,
    $Res Function(_$WaitingRoomReservationsStateImpl) then,
  ) = __$$WaitingRoomReservationsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, List<ReservationModel> reservations});
}

/// @nodoc
class __$$WaitingRoomReservationsStateImplCopyWithImpl<$Res>
    extends
        _$WaitingRoomReservationsStateCopyWithImpl<
          $Res,
          _$WaitingRoomReservationsStateImpl
        >
    implements _$$WaitingRoomReservationsStateImplCopyWith<$Res> {
  __$$WaitingRoomReservationsStateImplCopyWithImpl(
    _$WaitingRoomReservationsStateImpl _value,
    $Res Function(_$WaitingRoomReservationsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaitingRoomReservationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null, Object? reservations = null}) {
    return _then(
      _$WaitingRoomReservationsStateImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        reservations: null == reservations
            ? _value._reservations
            : reservations // ignore: cast_nullable_to_non_nullable
                  as List<ReservationModel>,
      ),
    );
  }
}

/// @nodoc

class _$WaitingRoomReservationsStateImpl
    implements _WaitingRoomReservationsState {
  const _$WaitingRoomReservationsStateImpl({
    required this.roomId,
    final List<ReservationModel> reservations = const [],
  }) : _reservations = reservations;

  @override
  final String roomId;
  final List<ReservationModel> _reservations;
  @override
  @JsonKey()
  List<ReservationModel> get reservations {
    if (_reservations is EqualUnmodifiableListView) return _reservations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reservations);
  }

  @override
  String toString() {
    return 'WaitingRoomReservationsState(roomId: $roomId, reservations: $reservations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitingRoomReservationsStateImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            const DeepCollectionEquality().equals(
              other._reservations,
              _reservations,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    roomId,
    const DeepCollectionEquality().hash(_reservations),
  );

  /// Create a copy of WaitingRoomReservationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitingRoomReservationsStateImplCopyWith<
    _$WaitingRoomReservationsStateImpl
  >
  get copyWith =>
      __$$WaitingRoomReservationsStateImplCopyWithImpl<
        _$WaitingRoomReservationsStateImpl
      >(this, _$identity);
}

abstract class _WaitingRoomReservationsState
    implements WaitingRoomReservationsState {
  const factory _WaitingRoomReservationsState({
    required final String roomId,
    final List<ReservationModel> reservations,
  }) = _$WaitingRoomReservationsStateImpl;

  @override
  String get roomId;
  @override
  List<ReservationModel> get reservations;

  /// Create a copy of WaitingRoomReservationsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaitingRoomReservationsStateImplCopyWith<
    _$WaitingRoomReservationsStateImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
