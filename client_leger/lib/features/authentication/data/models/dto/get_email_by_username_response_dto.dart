import 'package:json_annotation/json_annotation.dart';

part 'get_email_by_username_response_dto.g.dart';

@JsonSerializable()
class GetEmailByUsernameResponseDto {
  final String email;

  const GetEmailByUsernameResponseDto({required this.email});

  factory GetEmailByUsernameResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GetEmailByUsernameResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetEmailByUsernameResponseDtoToJson(this);
}

