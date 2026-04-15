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
  Character get chosenCharacter => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  bool get isVirtual => throw _privateConstructorUsedError;

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
  $Res call({
    String roomId,
    Character chosenCharacter,
    String playerId,
    bool isVirtual,
  });
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
    Object? chosenCharacter = null,
    Object? playerId = null,
    Object? isVirtual = null,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            chosenCharacter: null == chosenCharacter
                ? _value.chosenCharacter
                : chosenCharacter // ignore: cast_nullable_to_non_nullable
                      as Character,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            isVirtual: null == isVirtual
                ? _value.isVirtual
                : isVirtual // ignore: cast_nullable_to_non_nullable
                      as bool,
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
  $Res call({
    String roomId,
    Character chosenCharacter,
    String playerId,
    bool isVirtual,
  });
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
    Object? chosenCharacter = null,
    Object? playerId = null,
    Object? isVirtual = null,
  }) {
    return _then(
      _$ReserveCharacterCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        chosenCharacter: null == chosenCharacter
            ? _value.chosenCharacter
            : chosenCharacter // ignore: cast_nullable_to_non_nullable
                  as Character,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        isVirtual: null == isVirtual
            ? _value.isVirtual
            : isVirtual // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ReserveCharacterCommandImpl implements _ReserveCharacterCommand {
  const _$ReserveCharacterCommandImpl({
    required this.roomId,
    required this.chosenCharacter,
    required this.playerId,
    this.isVirtual = false,
  });

  @override
  final String roomId;
  @override
  final Character chosenCharacter;
  @override
  final String playerId;
  @override
  @JsonKey()
  final bool isVirtual;

  @override
  String toString() {
    return 'ReserveCharacterCommand(roomId: $roomId, chosenCharacter: $chosenCharacter, playerId: $playerId, isVirtual: $isVirtual)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReserveCharacterCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.chosenCharacter, chosenCharacter) ||
                other.chosenCharacter == chosenCharacter) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.isVirtual, isVirtual) ||
                other.isVirtual == isVirtual));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, roomId, chosenCharacter, playerId, isVirtual);

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
    required final Character chosenCharacter,
    required final String playerId,
    final bool isVirtual,
  }) = _$ReserveCharacterCommandImpl;

  @override
  String get roomId;
  @override
  Character get chosenCharacter;
  @override
  String get playerId;
  @override
  bool get isVirtual;

  /// Create a copy of ReserveCharacterCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReserveCharacterCommandImplCopyWith<_$ReserveCharacterCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}
