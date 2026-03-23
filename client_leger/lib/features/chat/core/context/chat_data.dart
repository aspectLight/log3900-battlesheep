import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_data.freezed.dart';

@freezed
class ChatData with _$ChatData {
  const factory ChatData({
    required String username,
  }) = _ChatData;
}
