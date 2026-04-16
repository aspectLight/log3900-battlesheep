import '../../../domain/models/user.dart';
import '../dto/user_dto.dart';

extension UserDtoToModel on UserDto {
  UserModel toModel() => UserModel(
    uid: id,
    firebaseUid: firebaseUid,
    email: email,
    username: username,
    avatarId: avatarId,
    avatarUrl: avatarUrl,
  );
}
