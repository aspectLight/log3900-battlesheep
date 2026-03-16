class WaitingRoomErrorPayloadDto {
  const WaitingRoomErrorPayloadDto({required this.error});

  final String error;

  factory WaitingRoomErrorPayloadDto.fromJson(Map<String, dynamic> json) {
    return WaitingRoomErrorPayloadDto(error: json['error'] as String);
  }
}
