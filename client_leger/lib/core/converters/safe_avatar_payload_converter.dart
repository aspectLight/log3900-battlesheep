import 'package:json_annotation/json_annotation.dart';

// Server may send avatar as a non-Map (e.g. string or omitted). The generated
// fromJson would cast and throw; this converter treats non-Map as null so
// parsing never crashes and we fall back to default character resolution.
class SafeAvatarPayloadConverter
    implements JsonConverter<Map<String, dynamic>?, dynamic> {
  const SafeAvatarPayloadConverter();

  @override
  Map<String, dynamic>? fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return json;
    if (json is String && json.isNotEmpty) {
      return {'name': json};
    }
    return null;
  }

  @override
  dynamic toJson(Map<String, dynamic>? object) => object;
}
