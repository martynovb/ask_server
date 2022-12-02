import 'package:alfred/alfred.dart';
import 'package:ask_server/models/user.dart';
import 'package:ask_server/services/services.dart';

class UsersRoute {
  static currentUser(HttpRequest req, HttpResponse res) {
    final user = User(email: 'test@mail.com');
    return user;
  }

  static login(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    final user = await services.usersService.findUserByEmail(
      email: body['email'],
    );

    if (user == null) {
      throw AlfredException(401, {'message': 'invalid user'});
    }
  }

  static createAccount(HttpRequest req, HttpResponse res) {}
}
