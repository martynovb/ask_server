import 'package:ask_server/models/user.dart';
import 'package:collection/collection.dart';

class UsersService {
  final _users = <User>[User(email: 'user@mail.com', firstName: 'Test')];

  Future<User?> findUserByEmail({required String email}) async =>
      _users.firstWhereOrNull((user) => user.email == email);
}
