import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_reserved_characters_command.freezed.dart';

@freezed
class GetReservedCharactersCommand with _$GetReservedCharactersCommand {
  const factory GetReservedCharactersCommand({required String roomId}) =
      _GetReservedCharactersCommand;
}
