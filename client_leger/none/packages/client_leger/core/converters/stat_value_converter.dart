import 'package:json_annotation/json_annotation.dart';

class StatValueConverter implements JsonConverter<int, dynamic> {
  const StatValueConverter();

  @override
  int fromJson(dynamic json) {
    if (json == null) return 0;
    if (json is num) return json.toInt();
    if (json is! Map) return 0;
    final v = json['value'];
    if (v is! num) return 0;
    return v.toInt();
  }

  @override
  dynamic toJson(int object) => object;
}
