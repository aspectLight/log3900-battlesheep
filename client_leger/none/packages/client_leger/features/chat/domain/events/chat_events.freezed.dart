// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChatMessageAddedEvent {
  ChatMessage get message => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessageAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageAddedEventCopyWith<ChatMessageAddedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageAddedEventCopyWith<$Res> {
  factory $ChatMessageAddedEventCopyWith(
    ChatMessageAddedEvent value,
    $Res Function(ChatMessageAddedEvent) then,
  ) = _$ChatMessageAddedEventCopyWithImpl<$Res, ChatMessageAddedEvent>;
  @useResult
  $Res call({ChatMessage message});

  $ChatMessageCopyWith<$Res> get message;
}

/// @nodoc
class _$ChatMessageAddedEventCopyWithImpl<
  $Res,
  $Val extends ChatMessageAddedEvent
>
    implements $ChatMessageAddedEventCopyWith<$Res> {
  _$ChatMessageAddedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessageAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as ChatMessage,
          )
          as $Val,
    );
  }

  /// Create a copy of ChatMessageAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<$Res> get message {
    return $ChatMessageCopyWith<$Res>(_value.message, (value) {
      return _then(_value.copyWith(message: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatMessageAddedEventImplCopyWith<$Res>
    implements $ChatMessageAddedEventCopyWith<$Res> {
  factory _$$ChatMessageAddedEventImplCopyWith(
    _$ChatMessageAddedEventImpl value,
    $Res Function(_$ChatMessageAddedEventImpl) then,
  ) = __$$ChatMessageAddedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ChatMessage message});

  @override
  $ChatMessageCopyWith<$Res> get message;
}

/// @nodoc
class __$$ChatMessageAddedEventImplCopyWithImpl<$Res>
    extends
        _$ChatMessageAddedEventCopyWithImpl<$Res, _$ChatMessageAddedEventImpl>
    implements _$$ChatMessageAddedEventImplCopyWith<$Res> {
  __$$ChatMessageAddedEventImplCopyWithImpl(
    _$ChatMessageAddedEventImpl _value,
    $Res Function(_$ChatMessageAddedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMessageAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ChatMessageAddedEventImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as ChatMessage,
      ),
    );
  }
}

/// @nodoc

class _$ChatMessageAddedEventImpl implements _ChatMessageAddedEvent {
  const _$ChatMessageAddedEventImpl(this.message);

  @override
  final ChatMessage message;

  @override
  String toString() {
    return 'ChatMessageAddedEvent(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageAddedEventImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ChatMessageAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageAddedEventImplCopyWith<_$ChatMessageAddedEventImpl>
  get copyWith =>
      __$$ChatMessageAddedEventImplCopyWithImpl<_$ChatMessageAddedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _ChatMessageAddedEvent implements ChatMessageAddedEvent {
  const factory _ChatMessageAddedEvent(final ChatMessage message) =
      _$ChatMessageAddedEventImpl;

  @override
  ChatMessage get message;

  /// Create a copy of ChatMessageAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageAddedEventImplCopyWith<_$ChatMessageAddedEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ChatHistorySetEvent {
  List<ChatMessage> get messages => throw _privateConstructorUsedError;

  /// Create a copy of ChatHistorySetEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatHistorySetEventCopyWith<ChatHistorySetEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatHistorySetEventCopyWith<$Res> {
  factory $ChatHistorySetEventCopyWith(
    ChatHistorySetEvent value,
    $Res Function(ChatHistorySetEvent) then,
  ) = _$ChatHistorySetEventCopyWithImpl<$Res, ChatHistorySetEvent>;
  @useResult
  $Res call({List<ChatMessage> messages});
}

/// @nodoc
class _$ChatHistorySetEventCopyWithImpl<$Res, $Val extends ChatHistorySetEvent>
    implements $ChatHistorySetEventCopyWith<$Res> {
  _$ChatHistorySetEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatHistorySetEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? messages = null}) {
    return _then(
      _value.copyWith(
            messages: null == messages
                ? _value.messages
                : messages // ignore: cast_nullable_to_non_nullable
                      as List<ChatMessage>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatHistorySetEventImplCopyWith<$Res>
    implements $ChatHistorySetEventCopyWith<$Res> {
  factory _$$ChatHistorySetEventImplCopyWith(
    _$ChatHistorySetEventImpl value,
    $Res Function(_$ChatHistorySetEventImpl) then,
  ) = __$$ChatHistorySetEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ChatMessage> messages});
}

/// @nodoc
class __$$ChatHistorySetEventImplCopyWithImpl<$Res>
    extends _$ChatHistorySetEventCopyWithImpl<$Res, _$ChatHistorySetEventImpl>
    implements _$$ChatHistorySetEventImplCopyWith<$Res> {
  __$$ChatHistorySetEventImplCopyWithImpl(
    _$ChatHistorySetEventImpl _value,
    $Res Function(_$ChatHistorySetEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatHistorySetEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? messages = null}) {
    return _then(
      _$ChatHistorySetEventImpl(
        null == messages
            ? _value._messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as List<ChatMessage>,
      ),
    );
  }
}

/// @nodoc

class _$ChatHistorySetEventImpl implements _ChatHistorySetEvent {
  const _$ChatHistorySetEventImpl(final List<ChatMessage> messages)
    : _messages = messages;

  final List<ChatMessage> _messages;
  @override
  List<ChatMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'ChatHistorySetEvent(messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatHistorySetEventImpl &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_messages));

  /// Create a copy of ChatHistorySetEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatHistorySetEventImplCopyWith<_$ChatHistorySetEventImpl> get copyWith =>
      __$$ChatHistorySetEventImplCopyWithImpl<_$ChatHistorySetEventImpl>(
        this,
        _$identity,
      );
}

abstract class _ChatHistorySetEvent implements ChatHistorySetEvent {
  const factory _ChatHistorySetEvent(final List<ChatMessage> messages) =
      _$ChatHistorySetEventImpl;

  @override
  List<ChatMessage> get messages;

  /// Create a copy of ChatHistorySetEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatHistorySetEventImplCopyWith<_$ChatHistorySetEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
