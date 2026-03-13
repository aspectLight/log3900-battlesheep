// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_reserved_characters_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GetReservedCharactersCommand {
  String get roomId => throw _privateConstructorUsedError;

  /// Create a copy of GetReservedCharactersCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetReservedCharactersCommandCopyWith<GetReservedCharactersCommand>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetReservedCharactersCommandCopyWith<$Res> {
  factory $GetReservedCharactersCommandCopyWith(
    GetReservedCharactersCommand value,
    $Res Function(GetReservedCharactersCommand) then,
  ) =
      _$GetReservedCharactersCommandCopyWithImpl<
        $Res,
        GetReservedCharactersCommand
      >;
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class _$GetReservedCharactersCommandCopyWithImpl<
  $Res,
  $Val extends GetReservedCharactersCommand
>
    implements $GetReservedCharactersCommandCopyWith<$Res> {
  _$GetReservedCharactersCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetReservedCharactersCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetReservedCharactersCommandImplCopyWith<$Res>
    implements $GetReservedCharactersCommandCopyWith<$Res> {
  factory _$$GetReservedCharactersCommandImplCopyWith(
    _$GetReservedCharactersCommandImpl value,
    $Res Function(_$GetReservedCharactersCommandImpl) then,
  ) = __$$GetReservedCharactersCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String roomId});
}

/// @nodoc
class __$$GetReservedCharactersCommandImplCopyWithImpl<$Res>
    extends
        _$GetReservedCharactersCommandCopyWithImpl<
          $Res,
          _$GetReservedCharactersCommandImpl
        >
    implements _$$GetReservedCharactersCommandImplCopyWith<$Res> {
  __$$GetReservedCharactersCommandImplCopyWithImpl(
    _$GetReservedCharactersCommandImpl _value,
    $Res Function(_$GetReservedCharactersCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetReservedCharactersCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roomId = null}) {
    return _then(
      _$GetReservedCharactersCommandImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GetReservedCharactersCommandImpl
    implements _GetReservedCharactersCommand {
  const _$GetReservedCharactersCommandImpl({required this.roomId});

  @override
  final String roomId;

  @override
  String toString() {
    return 'GetReservedCharactersCommand(roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetReservedCharactersCommandImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomId);

  /// Create a copy of GetReservedCharactersCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetReservedCharactersCommandImplCopyWith<
    _$GetReservedCharactersCommandImpl
  >
  get copyWith =>
      __$$GetReservedCharactersCommandImplCopyWithImpl<
        _$GetReservedCharactersCommandImpl
      >(this, _$identity);
}

abstract class _GetReservedCharactersCommand
    implements GetReservedCharactersCommand {
  const factory _GetReservedCharactersCommand({required final String roomId}) =
      _$GetReservedCharactersCommandImpl;

  @override
  String get roomId;

  /// Create a copy of GetReservedCharactersCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetReservedCharactersCommandImplCopyWith<
    _$GetReservedCharactersCommandImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
