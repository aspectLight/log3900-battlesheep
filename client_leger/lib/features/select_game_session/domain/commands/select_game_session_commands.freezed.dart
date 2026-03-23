// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'select_game_session_commands.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LoadGamesCommand {}

/// @nodoc
abstract class $LoadGamesCommandCopyWith<$Res> {
  factory $LoadGamesCommandCopyWith(
    LoadGamesCommand value,
    $Res Function(LoadGamesCommand) then,
  ) = _$LoadGamesCommandCopyWithImpl<$Res, LoadGamesCommand>;
}

/// @nodoc
class _$LoadGamesCommandCopyWithImpl<$Res, $Val extends LoadGamesCommand>
    implements $LoadGamesCommandCopyWith<$Res> {
  _$LoadGamesCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoadGamesCommand
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadGamesCommandImplCopyWith<$Res> {
  factory _$$LoadGamesCommandImplCopyWith(
    _$LoadGamesCommandImpl value,
    $Res Function(_$LoadGamesCommandImpl) then,
  ) = __$$LoadGamesCommandImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadGamesCommandImplCopyWithImpl<$Res>
    extends _$LoadGamesCommandCopyWithImpl<$Res, _$LoadGamesCommandImpl>
    implements _$$LoadGamesCommandImplCopyWith<$Res> {
  __$$LoadGamesCommandImplCopyWithImpl(
    _$LoadGamesCommandImpl _value,
    $Res Function(_$LoadGamesCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoadGamesCommand
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadGamesCommandImpl implements _LoadGamesCommand {
  const _$LoadGamesCommandImpl();

  @override
  String toString() {
    return 'LoadGamesCommand()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadGamesCommandImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _LoadGamesCommand implements LoadGamesCommand {
  const factory _LoadGamesCommand() = _$LoadGamesCommandImpl;
}

/// @nodoc
mixin _$ConfirmSelectionCommand {
  String get selectedGameId => throw _privateConstructorUsedError;

  /// Create a copy of ConfirmSelectionCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfirmSelectionCommandCopyWith<ConfirmSelectionCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfirmSelectionCommandCopyWith<$Res> {
  factory $ConfirmSelectionCommandCopyWith(
    ConfirmSelectionCommand value,
    $Res Function(ConfirmSelectionCommand) then,
  ) = _$ConfirmSelectionCommandCopyWithImpl<$Res, ConfirmSelectionCommand>;
  @useResult
  $Res call({String selectedGameId});
}

/// @nodoc
class _$ConfirmSelectionCommandCopyWithImpl<
  $Res,
  $Val extends ConfirmSelectionCommand
>
    implements $ConfirmSelectionCommandCopyWith<$Res> {
  _$ConfirmSelectionCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfirmSelectionCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? selectedGameId = null}) {
    return _then(
      _value.copyWith(
            selectedGameId: null == selectedGameId
                ? _value.selectedGameId
                : selectedGameId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConfirmSelectionCommandImplCopyWith<$Res>
    implements $ConfirmSelectionCommandCopyWith<$Res> {
  factory _$$ConfirmSelectionCommandImplCopyWith(
    _$ConfirmSelectionCommandImpl value,
    $Res Function(_$ConfirmSelectionCommandImpl) then,
  ) = __$$ConfirmSelectionCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String selectedGameId});
}

/// @nodoc
class __$$ConfirmSelectionCommandImplCopyWithImpl<$Res>
    extends
        _$ConfirmSelectionCommandCopyWithImpl<
          $Res,
          _$ConfirmSelectionCommandImpl
        >
    implements _$$ConfirmSelectionCommandImplCopyWith<$Res> {
  __$$ConfirmSelectionCommandImplCopyWithImpl(
    _$ConfirmSelectionCommandImpl _value,
    $Res Function(_$ConfirmSelectionCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConfirmSelectionCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? selectedGameId = null}) {
    return _then(
      _$ConfirmSelectionCommandImpl(
        selectedGameId: null == selectedGameId
            ? _value.selectedGameId
            : selectedGameId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ConfirmSelectionCommandImpl implements _ConfirmSelectionCommand {
  const _$ConfirmSelectionCommandImpl({required this.selectedGameId});

  @override
  final String selectedGameId;

  @override
  String toString() {
    return 'ConfirmSelectionCommand(selectedGameId: $selectedGameId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfirmSelectionCommandImpl &&
            (identical(other.selectedGameId, selectedGameId) ||
                other.selectedGameId == selectedGameId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedGameId);

  /// Create a copy of ConfirmSelectionCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfirmSelectionCommandImplCopyWith<_$ConfirmSelectionCommandImpl>
  get copyWith =>
      __$$ConfirmSelectionCommandImplCopyWithImpl<
        _$ConfirmSelectionCommandImpl
      >(this, _$identity);
}

abstract class _ConfirmSelectionCommand implements ConfirmSelectionCommand {
  const factory _ConfirmSelectionCommand({
    required final String selectedGameId,
  }) = _$ConfirmSelectionCommandImpl;

  @override
  String get selectedGameId;

  /// Create a copy of ConfirmSelectionCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfirmSelectionCommandImplCopyWith<_$ConfirmSelectionCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}
