// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reserve_character_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReserveCharacterCommand {
  String get roomId => throw _privateConstructorUsedError;
  String get chosenAvatar => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;

  /// Create a copy of ReserveCharacterCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReserveCharacterCommandCopyWith<ReserveCharacterCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReserveCharacterCommandCopyWith<$Res> {
  factory $ReserveCharacterCommandCopyWith(
    ReserveCharacterCommand value,
    $Res Function(ReserveCharacterCommand) then,
  ) = _$ReserveCharacterCommandCopyWithImpl<$Res, ReserveCharacterCommand>;
  @useResult
  $Res call({String roomId, String chosenAvatar, String playerId});
}

/// @nodoc
class _$ReserveCharacterCommandCopyWithImpl<
  $Res,
  $Val extends ReserveCharacterCommand
>
    implements $ReserveCharacterCommandCopyWith<$Res> {
  _$ReserveCharacterCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReserveCharacterCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? chosenAvatar = null,
    Object? playerId = null,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            chosenAvatar: null == chosenAvatar
                ? _value.chosenAvatar
                : chosenAvatar // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$ReserveCharacterCommandImplCopyWith<$Res>
    implements $ReserveCharacterCommandCopyWith<$Res> {
  factory _$$ReserveCharacterCommandImplCopyWith(
    _$ReserveCharacterCommandImpl value,
    $Res Function(_$ReserveCharacterCommandImpl) then,
  ) = __$$ReserveCharacterCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId, String chosenAvatar, String playerId});
}

/// @nodoc
class __$$ReserveCharacterCommandImplCopyWithImpl<$Res>
    extends
        _$ReserveCharacterCommandCopyWithImpl<
          $Res,
          _$ReserveCharacterCommandImpl
        >
    implements _$$ReserveCharacterCommandImplCopyWith<$Res> {
  __$$ReserveCharacterCommandImplCopyWithImpl(
    _$ReserveCharacterCommandImpl _value,
    $Res Function(_$ReserveCharacterCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReserveCharacterCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? chosenAvatar = null,
    Object? playerId = null,
  }) {
    return _then(
      _$ReserveCharacterCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        chosenAvatar: null == chosenAvatar
            ? _value.chosenAvatar
            : chosenAvatar // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ReserveCharacterCommandImpl implements _ReserveCharacterCommand {
  const _$ReserveCharacterCommandImpl({
    required this.roomId,
    required this.chosenAvatar,
    required this.playerId,
  });

  @override
  final String roomId;
  @override
  final String chosenAvatar;
  @override
  final String playerId;

  @override
  String toString() {
    return 'ReserveCharacterCommand(roomId: $roomId, chosenAvatar: $chosenAvatar, playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReserveCharacterCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.chosenAvatar, chosenAvatar) ||
                other.chosenAvatar == chosenAvatar) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId, chosenAvatar, playerId);

  /// Create a copy of ReserveCharacterCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReserveCharacterCommandImplCopyWith<_$ReserveCharacterCommandImpl>
  get copyWith =>
      __$$ReserveCharacterCommandImplCopyWithImpl<
        _$ReserveCharacterCommandImpl
      >(this, _$identity);
}

abstract class _ReserveCharacterCommand implements ReserveCharacterCommand {
  const factory _ReserveCharacterCommand({
    required final String roomId,
    required final String chosenAvatar,
    required final String playerId,
  }) = _$ReserveCharacterCommandImpl;

  @override
  String get roomId;
  @override
  String get chosenAvatar;
  @override
  String get playerId;

  /// Create a copy of ReserveCharacterCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReserveCharacterCommandImplCopyWith<_$ReserveCharacterCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}
