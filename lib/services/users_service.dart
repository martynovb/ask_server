import 'package:ask_server/models/user.dart';
import 'package:collection/collection.dart';

class UsersService {
  final _users = <User>[
    User(email: 'test@email.com', firstName: 'Test', password: 'password')..setPassword('password'),
  ];

  Future<User?> findUserByEmail({required String email}) async =>
      _users.firstWhereOrNull((user) => user.email == email);
}
