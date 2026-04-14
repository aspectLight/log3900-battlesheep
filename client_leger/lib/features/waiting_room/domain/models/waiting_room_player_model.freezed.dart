// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waiting_room_player_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WaitingRoomPlayerModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Character get character => throw _privateConstructorUsedError;
  WaitingRoomPlayerStatsModel get stats => throw _privateConstructorUsedError;
  String? get avatarDisplayPath => throw _privateConstructorUsedError;
  String? get profileAvatarId => throw _privateConstructorUsedError;
  String? get profileAvatarUrl => throw _privateConstructorUsedError;
  String? get activeBanner => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )
    human,
    required TResult Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      VirtualPlayerType virtualType,
      DiceStatChoice? d6Choice,
      DiceStatChoice? d4Choice,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )
    virtual,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )?
    human,
    TResult? Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      VirtualPlayerType virtualType,
      DiceStatChoice? d6Choice,
      DiceStatChoice? d4Choice,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )?
    virtual,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )?
    human,
    TResult Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      VirtualPlayerType virtualType,
      DiceStatChoice? d6Choice,
      DiceStatChoice? d4Choice,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )?
    virtual,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HumanWaitingRoomPlayerModel value) human,
    required TResult Function(VirtualWaitingRoomPlayerModel value) virtual,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HumanWaitingRoomPlayerModel value)? human,
    TResult? Function(VirtualWaitingRoomPlayerModel value)? virtual,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HumanWaitingRoomPlayerModel value)? human,
    TResult Function(VirtualWaitingRoomPlayerModel value)? virtual,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of WaitingRoomPlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaitingRoomPlayerModelCopyWith<WaitingRoomPlayerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaitingRoomPlayerModelCopyWith<$Res> {
  factory $WaitingRoomPlayerModelCopyWith(
    WaitingRoomPlayerModel value,
    $Res Function(WaitingRoomPlayerModel) then,
  ) = _$WaitingRoomPlayerModelCopyWithImpl<$Res, WaitingRoomPlayerModel>;
  @useResult
  $Res call({
    String id,
    String name,
    Character character,
    WaitingRoomPlayerStatsModel stats,
    String? avatarDisplayPath,
    String? profileAvatarId,
    String? profileAvatarUrl,
    String? activeBanner,
  });

  $WaitingRoomPlayerStatsModelCopyWith<$Res> get stats;
}

/// @nodoc
class _$WaitingRoomPlayerModelCopyWithImpl<
  $Res,
  $Val extends WaitingRoomPlayerModel
>
    implements $WaitingRoomPlayerModelCopyWith<$Res> {
  _$WaitingRoomPlayerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaitingRoomPlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? character = null,
    Object? stats = null,
    Object? avatarDisplayPath = freezed,
    Object? profileAvatarId = freezed,
    Object? profileAvatarUrl = freezed,
    Object? activeBanner = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            character: null == character
                ? _value.character
                : character // ignore: cast_nullable_to_non_nullable
                      as Character,
            stats: null == stats
                ? _value.stats
                : stats // ignore: cast_nullable_to_non_nullable
                      as WaitingRoomPlayerStatsModel,
            avatarDisplayPath: freezed == avatarDisplayPath
                ? _value.avatarDisplayPath
                : avatarDisplayPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            profileAvatarId: freezed == profileAvatarId
                ? _value.profileAvatarId
                : profileAvatarId // ignore: cast_nullable_to_non_nullable
                      as String?,
            profileAvatarUrl: freezed == profileAvatarUrl
                ? _value.profileAvatarUrl
                : profileAvatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            activeBanner: freezed == activeBanner
                ? _value.activeBanner
                : activeBanner // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of WaitingRoomPlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WaitingRoomPlayerStatsModelCopyWith<$Res> get stats {
    return $WaitingRoomPlayerStatsModelCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HumanWaitingRoomPlayerModelImplCopyWith<$Res>
    implements $WaitingRoomPlayerModelCopyWith<$Res> {
  factory _$$HumanWaitingRoomPlayerModelImplCopyWith(
    _$HumanWaitingRoomPlayerModelImpl value,
    $Res Function(_$HumanWaitingRoomPlayerModelImpl) then,
  ) = __$$HumanWaitingRoomPlayerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    Character character,
    WaitingRoomPlayerStatsModel stats,
    String? avatarDisplayPath,
    String? profileAvatarId,
    String? profileAvatarUrl,
    String? activeBanner,
  });

  @override
  $WaitingRoomPlayerStatsModelCopyWith<$Res> get stats;
}

/// @nodoc
class __$$HumanWaitingRoomPlayerModelImplCopyWithImpl<$Res>
    extends
        _$WaitingRoomPlayerModelCopyWithImpl<
          $Res,
          _$HumanWaitingRoomPlayerModelImpl
        >
    implements _$$HumanWaitingRoomPlayerModelImplCopyWith<$Res> {
  __$$HumanWaitingRoomPlayerModelImplCopyWithImpl(
    _$HumanWaitingRoomPlayerModelImpl _value,
    $Res Function(_$HumanWaitingRoomPlayerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaitingRoomPlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? character = null,
    Object? stats = null,
    Object? avatarDisplayPath = freezed,
    Object? profileAvatarId = freezed,
    Object? profileAvatarUrl = freezed,
    Object? activeBanner = freezed,
  }) {
    return _then(
      _$HumanWaitingRoomPlayerModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        character: null == character
            ? _value.character
            : character // ignore: cast_nullable_to_non_nullable
                  as Character,
        stats: null == stats
            ? _value.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as WaitingRoomPlayerStatsModel,
        avatarDisplayPath: freezed == avatarDisplayPath
            ? _value.avatarDisplayPath
            : avatarDisplayPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        profileAvatarId: freezed == profileAvatarId
            ? _value.profileAvatarId
            : profileAvatarId // ignore: cast_nullable_to_non_nullable
                  as String?,
        profileAvatarUrl: freezed == profileAvatarUrl
            ? _value.profileAvatarUrl
            : profileAvatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        activeBanner: freezed == activeBanner
            ? _value.activeBanner
            : activeBanner // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$HumanWaitingRoomPlayerModelImpl implements HumanWaitingRoomPlayerModel {
  const _$HumanWaitingRoomPlayerModelImpl({
    required this.id,
    required this.name,
    required this.character,
    required this.stats,
    this.avatarDisplayPath,
    this.profileAvatarId,
    this.profileAvatarUrl,
    this.activeBanner,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final Character character;
  @override
  final WaitingRoomPlayerStatsModel stats;
  @override
  final String? avatarDisplayPath;
  @override
  final String? profileAvatarId;
  @override
  final String? profileAvatarUrl;
  @override
  final String? activeBanner;

  @override
  String toString() {
    return 'WaitingRoomPlayerModel.human(id: $id, name: $name, character: $character, stats: $stats, avatarDisplayPath: $avatarDisplayPath, profileAvatarId: $profileAvatarId, profileAvatarUrl: $profileAvatarUrl, activeBanner: $activeBanner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HumanWaitingRoomPlayerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.character, character) ||
                other.character == character) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.avatarDisplayPath, avatarDisplayPath) ||
                other.avatarDisplayPath == avatarDisplayPath) &&
            (identical(other.profileAvatarId, profileAvatarId) ||
                other.profileAvatarId == profileAvatarId) &&
            (identical(other.profileAvatarUrl, profileAvatarUrl) ||
                other.profileAvatarUrl == profileAvatarUrl) &&
            (identical(other.activeBanner, activeBanner) ||
                other.activeBanner == activeBanner));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    character,
    stats,
    avatarDisplayPath,
    profileAvatarId,
    profileAvatarUrl,
    activeBanner,
  );

  /// Create a copy of WaitingRoomPlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HumanWaitingRoomPlayerModelImplCopyWith<_$HumanWaitingRoomPlayerModelImpl>
  get copyWith =>
      __$$HumanWaitingRoomPlayerModelImplCopyWithImpl<
        _$HumanWaitingRoomPlayerModelImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )
    human,
    required TResult Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      VirtualPlayerType virtualType,
      DiceStatChoice? d6Choice,
      DiceStatChoice? d4Choice,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )
    virtual,
  }) {
    return human(
      id,
      name,
      character,
      stats,
      avatarDisplayPath,
      profileAvatarId,
      profileAvatarUrl,
      activeBanner,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )?
    human,
    TResult? Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      VirtualPlayerType virtualType,
      DiceStatChoice? d6Choice,
      DiceStatChoice? d4Choice,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )?
    virtual,
  }) {
    return human?.call(
      id,
      name,
      character,
      stats,
      avatarDisplayPath,
      profileAvatarId,
      profileAvatarUrl,
      activeBanner,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )?
    human,
    TResult Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      VirtualPlayerType virtualType,
      DiceStatChoice? d6Choice,
      DiceStatChoice? d4Choice,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )?
    virtual,
    required TResult orElse(),
  }) {
    if (human != null) {
      return human(
        id,
        name,
        character,
        stats,
        avatarDisplayPath,
        profileAvatarId,
        profileAvatarUrl,
        activeBanner,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HumanWaitingRoomPlayerModel value) human,
    required TResult Function(VirtualWaitingRoomPlayerModel value) virtual,
  }) {
    return human(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HumanWaitingRoomPlayerModel value)? human,
    TResult? Function(VirtualWaitingRoomPlayerModel value)? virtual,
  }) {
    return human?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HumanWaitingRoomPlayerModel value)? human,
    TResult Function(VirtualWaitingRoomPlayerModel value)? virtual,
    required TResult orElse(),
  }) {
    if (human != null) {
      return human(this);
    }
    return orElse();
  }
}

abstract class HumanWaitingRoomPlayerModel implements WaitingRoomPlayerModel {
  const factory HumanWaitingRoomPlayerModel({
    required final String id,
    required final String name,
    required final Character character,
    required final WaitingRoomPlayerStatsModel stats,
    final String? avatarDisplayPath,
    final String? profileAvatarId,
    final String? profileAvatarUrl,
    final String? activeBanner,
  }) = _$HumanWaitingRoomPlayerModelImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  Character get character;
  @override
  WaitingRoomPlayerStatsModel get stats;
  @override
  String? get avatarDisplayPath;
  @override
  String? get profileAvatarId;
  @override
  String? get profileAvatarUrl;
  @override
  String? get activeBanner;

  /// Create a copy of WaitingRoomPlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HumanWaitingRoomPlayerModelImplCopyWith<_$HumanWaitingRoomPlayerModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VirtualWaitingRoomPlayerModelImplCopyWith<$Res>
    implements $WaitingRoomPlayerModelCopyWith<$Res> {
  factory _$$VirtualWaitingRoomPlayerModelImplCopyWith(
    _$VirtualWaitingRoomPlayerModelImpl value,
    $Res Function(_$VirtualWaitingRoomPlayerModelImpl) then,
  ) = __$$VirtualWaitingRoomPlayerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    Character character,
    WaitingRoomPlayerStatsModel stats,
    VirtualPlayerType virtualType,
    DiceStatChoice? d6Choice,
    DiceStatChoice? d4Choice,
    String? avatarDisplayPath,
    String? profileAvatarId,
    String? profileAvatarUrl,
    String? activeBanner,
  });

  @override
  $WaitingRoomPlayerStatsModelCopyWith<$Res> get stats;
}

/// @nodoc
class __$$VirtualWaitingRoomPlayerModelImplCopyWithImpl<$Res>
    extends
        _$WaitingRoomPlayerModelCopyWithImpl<
          $Res,
          _$VirtualWaitingRoomPlayerModelImpl
        >
    implements _$$VirtualWaitingRoomPlayerModelImplCopyWith<$Res> {
  __$$VirtualWaitingRoomPlayerModelImplCopyWithImpl(
    _$VirtualWaitingRoomPlayerModelImpl _value,
    $Res Function(_$VirtualWaitingRoomPlayerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaitingRoomPlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? character = null,
    Object? stats = null,
    Object? virtualType = null,
    Object? d6Choice = freezed,
    Object? d4Choice = freezed,
    Object? avatarDisplayPath = freezed,
    Object? profileAvatarId = freezed,
    Object? profileAvatarUrl = freezed,
    Object? activeBanner = freezed,
  }) {
    return _then(
      _$VirtualWaitingRoomPlayerModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        character: null == character
            ? _value.character
            : character // ignore: cast_nullable_to_non_nullable
                  as Character,
        stats: null == stats
            ? _value.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as WaitingRoomPlayerStatsModel,
        virtualType: null == virtualType
            ? _value.virtualType
            : virtualType // ignore: cast_nullable_to_non_nullable
                  as VirtualPlayerType,
        d6Choice: freezed == d6Choice
            ? _value.d6Choice
            : d6Choice // ignore: cast_nullable_to_non_nullable
                  as DiceStatChoice?,
        d4Choice: freezed == d4Choice
            ? _value.d4Choice
            : d4Choice // ignore: cast_nullable_to_non_nullable
                  as DiceStatChoice?,
        avatarDisplayPath: freezed == avatarDisplayPath
            ? _value.avatarDisplayPath
            : avatarDisplayPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        profileAvatarId: freezed == profileAvatarId
            ? _value.profileAvatarId
            : profileAvatarId // ignore: cast_nullable_to_non_nullable
                  as String?,
        profileAvatarUrl: freezed == profileAvatarUrl
            ? _value.profileAvatarUrl
            : profileAvatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        activeBanner: freezed == activeBanner
            ? _value.activeBanner
            : activeBanner // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$VirtualWaitingRoomPlayerModelImpl
    implements VirtualWaitingRoomPlayerModel {
  const _$VirtualWaitingRoomPlayerModelImpl({
    required this.id,
    required this.name,
    required this.character,
    required this.stats,
    required this.virtualType,
    this.d6Choice,
    this.d4Choice,
    this.avatarDisplayPath,
    this.profileAvatarId,
    this.profileAvatarUrl,
    this.activeBanner,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final Character character;
  @override
  final WaitingRoomPlayerStatsModel stats;
  @override
  final VirtualPlayerType virtualType;
  @override
  final DiceStatChoice? d6Choice;
  @override
  final DiceStatChoice? d4Choice;
  @override
  final String? avatarDisplayPath;
  @override
  final String? profileAvatarId;
  @override
  final String? profileAvatarUrl;
  @override
  final String? activeBanner;

  @override
  String toString() {
    return 'WaitingRoomPlayerModel.virtual(id: $id, name: $name, character: $character, stats: $stats, virtualType: $virtualType, d6Choice: $d6Choice, d4Choice: $d4Choice, avatarDisplayPath: $avatarDisplayPath, profileAvatarId: $profileAvatarId, profileAvatarUrl: $profileAvatarUrl, activeBanner: $activeBanner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VirtualWaitingRoomPlayerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.character, character) ||
                other.character == character) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.virtualType, virtualType) ||
                other.virtualType == virtualType) &&
            (identical(other.d6Choice, d6Choice) ||
                other.d6Choice == d6Choice) &&
            (identical(other.d4Choice, d4Choice) ||
                other.d4Choice == d4Choice) &&
            (identical(other.avatarDisplayPath, avatarDisplayPath) ||
                other.avatarDisplayPath == avatarDisplayPath) &&
            (identical(other.profileAvatarId, profileAvatarId) ||
                other.profileAvatarId == profileAvatarId) &&
            (identical(other.profileAvatarUrl, profileAvatarUrl) ||
                other.profileAvatarUrl == profileAvatarUrl) &&
            (identical(other.activeBanner, activeBanner) ||
                other.activeBanner == activeBanner));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    character,
    stats,
    virtualType,
    d6Choice,
    d4Choice,
    avatarDisplayPath,
    profileAvatarId,
    profileAvatarUrl,
    activeBanner,
  );

  /// Create a copy of WaitingRoomPlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VirtualWaitingRoomPlayerModelImplCopyWith<
    _$VirtualWaitingRoomPlayerModelImpl
  >
  get copyWith =>
      __$$VirtualWaitingRoomPlayerModelImplCopyWithImpl<
        _$VirtualWaitingRoomPlayerModelImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )
    human,
    required TResult Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      VirtualPlayerType virtualType,
      DiceStatChoice? d6Choice,
      DiceStatChoice? d4Choice,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )
    virtual,
  }) {
    return virtual(
      id,
      name,
      character,
      stats,
      virtualType,
      d6Choice,
      d4Choice,
      avatarDisplayPath,
      profileAvatarId,
      profileAvatarUrl,
      activeBanner,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )?
    human,
    TResult? Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      VirtualPlayerType virtualType,
      DiceStatChoice? d6Choice,
      DiceStatChoice? d4Choice,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )?
    virtual,
  }) {
    return virtual?.call(
      id,
      name,
      character,
      stats,
      virtualType,
      d6Choice,
      d4Choice,
      avatarDisplayPath,
      profileAvatarId,
      profileAvatarUrl,
      activeBanner,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )?
    human,
    TResult Function(
      String id,
      String name,
      Character character,
      WaitingRoomPlayerStatsModel stats,
      VirtualPlayerType virtualType,
      DiceStatChoice? d6Choice,
      DiceStatChoice? d4Choice,
      String? avatarDisplayPath,
      String? profileAvatarId,
      String? profileAvatarUrl,
      String? activeBanner,
    )?
    virtual,
    required TResult orElse(),
  }) {
    if (virtual != null) {
      return virtual(
        id,
        name,
        character,
        stats,
        virtualType,
        d6Choice,
        d4Choice,
        avatarDisplayPath,
        profileAvatarId,
        profileAvatarUrl,
        activeBanner,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HumanWaitingRoomPlayerModel value) human,
    required TResult Function(VirtualWaitingRoomPlayerModel value) virtual,
  }) {
    return virtual(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HumanWaitingRoomPlayerModel value)? human,
    TResult? Function(VirtualWaitingRoomPlayerModel value)? virtual,
  }) {
    return virtual?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HumanWaitingRoomPlayerModel value)? human,
    TResult Function(VirtualWaitingRoomPlayerModel value)? virtual,
    required TResult orElse(),
  }) {
    if (virtual != null) {
      return virtual(this);
    }
    return orElse();
  }
}

abstract class VirtualWaitingRoomPlayerModel implements WaitingRoomPlayerModel {
  const factory VirtualWaitingRoomPlayerModel({
    required final String id,
    required final String name,
    required final Character character,
    required final WaitingRoomPlayerStatsModel stats,
    required final VirtualPlayerType virtualType,
    final DiceStatChoice? d6Choice,
    final DiceStatChoice? d4Choice,
    final String? avatarDisplayPath,
    final String? profileAvatarId,
    final String? profileAvatarUrl,
    final String? activeBanner,
  }) = _$VirtualWaitingRoomPlayerModelImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  Character get character;
  @override
  WaitingRoomPlayerStatsModel get stats;
  VirtualPlayerType get virtualType;
  DiceStatChoice? get d6Choice;
  DiceStatChoice? get d4Choice;
  @override
  String? get avatarDisplayPath;
  @override
  String? get profileAvatarId;
  @override
  String? get profileAvatarUrl;
  @override
  String? get activeBanner;

  /// Create a copy of WaitingRoomPlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VirtualWaitingRoomPlayerModelImplCopyWith<
    _$VirtualWaitingRoomPlayerModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
