// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_creation_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReservedCharacterEvent {
  String get reservorId => throw _privateConstructorUsedError;
  String get chosenAvatar => throw _privateConstructorUsedError;

  /// Create a copy of ReservedCharacterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservedCharacterEventCopyWith<ReservedCharacterEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservedCharacterEventCopyWith<$Res> {
  factory $ReservedCharacterEventCopyWith(
    ReservedCharacterEvent value,
    $Res Function(ReservedCharacterEvent) then,
  ) = _$ReservedCharacterEventCopyWithImpl<$Res, ReservedCharacterEvent>;
  @useResult
  $Res call({String reservorId, String chosenAvatar});
}

/// @nodoc
class _$ReservedCharacterEventCopyWithImpl<
  $Res,
  $Val extends ReservedCharacterEvent
>
    implements $ReservedCharacterEventCopyWith<$Res> {
  _$ReservedCharacterEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservedCharacterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reservorId = null, Object? chosenAvatar = null}) {
    return _then(
      _value.copyWith(
            reservorId: null == reservorId
                ? _value.reservorId
                : reservorId // ignore: cast_nullable_to_non_nullable
                      as String,
            chosenAvatar: null == chosenAvatar
                ? _value.chosenAvatar
                : chosenAvatar // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReservedCharacterEventImplCopyWith<$Res>
    implements $ReservedCharacterEventCopyWith<$Res> {
  factory _$$ReservedCharacterEventImplCopyWith(
    _$ReservedCharacterEventImpl value,
    $Res Function(_$ReservedCharacterEventImpl) then,
  ) = __$$ReservedCharacterEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reservorId, String chosenAvatar});
}

/// @nodoc
class __$$ReservedCharacterEventImplCopyWithImpl<$Res>
    extends
        _$ReservedCharacterEventCopyWithImpl<$Res, _$ReservedCharacterEventImpl>
    implements _$$ReservedCharacterEventImplCopyWith<$Res> {
  __$$ReservedCharacterEventImplCopyWithImpl(
    _$ReservedCharacterEventImpl _value,
    $Res Function(_$ReservedCharacterEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReservedCharacterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reservorId = null, Object? chosenAvatar = null}) {
    return _then(
      _$ReservedCharacterEventImpl(
        reservorId: null == reservorId
            ? _value.reservorId
            : reservorId // ignore: cast_nullable_to_non_nullable
                  as String,
        chosenAvatar: null == chosenAvatar
            ? _value.chosenAvatar
            : chosenAvatar // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ReservedCharacterEventImpl implements _ReservedCharacterEvent {
  const _$ReservedCharacterEventImpl({
    required this.reservorId,
    required this.chosenAvatar,
  });

  @override
  final String reservorId;
  @override
  final String chosenAvatar;

  @override
  String toString() {
    return 'ReservedCharacterEvent(reservorId: $reservorId, chosenAvatar: $chosenAvatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservedCharacterEventImpl &&
            (identical(other.reservorId, reservorId) ||
                other.reservorId == reservorId) &&
            (identical(other.chosenAvatar, chosenAvatar) ||
                other.chosenAvatar == chosenAvatar));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reservorId, chosenAvatar);

  /// Create a copy of ReservedCharacterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservedCharacterEventImplCopyWith<_$ReservedCharacterEventImpl>
  get copyWith =>
      __$$ReservedCharacterEventImplCopyWithImpl<_$ReservedCharacterEventImpl>(
        this,
        _$identity,
      );
}

abstract class _ReservedCharacterEvent implements ReservedCharacterEvent {
  const factory _ReservedCharacterEvent({
    required final String reservorId,
    required final String chosenAvatar,
  }) = _$ReservedCharacterEventImpl;

  @override
  String get reservorId;
  @override
  String get chosenAvatar;

  /// Create a copy of ReservedCharacterEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservedCharacterEventImplCopyWith<_$ReservedCharacterEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}
