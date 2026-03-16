// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_creation_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CharacterCreationForm {
  String get name => throw _privateConstructorUsedError;
  Option<String> get selectedCharacterId => throw _privateConstructorUsedError;
  int get health => throw _privateConstructorUsedError;
  int get speed => throw _privateConstructorUsedError;
  int get attackDice => throw _privateConstructorUsedError;
  int get defenseDice => throw _privateConstructorUsedError;

  /// Create a copy of CharacterCreationForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterCreationFormCopyWith<CharacterCreationForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterCreationFormCopyWith<$Res> {
  factory $CharacterCreationFormCopyWith(
    CharacterCreationForm value,
    $Res Function(CharacterCreationForm) then,
  ) = _$CharacterCreationFormCopyWithImpl<$Res, CharacterCreationForm>;
  @useResult
  $Res call({
    String name,
    Option<String> selectedCharacterId,
    int health,
    int speed,
    int attackDice,
    int defenseDice,
  });
}

/// @nodoc
class _$CharacterCreationFormCopyWithImpl<
  $Res,
  $Val extends CharacterCreationForm
>
    implements $CharacterCreationFormCopyWith<$Res> {
  _$CharacterCreationFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CharacterCreationForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? selectedCharacterId = null,
    Object? health = null,
    Object? speed = null,
    Object? attackDice = null,
    Object? defenseDice = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedCharacterId: null == selectedCharacterId
                ? _value.selectedCharacterId
                : selectedCharacterId // ignore: cast_nullable_to_non_nullable
                      as Option<String>,
            health: null == health
                ? _value.health
                : health // ignore: cast_nullable_to_non_nullable
                      as int,
            speed: null == speed
                ? _value.speed
                : speed // ignore: cast_nullable_to_non_nullable
                      as int,
            attackDice: null == attackDice
                ? _value.attackDice
                : attackDice // ignore: cast_nullable_to_non_nullable
                      as int,
            defenseDice: null == defenseDice
                ? _value.defenseDice
                : defenseDice // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CharacterCreationFormImplCopyWith<$Res>
    implements $CharacterCreationFormCopyWith<$Res> {
  factory _$$CharacterCreationFormImplCopyWith(
    _$CharacterCreationFormImpl value,
    $Res Function(_$CharacterCreationFormImpl) then,
  ) = __$$CharacterCreationFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    Option<String> selectedCharacterId,
    int health,
    int speed,
    int attackDice,
    int defenseDice,
  });
}

/// @nodoc
class __$$CharacterCreationFormImplCopyWithImpl<$Res>
    extends
        _$CharacterCreationFormCopyWithImpl<$Res, _$CharacterCreationFormImpl>
    implements _$$CharacterCreationFormImplCopyWith<$Res> {
  __$$CharacterCreationFormImplCopyWithImpl(
    _$CharacterCreationFormImpl _value,
    $Res Function(_$CharacterCreationFormImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CharacterCreationForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? selectedCharacterId = null,
    Object? health = null,
    Object? speed = null,
    Object? attackDice = null,
    Object? defenseDice = null,
  }) {
    return _then(
      _$CharacterCreationFormImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedCharacterId: null == selectedCharacterId
            ? _value.selectedCharacterId
            : selectedCharacterId // ignore: cast_nullable_to_non_nullable
                  as Option<String>,
        health: null == health
            ? _value.health
            : health // ignore: cast_nullable_to_non_nullable
                  as int,
        speed: null == speed
            ? _value.speed
            : speed // ignore: cast_nullable_to_non_nullable
                  as int,
        attackDice: null == attackDice
            ? _value.attackDice
            : attackDice // ignore: cast_nullable_to_non_nullable
                  as int,
        defenseDice: null == defenseDice
            ? _value.defenseDice
            : defenseDice // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$CharacterCreationFormImpl implements _CharacterCreationForm {
  const _$CharacterCreationFormImpl({
    this.name = '',
    this.selectedCharacterId = const Option.none(),
    this.health = 4,
    this.speed = 4,
    this.attackDice = 4,
    this.defenseDice = 4,
  });

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final Option<String> selectedCharacterId;
  @override
  @JsonKey()
  final int health;
  @override
  @JsonKey()
  final int speed;
  @override
  @JsonKey()
  final int attackDice;
  @override
  @JsonKey()
  final int defenseDice;

  @override
  String toString() {
    return 'CharacterCreationForm(name: $name, selectedCharacterId: $selectedCharacterId, health: $health, speed: $speed, attackDice: $attackDice, defenseDice: $defenseDice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterCreationFormImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.selectedCharacterId, selectedCharacterId) ||
                other.selectedCharacterId == selectedCharacterId) &&
            (identical(other.health, health) || other.health == health) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.attackDice, attackDice) ||
                other.attackDice == attackDice) &&
            (identical(other.defenseDice, defenseDice) ||
                other.defenseDice == defenseDice));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    selectedCharacterId,
    health,
    speed,
    attackDice,
    defenseDice,
  );

  /// Create a copy of CharacterCreationForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterCreationFormImplCopyWith<_$CharacterCreationFormImpl>
  get copyWith =>
      __$$CharacterCreationFormImplCopyWithImpl<_$CharacterCreationFormImpl>(
        this,
        _$identity,
      );
}

abstract class _CharacterCreationForm implements CharacterCreationForm {
  const factory _CharacterCreationForm({
    final String name,
    final Option<String> selectedCharacterId,
    final int health,
    final int speed,
    final int attackDice,
    final int defenseDice,
  }) = _$CharacterCreationFormImpl;

  @override
  String get name;
  @override
  Option<String> get selectedCharacterId;
  @override
  int get health;
  @override
  int get speed;
  @override
  int get attackDice;
  @override
  int get defenseDice;

  /// Create a copy of CharacterCreationForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterCreationFormImplCopyWith<_$CharacterCreationFormImpl>
  get copyWith => throw _privateConstructorUsedError;
}
