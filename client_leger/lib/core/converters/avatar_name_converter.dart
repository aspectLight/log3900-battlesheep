import 'package:json_annotation/json_annotation.dart';

class AvatarNameConverter implements JsonConverter<String, dynamic> {
  const AvatarNameConverter();

  @override
  String fromJson(dynamic json) {
    if (json is Map && json['name'] is String) return json['name'] as String;
    if (json is String) return json;
    return '';
  }

  @override
  dynamic toJson(String object) => object;
}
