// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waiting_room_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WaitingRoomModel {
  String get roomId => throw _privateConstructorUsedError;
  String get hostId => throw _privateConstructorUsedError;
  List<WaitingRoomPlayerModel> get players =>
      throw _privateConstructorUsedError;
  bool get isLocked => throw _privateConstructorUsedError;

  /// Create a copy of WaitingRoomModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaitingRoomModelCopyWith<WaitingRoomModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaitingRoomModelCopyWith<$Res> {
  factory $WaitingRoomModelCopyWith(
    WaitingRoomModel value,
    $Res Function(WaitingRoomModel) then,
  ) = _$WaitingRoomModelCopyWithImpl<$Res, WaitingRoomModel>;
  @useResult
  $Res call({
    String roomId,
    String hostId,
    List<WaitingRoomPlayerModel> players,
    bool isLocked,
  });
}

/// @nodoc
class _$WaitingRoomModelCopyWithImpl<$Res, $Val extends WaitingRoomModel>
    implements $WaitingRoomModelCopyWith<$Res> {
  _$WaitingRoomModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaitingRoomModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? hostId = null,
    Object? players = null,
    Object? isLocked = null,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            hostId: null == hostId
                ? _value.hostId
                : hostId // ignore: cast_nullable_to_non_nullable
                      as String,
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<WaitingRoomPlayerModel>,
            isLocked: null == isLocked
                ? _value.isLocked
                : isLocked // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WaitingRoomModelImplCopyWith<$Res>
    implements $WaitingRoomModelCopyWith<$Res> {
  factory _$$WaitingRoomModelImplCopyWith(
    _$WaitingRoomModelImpl value,
    $Res Function(_$WaitingRoomModelImpl) then,
  ) = __$$WaitingRoomModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roomId,
    String hostId,
    List<WaitingRoomPlayerModel> players,
    bool isLocked,
  });
}

/// @nodoc
class __$$WaitingRoomModelImplCopyWithImpl<$Res>
    extends _$WaitingRoomModelCopyWithImpl<$Res, _$WaitingRoomModelImpl>
    implements _$$WaitingRoomModelImplCopyWith<$Res> {
  __$$WaitingRoomModelImplCopyWithImpl(
    _$WaitingRoomModelImpl _value,
    $Res Function(_$WaitingRoomModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaitingRoomModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? hostId = null,
    Object? players = null,
    Object? isLocked = null,
  }) {
    return _then(
      _$WaitingRoomModelImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        hostId: null == hostId
            ? _value.hostId
            : hostId // ignore: cast_nullable_to_non_nullable
                  as String,
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<WaitingRoomPlayerModel>,
        isLocked: null == isLocked
            ? _value.isLocked
            : isLocked // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$WaitingRoomModelImpl implements _WaitingRoomModel {
  const _$WaitingRoomModelImpl({
    required this.roomId,
    required this.hostId,
    required final List<WaitingRoomPlayerModel> players,
    this.isLocked = false,
  }) : _players = players;

  @override
  final String roomId;
  @override
  final String hostId;
  final List<WaitingRoomPlayerModel> _players;
  @override
  List<WaitingRoomPlayerModel> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  @JsonKey()
  final bool isLocked;

  @override
  String toString() {
    return 'WaitingRoomModel(roomId: $roomId, hostId: $hostId, players: $players, isLocked: $isLocked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitingRoomModelImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    roomId,
    hostId,
    const DeepCollectionEquality().hash(_players),
    isLocked,
  );

  /// Create a copy of WaitingRoomModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitingRoomModelImplCopyWith<_$WaitingRoomModelImpl> get copyWith =>
      __$$WaitingRoomModelImplCopyWithImpl<_$WaitingRoomModelImpl>(
        this,
        _$identity,
      );
}

abstract class _WaitingRoomModel implements WaitingRoomModel {
  const factory _WaitingRoomModel({
    required final String roomId,
    required final String hostId,
    required final List<WaitingRoomPlayerModel> players,
    final bool isLocked,
  }) = _$WaitingRoomModelImpl;

  @override
  String get roomId;
  @override
  String get hostId;
  @override
  List<WaitingRoomPlayerModel> get players;
  @override
  bool get isLocked;

  /// Create a copy of WaitingRoomModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaitingRoomModelImplCopyWith<_$WaitingRoomModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
