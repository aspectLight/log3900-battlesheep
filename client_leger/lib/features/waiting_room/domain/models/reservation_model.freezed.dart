// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReservationModel {
  Character get character => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationModelCopyWith<ReservationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationModelCopyWith<$Res> {
  factory $ReservationModelCopyWith(
    ReservationModel value,
    $Res Function(ReservationModel) then,
  ) = _$ReservationModelCopyWithImpl<$Res, ReservationModel>;
  @useResult
  $Res call({Character character, String playerId});
}

/// @nodoc
class _$ReservationModelCopyWithImpl<$Res, $Val extends ReservationModel>
    implements $ReservationModelCopyWith<$Res> {
  _$ReservationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? character = null, Object? playerId = null}) {
    return _then(
      _value.copyWith(
            character: null == character
                ? _value.character
                : character // ignore: cast_nullable_to_non_nullable
                      as Character,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReservationModelImplCopyWith<$Res>
    implements $ReservationModelCopyWith<$Res> {
  factory _$$ReservationModelImplCopyWith(
    _$ReservationModelImpl value,
    $Res Function(_$ReservationModelImpl) then,
  ) = __$$ReservationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Character character, String playerId});
}

/// @nodoc
class __$$ReservationModelImplCopyWithImpl<$Res>
    extends _$ReservationModelCopyWithImpl<$Res, _$ReservationModelImpl>
    implements _$$ReservationModelImplCopyWith<$Res> {
  __$$ReservationModelImplCopyWithImpl(
    _$ReservationModelImpl _value,
    $Res Function(_$ReservationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? character = null, Object? playerId = null}) {
    return _then(
      _$ReservationModelImpl(
        character: null == character
            ? _value.character
            : character // ignore: cast_nullable_to_non_nullable
                  as Character,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ReservationModelImpl implements _ReservationModel {
  const _$ReservationModelImpl({
    required this.character,
    required this.playerId,
  });

  @override
  final Character character;
  @override
  final String playerId;

  @override
  String toString() {
    return 'ReservationModel(character: $character, playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationModelImpl &&
            (identical(other.character, character) ||
                other.character == character) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, character, playerId);

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationModelImplCopyWith<_$ReservationModelImpl> get copyWith =>
      __$$ReservationModelImplCopyWithImpl<_$ReservationModelImpl>(
        this,
        _$identity,
      );
}

abstract class _ReservationModel implements ReservationModel {
  const factory _ReservationModel({
    required final Character character,
    required final String playerId,
  }) = _$ReservationModelImpl;

  @override
  Character get character;
  @override
  String get playerId;

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationModelImplCopyWith<_$ReservationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
