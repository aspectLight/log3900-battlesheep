import 'package:json_annotation/json_annotation.dart';

part 'auth_error_response_dto.g.dart';

@JsonSerializable()
class AuthErrorResponseDto {
  @JsonKey(name: 'message', fromJson: AuthErrorResponseDto._messagesFromJson)
  final List<String> messages;

  const AuthErrorResponseDto({required this.messages});

  factory AuthErrorResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthErrorResponseDtoFromJson(json);

  static List<String> _messagesFromJson(Object? value) => switch (value) {
    null => const [],
    final String s => [s],
    final List l => l.whereType<String>().toList(),
    _ => const [],
  };

  String? get errorMessage => messages.isEmpty ? null : messages.join(', ');

  bool get isUsernameConflict => messages.any((m) {
    final lower = m.toLowerCase();
    return lower.contains("nom d'utilisateur") || lower.contains('username');
  });
}
