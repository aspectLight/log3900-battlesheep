// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_commands.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SendChatMessageCommand {
  String get username => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get avatarId => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// Create a copy of SendChatMessageCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendChatMessageCommandCopyWith<SendChatMessageCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendChatMessageCommandCopyWith<$Res> {
  factory $SendChatMessageCommandCopyWith(
    SendChatMessageCommand value,
    $Res Function(SendChatMessageCommand) then,
  ) = _$SendChatMessageCommandCopyWithImpl<$Res, SendChatMessageCommand>;
  @useResult
  $Res call({
    String username,
    String content,
    String? avatarId,
    String? avatarUrl,
  });
}

/// @nodoc
class _$SendChatMessageCommandCopyWithImpl<
  $Res,
  $Val extends SendChatMessageCommand
>
    implements $SendChatMessageCommandCopyWith<$Res> {
  _$SendChatMessageCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendChatMessageCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? content = null,
    Object? avatarId = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarId: freezed == avatarId
                ? _value.avatarId
                : avatarId // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SendChatMessageCommandImplCopyWith<$Res>
    implements $SendChatMessageCommandCopyWith<$Res> {
  factory _$$SendChatMessageCommandImplCopyWith(
    _$SendChatMessageCommandImpl value,
    $Res Function(_$SendChatMessageCommandImpl) then,
  ) = __$$SendChatMessageCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String username,
    String content,
    String? avatarId,
    String? avatarUrl,
  });
}

/// @nodoc
class __$$SendChatMessageCommandImplCopyWithImpl<$Res>
    extends
        _$SendChatMessageCommandCopyWithImpl<$Res, _$SendChatMessageCommandImpl>
    implements _$$SendChatMessageCommandImplCopyWith<$Res> {
  __$$SendChatMessageCommandImplCopyWithImpl(
    _$SendChatMessageCommandImpl _value,
    $Res Function(_$SendChatMessageCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SendChatMessageCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? content = null,
    Object? avatarId = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(
      _$SendChatMessageCommandImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarId: freezed == avatarId
            ? _value.avatarId
            : avatarId // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$SendChatMessageCommandImpl implements _SendChatMessageCommand {
  const _$SendChatMessageCommandImpl({
    required this.username,
    required this.content,
    this.avatarId,
    this.avatarUrl,
  });

  @override
  final String username;
  @override
  final String content;
  @override
  final String? avatarId;
  @override
  final String? avatarUrl;

  @override
  String toString() {
    return 'SendChatMessageCommand(username: $username, content: $content, avatarId: $avatarId, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendChatMessageCommandImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.avatarId, avatarId) ||
                other.avatarId == avatarId) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, username, content, avatarId, avatarUrl);

  /// Create a copy of SendChatMessageCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendChatMessageCommandImplCopyWith<_$SendChatMessageCommandImpl>
  get copyWith =>
      __$$SendChatMessageCommandImplCopyWithImpl<_$SendChatMessageCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _SendChatMessageCommand implements SendChatMessageCommand {
  const factory _SendChatMessageCommand({
    required final String username,
    required final String content,
    final String? avatarId,
    final String? avatarUrl,
  }) = _$SendChatMessageCommandImpl;

  @override
  String get username;
  @override
  String get content;
  @override
  String? get avatarId;
  @override
  String? get avatarUrl;

  /// Create a copy of SendChatMessageCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendChatMessageCommandImplCopyWith<_$SendChatMessageCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SendChatEmojiCommand {
  String get username => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;

  /// Create a copy of SendChatEmojiCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendChatEmojiCommandCopyWith<SendChatEmojiCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendChatEmojiCommandCopyWith<$Res> {
  factory $SendChatEmojiCommandCopyWith(
    SendChatEmojiCommand value,
    $Res Function(SendChatEmojiCommand) then,
  ) = _$SendChatEmojiCommandCopyWithImpl<$Res, SendChatEmojiCommand>;
  @useResult
  $Res call({String username, String emoji});
}

/// @nodoc
class _$SendChatEmojiCommandCopyWithImpl<
  $Res,
  $Val extends SendChatEmojiCommand
>
    implements $SendChatEmojiCommandCopyWith<$Res> {
  _$SendChatEmojiCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendChatEmojiCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null, Object? emoji = null}) {
    return _then(
      _value.copyWith(
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            emoji: null == emoji
                ? _value.emoji
                : emoji // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SendChatEmojiCommandImplCopyWith<$Res>
    implements $SendChatEmojiCommandCopyWith<$Res> {
  factory _$$SendChatEmojiCommandImplCopyWith(
    _$SendChatEmojiCommandImpl value,
    $Res Function(_$SendChatEmojiCommandImpl) then,
  ) = __$$SendChatEmojiCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String emoji});
}

/// @nodoc
class __$$SendChatEmojiCommandImplCopyWithImpl<$Res>
    extends _$SendChatEmojiCommandCopyWithImpl<$Res, _$SendChatEmojiCommandImpl>
    implements _$$SendChatEmojiCommandImplCopyWith<$Res> {
  __$$SendChatEmojiCommandImplCopyWithImpl(
    _$SendChatEmojiCommandImpl _value,
    $Res Function(_$SendChatEmojiCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SendChatEmojiCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null, Object? emoji = null}) {
    return _then(
      _$SendChatEmojiCommandImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        emoji: null == emoji
            ? _value.emoji
            : emoji // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SendChatEmojiCommandImpl implements _SendChatEmojiCommand {
  const _$SendChatEmojiCommandImpl({
    required this.username,
    required this.emoji,
  });

  @override
  final String username;
  @override
  final String emoji;

  @override
  String toString() {
    return 'SendChatEmojiCommand(username: $username, emoji: $emoji)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendChatEmojiCommandImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.emoji, emoji) || other.emoji == emoji));
  }

  @override
  int get hashCode => Object.hash(runtimeType, username, emoji);

  /// Create a copy of SendChatEmojiCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendChatEmojiCommandImplCopyWith<_$SendChatEmojiCommandImpl>
  get copyWith =>
      __$$SendChatEmojiCommandImplCopyWithImpl<_$SendChatEmojiCommandImpl>(
        this,
        _$identity,
      );
}

abstract class _SendChatEmojiCommand implements SendChatEmojiCommand {
  const factory _SendChatEmojiCommand({
    required final String username,
    required final String emoji,
  }) = _$SendChatEmojiCommandImpl;

  @override
  String get username;
  @override
  String get emoji;

  /// Create a copy of SendChatEmojiCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendChatEmojiCommandImplCopyWith<_$SendChatEmojiCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}
