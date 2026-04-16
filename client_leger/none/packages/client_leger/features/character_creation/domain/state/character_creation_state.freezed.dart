// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_creation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CharacterCreationState {
  String get roomId => throw _privateConstructorUsedError;
  CharacterCreationForm get form => throw _privateConstructorUsedError;
  bool get roomLocked => throw _privateConstructorUsedError;
  List<ReservedCharacterEvent> get reservedCharacters =>
      throw _privateConstructorUsedError;

  /// Create a copy of CharacterCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterCreationStateCopyWith<CharacterCreationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterCreationStateCopyWith<$Res> {
  factory $CharacterCreationStateCopyWith(
    CharacterCreationState value,
    $Res Function(CharacterCreationState) then,
  ) = _$CharacterCreationStateCopyWithImpl<$Res, CharacterCreationState>;
  @useResult
  $Res call({
    String roomId,
    CharacterCreationForm form,
    bool roomLocked,
    List<ReservedCharacterEvent> reservedCharacters,
  });

  $CharacterCreationFormCopyWith<$Res> get form;
}

/// @nodoc
class _$CharacterCreationStateCopyWithImpl<
  $Res,
  $Val extends CharacterCreationState
>
    implements $CharacterCreationStateCopyWith<$Res> {
  _$CharacterCreationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CharacterCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? form = null,
    Object? roomLocked = null,
    Object? reservedCharacters = null,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            form: null == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                      as CharacterCreationForm,
            roomLocked: null == roomLocked
                ? _value.roomLocked
                : roomLocked // ignore: cast_nullable_to_non_nullable
                      as bool,
            reservedCharacters: null == reservedCharacters
                ? _value.reservedCharacters
                : reservedCharacters // ignore: cast_nullable_to_non_nullable
                      as List<ReservedCharacterEvent>,
          )
          as $Val,
    );
  }

  /// Create a copy of CharacterCreationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CharacterCreationFormCopyWith<$Res> get form {
    return $CharacterCreationFormCopyWith<$Res>(_value.form, (value) {
      return _then(_value.copyWith(form: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CharacterCreationStateImplCopyWith<$Res>
    implements $CharacterCreationStateCopyWith<$Res> {
  factory _$$CharacterCreationStateImplCopyWith(
    _$CharacterCreationStateImpl value,
    $Res Function(_$CharacterCreationStateImpl) then,
  ) = __$$CharacterCreationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roomId,
    CharacterCreationForm form,
    bool roomLocked,
    List<ReservedCharacterEvent> reservedCharacters,
  });

  @override
  $CharacterCreationFormCopyWith<$Res> get form;
}

/// @nodoc
class __$$CharacterCreationStateImplCopyWithImpl<$Res>
    extends
        _$CharacterCreationStateCopyWithImpl<$Res, _$CharacterCreationStateImpl>
    implements _$$CharacterCreationStateImplCopyWith<$Res> {
  __$$CharacterCreationStateImplCopyWithImpl(
    _$CharacterCreationStateImpl _value,
    $Res Function(_$CharacterCreationStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CharacterCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? form = null,
    Object? roomLocked = null,
    Object? reservedCharacters = null,
  }) {
    return _then(
      _$CharacterCreationStateImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        form: null == form
            ? _value.form
            : form // ignore: cast_nullable_to_non_nullable
                  as CharacterCreationForm,
        roomLocked: null == roomLocked
            ? _value.roomLocked
            : roomLocked // ignore: cast_nullable_to_non_nullable
                  as bool,
        reservedCharacters: null == reservedCharacters
            ? _value._reservedCharacters
            : reservedCharacters // ignore: cast_nullable_to_non_nullable
                  as List<ReservedCharacterEvent>,
      ),
    );
  }
}

/// @nodoc

class _$CharacterCreationStateImpl extends _CharacterCreationState {
  const _$CharacterCreationStateImpl({
    required this.roomId,
    required this.form,
    required this.roomLocked,
    final List<ReservedCharacterEvent> reservedCharacters = const [],
  }) : _reservedCharacters = reservedCharacters,
       super._();

  @override
  final String roomId;
  @override
  final CharacterCreationForm form;
  @override
  final bool roomLocked;
  final List<ReservedCharacterEvent> _reservedCharacters;
  @override
  @JsonKey()
  List<ReservedCharacterEvent> get reservedCharacters {
    if (_reservedCharacters is EqualUnmodifiableListView)
      return _reservedCharacters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reservedCharacters);
  }

  @override
  String toString() {
    return 'CharacterCreationState(roomId: $roomId, form: $form, roomLocked: $roomLocked, reservedCharacters: $reservedCharacters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterCreationStateImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.roomLocked, roomLocked) ||
                other.roomLocked == roomLocked) &&
            const DeepCollectionEquality().equals(
              other._reservedCharacters,
              _reservedCharacters,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    roomId,
    form,
    roomLocked,
    const DeepCollectionEquality().hash(_reservedCharacters),
  );

  /// Create a copy of CharacterCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterCreationStateImplCopyWith<_$CharacterCreationStateImpl>
  get copyWith =>
      __$$CharacterCreationStateImplCopyWithImpl<_$CharacterCreationStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CharacterCreationState extends CharacterCreationState {
  const factory _CharacterCreationState({
    required final String roomId,
    required final CharacterCreationForm form,
    required final bool roomLocked,
    final List<ReservedCharacterEvent> reservedCharacters,
  }) = _$CharacterCreationStateImpl;
  const _CharacterCreationState._() : super._();

  @override
  String get roomId;
  @override
  CharacterCreationForm get form;
  @override
  bool get roomLocked;
  @override
  List<ReservedCharacterEvent> get reservedCharacters;

  /// Create a copy of CharacterCreationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterCreationStateImplCopyWith<_$CharacterCreationStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
