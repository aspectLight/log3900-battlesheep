// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_ui.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChatMessageUi {
  ChatMessageType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  bool get isMe => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessageUi
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageUiCopyWith<ChatMessageUi> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageUiCopyWith<$Res> {
  factory $ChatMessageUiCopyWith(
    ChatMessageUi value,
    $Res Function(ChatMessageUi) then,
  ) = _$ChatMessageUiCopyWithImpl<$Res, ChatMessageUi>;
  @useResult
  $Res call({
    ChatMessageType type,
    String name,
    String content,
    String time,
    bool isMe,
  });
}

/// @nodoc
class _$ChatMessageUiCopyWithImpl<$Res, $Val extends ChatMessageUi>
    implements $ChatMessageUiCopyWith<$Res> {
  _$ChatMessageUiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessageUi
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? content = null,
    Object? time = null,
    Object? isMe = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ChatMessageType,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            time: null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String,
            isMe: null == isMe
                ? _value.isMe
                : isMe // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatMessageUiImplCopyWith<$Res>
    implements $ChatMessageUiCopyWith<$Res> {
  factory _$$ChatMessageUiImplCopyWith(
    _$ChatMessageUiImpl value,
    $Res Function(_$ChatMessageUiImpl) then,
  ) = __$$ChatMessageUiImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ChatMessageType type,
    String name,
    String content,
    String time,
    bool isMe,
  });
}

/// @nodoc
class __$$ChatMessageUiImplCopyWithImpl<$Res>
    extends _$ChatMessageUiCopyWithImpl<$Res, _$ChatMessageUiImpl>
    implements _$$ChatMessageUiImplCopyWith<$Res> {
  __$$ChatMessageUiImplCopyWithImpl(
    _$ChatMessageUiImpl _value,
    $Res Function(_$ChatMessageUiImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMessageUi
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? content = null,
    Object? time = null,
    Object? isMe = null,
  }) {
    return _then(
      _$ChatMessageUiImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ChatMessageType,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String,
        isMe: null == isMe
            ? _value.isMe
            : isMe // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ChatMessageUiImpl implements _ChatMessageUi {
  const _$ChatMessageUiImpl({
    required this.type,
    required this.name,
    required this.content,
    required this.time,
    required this.isMe,
  });

  @override
  final ChatMessageType type;
  @override
  final String name;
  @override
  final String content;
  @override
  final String time;
  @override
  final bool isMe;

  @override
  String toString() {
    return 'ChatMessageUi(type: $type, name: $name, content: $content, time: $time, isMe: $isMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageUiImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.isMe, isMe) || other.isMe == isMe));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, name, content, time, isMe);

  /// Create a copy of ChatMessageUi
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageUiImplCopyWith<_$ChatMessageUiImpl> get copyWith =>
      __$$ChatMessageUiImplCopyWithImpl<_$ChatMessageUiImpl>(this, _$identity);
}

abstract class _ChatMessageUi implements ChatMessageUi {
  const factory _ChatMessageUi({
    required final ChatMessageType type,
    required final String name,
    required final String content,
    required final String time,
    required final bool isMe,
  }) = _$ChatMessageUiImpl;

  @override
  ChatMessageType get type;
  @override
  String get name;
  @override
  String get content;
  @override
  String get time;
  @override
  bool get isMe;

  /// Create a copy of ChatMessageUi
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageUiImplCopyWith<_$ChatMessageUiImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
