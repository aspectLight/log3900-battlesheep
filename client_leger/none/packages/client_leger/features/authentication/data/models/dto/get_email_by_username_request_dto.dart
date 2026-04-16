import 'package:json_annotation/json_annotation.dart';

part 'get_email_by_username_request_dto.g.dart';

@JsonSerializable()
class GetEmailByUsernameRequestDto {
  final String username;

  const GetEmailByUsernameRequestDto({required this.username});

  factory GetEmailByUsernameRequestDto.fromJson(Map<String, dynamic> json) =>
      _$GetEmailByUsernameRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetEmailByUsernameRequestDtoToJson(this);
}
