import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_commands.freezed.dart';

@freezed
class SignInCommand with _$SignInCommand {
  const factory SignInCommand({
    required String username,
    required String password,
  }) = _SignInCommand;
}

@freezed
class SignUpCommand with _$SignUpCommand {
  const factory SignUpCommand({
    required String username,
    required String email,
    required String password,
    required String avatarId,
    String? language,
    String? theme,
  }) = _SignUpCommand;
}

@freezed
class SignOutCommand with _$SignOutCommand {
  const factory SignOutCommand() = _SignOutCommand;
}

@freezed
class UpdateProfileCommand with _$UpdateProfileCommand {
  const factory UpdateProfileCommand({
    String? username,
    String? email,
    String? avatarId,
  }) = _UpdateProfileCommand;
}

@freezed
class DeleteAccountCommand with _$DeleteAccountCommand {
  const factory DeleteAccountCommand() = _DeleteAccountCommand;
}
